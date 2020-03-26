package stx.parse.test;

class EofTest extends utest.Test{
  
  public function testSucceed(){
    var ipt = "";
    var prs = Parser.eof();
    var out = prs.parse(ipt.reader());
    switch(out){
      case Success(x,xs):
      case Failure(er,xs,e):
        throw(er);
    }
  }
  
  public function testFail(){
    var ipt = "x";
    var prs = Parser.eof();
    var out = prs.parse(ipt.reader());
    switch(out){
      case Success(x,xs):
        throw "should not have succeeded";
      case Failure(er,xs,e):
    }
  }
  @Ignored
  public function testConsumeThen(){
    var ipt = "x";
    var prs = Base.anything()._and(Parser.eof());
    var out = prs.parse(ipt.reader());
    switch(out){
      case Success(x,xs):
        throw "should not have succeeded";
      case Failure(er,xs,e):
    }
  }
}