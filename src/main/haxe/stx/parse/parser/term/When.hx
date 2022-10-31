package stx.parse.parser.term;

/**
  31/10/22 Was a compiler error where Chunk was passing as Option for `defv` call
**/
class When<I> extends SyncBase<I,I,I->Bool>{
  public function apply(input:ParseInput<I>):ParseResult<I,I>{
    final result = input.head().fold(
     (x) -> delegation(x).if_else(
       () -> input.tail().ok(x),
       () -> input.erration('When').failure(input)
     ),
     (e) -> e.toParseResult_with(input),
     ()   -> input.erration('When').failure(input)
    );
    trace(result);
    return result;
  }
}