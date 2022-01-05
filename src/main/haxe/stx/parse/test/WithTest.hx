package stx.parse.test;

class WithTest extends TestCase{
  public function test_couple_with(){
    final data    = "aa".reader();
    final parser  = Parsers.Something().and(Parsers.Something());
      __.ctx(data,
        (res:ParseResult<String,Couple<String,String>>) -> {
          same(tuple2("a","a"),res.value.fudge().tup());
        }  
      ).load(parser.toFletcher())
       .crunch();
  }
}