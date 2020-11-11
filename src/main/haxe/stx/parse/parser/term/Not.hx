package stx.parse.parser.term;

class Not<I,O> extends BoundFun<I,O,O>{
  override private function bound(input:Input<I>,result:ParseResult<I,O>):ParseResult<I,O>{
    return result.fold(
      (ok) -> input.fail('Parser succeeded rather than failed in Not'),
      (no) -> no.is_fatal() ? ParseResult.failure(no) : input.nil()
    );
  }
}