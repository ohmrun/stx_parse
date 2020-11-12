package stx.parse.parser.term;

class When<I> extends SyncBase<I,I,I->Bool>{
  override public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return input.head().map(delegation).map(
      bool -> bool.if_else(
        () -> input.tail().ok(input.head().defv(null)),
        () -> input.fail('When')
      )
    ).def(input.fail.bind('When'));
  }
}