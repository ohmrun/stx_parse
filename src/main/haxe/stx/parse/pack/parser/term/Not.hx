package stx.parse.pack.parser.term;

class Not<I,O> extends Delegate<I,O>{
  override private function doApplyII(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    return Arrowlet.Then(
      this.delegation,
      Arrowlet.Sync(
        (res:ParseResult<I,O>) -> res.fold(
          (ok) -> input.fail('Parser succeeded rather than failed in Not'),
          (no) -> no.is_fatal() ? ParseResult.failure(no) : input.nil()
        )
      )
    ).applyII(input,cont);
  }
}