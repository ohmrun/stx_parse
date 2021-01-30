package stx.parse.parser.term;

class Choose<I,O> extends SyncBase<I,O,I->StdOption<O>>{
  inline public function apply(ipt:ParseInput<I>):ParseResult<I,O>{ 
    return ipt.head().flat_map(delegation).fold(
      (o) -> ipt.drop(1).ok(o),
      ()  -> ipt.fail("predicate failed")
    );
  }
}