package stx.parse.parser.term;

class Many<P,R> extends Base<P,Array<R>,Parser<P,R>>{
  public function new(delegation:Parser<P,R>,?pos:Pos){
    #if debug__.assert().exists(pos);#end
    super(delegation,pos);
    this.tag = switch (delegation.tag){
      case Some(v)  : Some('($v)*');
      default       : None;
    }
  }
  override public function defer(ipt:ParseInput<P>,cont:Terminal<ParseResult<P,Array<R>>,Noise>):Work{
    return cont.lense(new ManyTask(this.delegation,ipt,cont)).serve();
  }
  override public function apply(ipt:ParseInput<P>):ParseResult<P,Array<R>>{
    function rec(result:ParseResult<P,R>,arr:Array<R>){
      return result.fold(
        (ok:ParseSuccess<P,R>) -> {
          var narr = arr.concat(ok.with.map(x -> [x]).defv([]));
          var next = delegation.apply(ok.rest);
          return rec(next,narr);
        },
        no -> no.rest.ok(arr)
      );
    }
    var result = delegation.apply(ipt);
    return rec(result,[]);
  }
  override public function check(){
    __.assert().exists(delegation);
  }
  override public function get_convention(){
    return this.delegation.convention;
  }
  override public function toString(){
    return 'Many($delegation)';
  }
}
class ManyTask<P,R> extends TaskCls<ParseResult<P,Array<R>>,Noise>{
  var accum         : Array<R>;
  var input         : ParseInput<P>;
  var intermediate  : ParseResult<P,R>;
  var parser        : Parser<P,R>;
  var terminal      : Terminal<ParseResult<P,Array<R>>,Noise>;
  var work          : Work;

  public function new(parser:Parser<P,R>,input:ParseInput<P>,terminal){
    super();
    this.accum        = [];
    this.parser       = parser;
    this.input        = input; 
    this.terminal     = terminal;
    this.work         = Work.ZERO;
  }
  override public function pursue(){
    //trace('pursue this: $this work : ${work.status.toString()}');
    switch([work.status,__.option(intermediate).map(x-> x.ok()).defv(true)]){
      case [Problem,_]      :
        this.defect = work.defect.entype();
        this.status = Problem;
      case [Pending,true]   :
        work.pursue();
        this.status = Pending;
      case [Applied,true]   :
        work.pursue();
        this.status = Pending;
        work = parser.defer(
          this.input,
          terminal.joint(joint)
        );
      case [Working,_]      :
      case [Waiting,_]      :
        this.init_signal();
        this.work.signal.nextTime().handle(
          _ -> {
            this.status = Pending;
            this.trigger.trigger(Noise);
          }
        );
      case [Secured,true]   : 
        work = parser.defer(this.input,terminal.joint(joint));
      case [_,false]        :
        this.status = Secured;
      case [_,true]         :
        this.status = Pending;
    }
  }
  inline function joint(outcome:Reaction<ParseResult<P,R>>){
    return outcome.fold(
      result -> {
        this.intermediate = result;
        result.fold(
          succ -> {
            for (x in succ.with){
              accum.push(x);
            }
            this.input = succ.rest;
            return null;
          },
          (fail) -> {
            this.result = input.ok(this.accum);
            this.status = Secured;
          }
        );
        this.status = Pending;
        return Work.ZERO;
      },
      error -> {
        this.defect = error.entype();
        this.status = Problem;
        return Work.ZERO;
      }
    );
  }
  override public function toString(){
    return 'work: $work accum: $accum intermediate: $intermediate';
  }
}