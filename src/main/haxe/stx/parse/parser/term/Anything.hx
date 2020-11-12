package stx.parse.parser.term;

class Anything<I> extends Sync<I,I>{
  override public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return input.head().fold(
      (i:I) -> input.tail().ok(i),
      () -> input.nil()
    );
  }
}