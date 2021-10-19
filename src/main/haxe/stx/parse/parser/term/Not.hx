package stx.parse.parser.term;

class Not<I,O> extends BoundFun<I,O,O>{
  private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,O>{
    return result.is_ok().if_else(
      ()    -> input.fail('Parser "${parser.tag}" succeeded rather than failed in Not'),
      ()    -> result.error.is_fatal() ? result : input.nil()
    );
  }
  override public function toString(){
    return '!$parser';
  }
}