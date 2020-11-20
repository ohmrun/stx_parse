package stx.parse.parser.term;

class Not<I,O> extends BoundFun<I,O,O>{
  //TODO not sure this is deep enough.
  override public inline function defer(i:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return i.is_end() ? cont.value(i.fail('at End in Not')).serve() : super.defer(i,cont);
  }
  override private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,O>{
    return result.fold(
      (ok) -> input.fail('Parser "${parser.tag}" succeeded rather than failed in Not'),
      (no) -> no.is_fatal() ? ParseResult.failure(no) : input.nil()
    );
  }
}