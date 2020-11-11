package stx.parse.pack.parser.term;

class Filter<I,O> extends SyncBase<I,O,I->StdOption<O>>{
  override inline public function apply(ipt:Input<I>):ParseResult<I,O>{ 
    return ipt.head().flat_map(delegation).fold(
      (o) -> ipt.drop(1).ok(o),
      ()  -> ipt.fail("predicate failed")
    );
  }
}