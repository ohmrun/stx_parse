package stx.parse.pack.parser.term;

class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  var transform : T -> U;

  public function new(delegation:Parser<I,T>,transform:T->U,?id:Pos){
    super(delegation,id);
    #if debug
      __.assert().exists(id);
    #end
    this.transform  = transform; 
    this.tag        = delegation.tag;
  }
  override public function check(){
    __.that(pos).exists().errata(e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  override inline public function defer(input:Input<I>,cont:Terminal<ParseResult<I,U>,Noise>){
    return delegation.provide(input).convert(
      (res:ParseResult<I,T>) -> res.fold(
        (match)   -> ParseResult.success(match.map(transform)),
        (err)     -> ParseResult.failure(err)
      )
    ).prepare(cont);
  }
  override inline public function apply(input:Input<I>):ParseResult<I,U>{
    return this.delegation.apply(input).map(this.transform);
  }
}