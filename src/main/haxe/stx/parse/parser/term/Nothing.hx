package stx.parse.parser.term;

class Nothing<I> extends Sync<I,I>{
  public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return input.nil();
  }
}