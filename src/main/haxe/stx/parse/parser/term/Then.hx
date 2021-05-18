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
  override inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,U>,Noise>){
    return delegation.toFletcher().receive(input).map(
      (res:ParseResult<I,T>) -> res.fold(
        (match)   -> ParseResult.success(match.map(transform)),
        (err)     -> ParseResult.failure(err)
      )
    ).serve();
  }
  inline public function apply(input:ParseInput<I>):ParseResult<I,U>{
    return this.delegation.apply(input).map(this.transform);
  }
  override public function toString(){
    return '$delegation&';
  }
}