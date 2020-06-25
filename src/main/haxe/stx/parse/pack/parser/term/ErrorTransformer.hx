package stx.parse.pack.parser.term;

class ErrorTransformer<I,O> extends Delegate<I,O>{
  var transformer : ParseError -> ParseError;
  public function new(delegation,transformer,?id){
    super(delegation,id);
    this.transformer = transformer;
  }
  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return delegation.forward(input).process(
      (res:ParseResult<I,O>) -> res.fold(
        ParseResult.success,
        (e) -> ParseResult.failure(e.mod(transformer))
      )
    ).prepare(cont);
  }
}