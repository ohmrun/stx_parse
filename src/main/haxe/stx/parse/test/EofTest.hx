package stx.parse.test;

class EofTest extends utest.Test{
  
  public function testSucceed(){
    var ipt = "";
    var prs = Parser.Eof();
    var res = prs.apply(ipt.reader());
    var out = res.fudge();
    equals(res.rest.index,0);
  }
  
  public function testFail(){
    var ipt = "x";
    var prs = Parser.Eof();
    utest.Assert.raises(
      () -> prs.apply(ipt.reader()).fudge()
    );
  }
  public function testConsumeThen(){
    var ipt = "x";
    var prs = Parse.anything()._and(Parser.Eof());
    var res = prs.apply(ipt.reader());
    var out = res.fudge();
    equals(res.rest.index,1);
  }
}