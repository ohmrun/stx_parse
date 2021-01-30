package stx.parse.parser.term;

class Not<I,O> extends BoundFun<I,O,O>{
  private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,O>{
    return result.fold(
      (ok) -> input.fail('Parser "${parser.tag}" succeeded rather than failed in Not'),
      (no) -> no.is_fatal() ? no.toParseResult() : input.nil()
    );
  }
  override public function toString(){
    return '!$parser';
  }
}