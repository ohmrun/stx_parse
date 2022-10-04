package stx.parse.test;

class LiteralTest extends TestCase{
  var lines   = __.resource("literals").string().split("\n");
  var parser  = new stx.parse.term.Literal().asParser();

  public function test_flat(){
    var lit = lines[0];
    var out = parser.apply(lit.reader());
    for(x in out.value){
      this.equals('hello',x);
    }
  }
  public function test_with_escape(){
    var lit   = lines[1];
    var out   = parser.apply(lit.reader());
    var real  = '\\\"hello';
    for(x in out.value){
      this.equals(real,x);
    }
  }
  public function test_with_escaped_escape(){
    var lit   = lines[2];
    var out   = parser.apply(lit.reader());
    var real  = '"\\\\\\\"hello"';
    for(x in out.value){
      this.equals(real,x);
    }
  }
}