package stx.parse.test;

class EofTest extends TestCase{
  
  public function testSucceed(){
    var ipt = "";
    var prs = Parser.Eof();
    prs.toFletcher().environment(
      ipt.reader(),
      (res) -> {
        final out = res.fudge();
        equals(res.rest.index,0);    
      }
    ).crunch();
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
      (res) -> {
        var out = res.fudge();
        equals(res.rest.index,1);
      }
    ).crunch();
  }
}