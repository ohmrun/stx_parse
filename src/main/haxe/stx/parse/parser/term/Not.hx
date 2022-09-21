package stx.parse.parser.term;

class Not<I,O> extends BoundFun<I,O,O>{
  private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,O>{
    return result.is_ok().if_else(
      ()    -> input.erration('Parser "${parser.tag}" succeeded rather than failed in Not').failure(input),
      ()    -> result.is_fatal() ? result : input.nil()
    );
  }
  override public function toString(){
    return 'NOT $parser';
  }
}