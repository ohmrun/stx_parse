package stx.parse.pack.parser.term;

class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  var transform : T -> U;
  public function new(delegation:Parser<I,T>,transform:T->U,?id){
    super(delegation,id);
    __.that(id).exists().crunch(delegation);
    this.transform  = transform; 
    this.tag        = delegation.tag;
  }
  override public function check(){
    __.that(id).exists().errata(e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  override public function doApplyII(input:Input<I>,cont:Terminal<ParseResult<I,U>,Noise>){
    return delegation.forward(input).convert(
      (res:ParseResult<I,T>) -> res.fold(
        (match)   -> ParseResult.success(match.map(transform)),
        (err)     -> ParseResult.failure(err)
      )
    ).prepare(cont);
  }

}