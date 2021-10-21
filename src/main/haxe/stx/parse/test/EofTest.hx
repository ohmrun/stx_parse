package stx.parse.test;

class EofTest extends TestCase{
  
  public function _testSucceed(){
    var ipt = "";
    var prs = Parser.Eof();
    __.ctx(
      ipt.reader(),
      (res:ParseResult<String,String>) -> {
        final out = res;
        equals(None,out.value);
        equals(res.asset.index,0);  
      }
    ).load(prs)
     .crunch();
  }
  
  // public function testFail(){
  //   var ipt = "x";
  //   var prs = Parser.Eof();
  //   utest.Assert.raises(
  //     () -> prs.apply(ipt.reader()).fudge()
  //   );
  // }
  public function testConsumeThen(){
    var ipt = "x";
    var prs = Parser.Whatever()._and(Parser.Eof());
    prs.toFletcher().environment(
      ipt.reader(),
      (res:ParseResult<String,String>) -> {
        equals(None,res.value);
        // var out = res.fudge();
        // equals(res.asset.index,1);
      }
    ).crunch();
  }
}