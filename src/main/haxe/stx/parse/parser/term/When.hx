package stx.parse.parser.term;

class When<I> extends SyncBase<I,I,I->Bool>{
  public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return input.head().map(
     (x) -> delegation(x).if_else(
       () -> input.tail().ok(x),
       () -> input.fail('When')
     )
    ).def(input.fail.bind('When'));
  }
}