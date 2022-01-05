package stx.parse.test;

class ThenTest extends TestCase{
  public function test_success(){
    function handler(res:ParseResult<String,Int>){
      same(Some(1),res.value);
    }
    final input = ".".reader();
    final parse = Parsers.Something().then(x -> 1);
    __.ctx(input,handler).load(parse.toFletcher()).crunch();    
  }
}