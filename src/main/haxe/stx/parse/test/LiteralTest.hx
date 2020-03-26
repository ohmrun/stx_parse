package stx.parse.test;

class LiteralTest extends haxe.unit.TestCase{
  var lines   = __.resource("literals").string().split("\n");
  var parser  = new stx.parse.head.parse.term.Literal();

  public function Xtest_flat(){
    var lit = lines[0];
    var out = parser.parse(lit.reader());
    this.assertEquals('"hello"',out.match());
  }
  public function test_with_escape(){
    var lit   = lines[1];
    var out   = parser.parse(lit.reader());
    var real  = '"\\\"hello"';
    this.assertEquals(real,out.match());
  }
  public function test_with_escaped_escape(){
    var lit   = lines[2];
    var out   = parser.parse(lit.reader());
    var real  = '"\\\\\\\"hello"';
    this.assertEquals(real,out.match());
  }
  public function test_empty(){
    var lit   = lines[3];
    var out   = parser.parse(lit.reader());
    trace(out);
  }
}