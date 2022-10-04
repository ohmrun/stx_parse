package stx.parse.parser.term;

class Choose<I,O> extends SyncBase<I,O,I->StdOption<O>>{
  inline public function apply(ipt:ParseInput<I>):ParseResult<I,O>{ 
    return ipt.head().fold(
      o -> delegation(o).fold(
        ok  -> ipt.drop(1).ok(ok),
        ()  -> ipt.erration("predicate failed").failure(ipt)
      ),
      e   -> ipt.erration('predicate failed').concat(e.toParseFailure_with(ipt,false)).failure(ipt),
      ()  -> ipt.no('predicate failed')
    );
  }
}