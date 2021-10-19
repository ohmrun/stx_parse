package stx.parse.parser.term;

class ErrorTransformer<I,O> extends Base<I,O,Parser<I,O>>{
  var transformer : Defect<ParseError> -> Defect<ParseError>;
  public function new(delegation,transformer,?pos:Pos){
    super(delegation,pos);
    this.transformer = transformer;
  }
  inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.receive(delegation.toFletcher().then(
      Fletcher.Sync(mod)
    ).forward(input));
  }
  private function mod(result:ParseResult<I,O>):ParseResult<I,O>{
    return ParseResult.lift(result.errata(transformer));
  }
  override public function toString(){
    return this.delegation.toString();
  }
}