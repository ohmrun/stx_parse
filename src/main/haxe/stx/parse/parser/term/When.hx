package stx.parse.parser.term;

class When<I> extends SyncBase<I,I,I->Bool>{
  public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return input.head().map(
     (x) -> delegation(x).if_else(
       () -> input.tail().ok(x),
       () -> input.erration('When').failure(input)
     )
    ).defv(input.erration('When').failure(input));
  }
}