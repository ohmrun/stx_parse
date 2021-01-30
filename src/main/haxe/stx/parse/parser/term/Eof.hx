package stx.parse.parser.term;

class Eof<I,O> extends Sync<I,O>{
  public function apply(input:ParseInput<I>):ParseResult<I,O>{
    //trace(input);
    return input.is_end() ? input.nil() : input.fail('not at end');
  }
}