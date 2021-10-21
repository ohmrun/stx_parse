package stx.parse.test;

class LookaheadTest extends TestCase{
  public function test_success(){
    function handler(res:ParseResult<String,String>){
      same(Some("."),res.value);
    }
    final input = ".".reader();
    final parse = Parser.Something().and_(Parser.Eof().lookahead());
    __.ctx(input,handler).load(parse.toFletcher()).crunch();    
  }
}