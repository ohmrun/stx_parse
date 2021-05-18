package stx.parse.parser.term;

import stx.async.Counter;
using stx.parse.parser.term.Many;

function log(wildcard:Wildcard){
  return stx.Log.ZERO.tag("stx.parse.Many");
}
class Many<P,R> extends Base<P,Array<R>,Parser<P,R>>{
  public function new(delegation:Parser<P,R>,?pos:Pos){
    #if debug__.assert().exists(pos);#end
    super(delegation,pos);
    this.id = Counter.next();
  }
  override public function defer(ipt:ParseInput<P>,cont:Terminal<ParseResult<P,Array<R>>,Noise>):Work{
    return cont.lense(new ManyTask(this.delegation,ipt,cont)).serve();
  }
  public function apply(ipt:ParseInput<P>):ParseResult<P,Array<R>>{
    return throw "FAO:";
    //__.log()("APPLY");
    // function rec(result:ParseResult<P,R>,arr:Array<R>){
    //   return result.fold(
    //     (ok:ParseSuccess<P,R>) -> {
    //       var narr = arr.concat(ok.with.map(x -> [x]).defv([]));
    //       var next = delegation.apply(ok.rest);
    //       return rec(next,narr);
    //     },
    //     no -> no.rest.ok(arr)
    //   );
    // }
    // var result = delegation.apply(ipt);
    // return rec(result,[]);
  }
  override public function check(){
    __.assert().exists(delegation);
  }
  override public function toString(){
    return '$delegation*';
  }
}
class ManyTask<P,R> extends stx.async.task.Direct<ParseResult<P,Array<R>>,Noise>{
  var accum         : Array<R>;
  var input         : ParseInput<P>;
  var intermediate  : ParseResult<P,R>;
  var parser        : Parser<P,R>;
  var terminal      : Terminal<ParseResult<P,Array<R>>,Noise>;
  var inner         : Terminal<ParseResult<P,R>,Noise>;
  var work          : Work;

  public function new(parser:Parser<P,R>,input:ParseInput<P>,terminal){
    super();
    //this.id           = Counter.next();
    this.accum        = [];
    this.parser       = parser;
    this.input        = input; 
    this.terminal     = terminal;
    this.work         = Work.ZERO;
  }
  public function pursue(){
    var doing_work = !(this.work == Work.ZERO);
    if(doing_work){
      this.work.pursue();
      if(work.get_loaded()){
        this.work = Work.ZERO;
      }
    }else{
      var intermediate_opt  = __.option(this.intermediate); 
      var intermediate_ok   = intermediate_opt.map(_ -> _.ok()).defv(true);
      if(intermediate_ok){
        if(inner != null){
          throw "SDFGSDFSFDds";
        }
        this.inner = terminal.joint(joint);
        this.work  = parser.defer(
          this.input,
          inner
        );
      }
    }
  }
  inline function joint(outcome:Reaction<ParseResult<P,R>>){
    __.log()('JOINT $id: $outcome');
    return outcome.fold(
      result -> {
        this.intermediate = result;
        return result.fold(
          succ -> {
            for (x in succ.with){
              accum.push(x);
            }
            this.input = succ.rest;
            this.set_status(Pending);
            var res = this.inner.value(succ).serve();
            this.inner == null;
            return res;
          },
          (fail) -> {
            this.result = fail.rest.ok(this.accum);
            this.set_status(Secured);
            var res = this.inner.value(result).serve();
            this.inner = null;
            return res;
          }
        );
      },
      error -> {
        this.defect     = error.entype();
        this.set_status(Problem);
        return inner.error(error).serve();
      }
    );
  }
  override public function toString(){
    return 'status : ${get_status().toString()} work: $work accum: $accum intermediate: $intermediate input $input';
  }
}