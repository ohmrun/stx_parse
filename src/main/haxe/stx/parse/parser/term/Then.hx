package stx.parse.parser.term;

abstract class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  
  public function new(delegation:Parser<I,T>,?pos:Pos){
    super(delegation,pos);
    #if debug
      __.assert().exists(pos);
    #end
    this.tag        = delegation.tag;
  }
  abstract function transform(t:T):U;

  override public function check(){
    __.that(pos).exists().errata(e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,U>,Noise>){
    return cont.receive(delegation.toFletcher().forward(input).map(
      (res:ParseResult<I,T>) -> res.fold(
        (match)   -> ParseResult.success(match.map(transform)),
        (err)     -> ParseResult.failure(err)
      )
    ));
  }
  override public function toString(){
    return '$delegation&';
  }
}