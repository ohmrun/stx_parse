package stx.parse.parser.term;

class ErrorTransformer<I,O> extends Base<I,O,Parser<I,O>>{
  var transformer : Error<ParseError> -> Error<ParseError>;
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
    __.log().trace(_ -> _.thunk(() -> delegation));
    __.log().trace(result.is_ok());
    final out = result.errata(transformer);
    __.log().trace(out.is_ok());
    return ParseResult.lift(out);
  }
  override public function toString(){
    return this.delegation.toString();
  }
}