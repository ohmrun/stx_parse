package stx.parse.parser.term;

class Many<I,O> extends Base<I,Array<O>,Parser<I,O>>{
  public function new(delegation:Parser<I,O>,?id:Pos){
    __.assert(id).exists(delegation);
    super(delegation,id);
    this.tag = switch (delegation.tag){
      case Some(v)  : Some('($v)*');
      default       : None;
    }
  }
  override public function check(){
    __.that(pos).exists().errata( e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    function rec(input:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>,arr:Array<O>){
      return cont.receive(delegation.toFletcher().forward(input).flat_fold(
        res  -> res.is_ok().if_else(
          () -> {
            res.value.fold(
              v   -> { arr.push(v); null; },
              ()  -> {}
            );
            return Fletcher.lift(rec.bind(_,_,arr)).forward(res.asset);
          },
          () -> cont.value(if(res.error.is_fatal()){
            input.fail('failed many ${delegation}',true);
          }else{
            input.ok(arr); 
          })
        ),
        no   -> cont.error(no)
      ));
    }
    return cont.receive(Fletcher.lift(rec.bind(_,_,[])).forward(input));
  }
  override public function toString(){
    return 'Many($delegation)';
  }
}