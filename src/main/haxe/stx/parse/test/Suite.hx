package stx.parse.test;

@:keep
class Suite{
  static public function tests(){
    return [
      new stx.parse.term.json.Test(),
      new PrimitiveTest(),
      new EofTest(),
      new LiteralTest(),
      new LookaheadTest(),
      new ManyTest(),
      new OneManyTest()
    ];
  }
}