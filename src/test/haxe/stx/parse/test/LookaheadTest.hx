package stx.parse.test;

class LookaheadTest extends TestCase{
  public function test_success(){
    final input = ".".reader();
    final parse = Parsers.Something().and_(Parsers.Eof().lookahead());
    final res   = parse.apply(input);
    same(Some("."),res.value);
  }
}