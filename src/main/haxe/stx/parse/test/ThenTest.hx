package stx.parse.test;

class ThenTest extends TestCase{
  public function test_success(){
    function handler(res:ParseResult<String,Int>){
      same(Some(1),res.value);
      //trace(res.value);
    }
    final input = ".".reader();
    final parse = Parser.Something().then(x -> 1);
    __.ctx(input,handler).load(parse.toFletcher()).crunch();    
  }
}