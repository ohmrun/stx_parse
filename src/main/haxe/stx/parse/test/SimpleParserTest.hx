package stx.parse.test;

import stx.parse.pack.parser.term.Identifier;

class SimpleParserTest extends haxe.unit.TestCase{
  public function testIdentifier(){
    var reader = "if".reader();
    var parser = new Identifier("if");
    var result = parser.parse(reader);
    this.assertEquals("if",result.value().defv(""));
  }
  public function testOr(){
    var reader = "if".reader();
    var parser = "id".id().or("if".id());
    var result = parser.parse(reader);
    this.assertEquals("if",result.value().defv(""));
  }
  public function testOrs(){
    var reader = "if".reader();
    var parser = ["id".id(),"if".id()].ors();
    var result = parser.parse(reader);
    this.assertEquals("if",result.value().defv(""));
  }
  public function testMany(){
    var reader = "ifif".reader();
    var parser = "if".id().many();
    var result = parser.parse(reader);
    this.assertEquals("ifif",result.value().defv([]).join(""));
  }
  public function testOneMany(){
    var reader = "ifif".reader();
    var parser = "if".id().one_many();
    var result = parser.parse(reader);
    this.assertEquals("ifif",result.value().defv([]).join(""));
  }
  public function testAndThen(){
    var reader = "if".reader();
    var parser = 'if'.id().and_then(
      (_) -> Parser.Succeed('${_}fo')
    );
    var result = parser.parse(reader);
    this.assertEquals("iffo",result.value().defv(""));
  }
  public function testThen(){
    var reader = "if".reader();
    var parser = 'if'.id().then(
      (_) -> '${_}fo'
    );
    var result = parser.parse(reader);
    this.assertEquals("iffo",result.value().defv(""));
  }
  public function testRegex(){
    var reader = "ifY".reader();
    var parser = "^i[a-z][A-Z]".regex();
    var result = parser.parse(reader);
    this.assertEquals("ifY",result.value().defv(""));
  }
  public function testAnon(){
    var reader = "a".reader();
    var parser   = Parser.Anon(
      (input) -> input.head().fold(
        v 	-> input.tail().ok(v),
        () 	-> input.tail().nil()
      )
    );
    var result = parser.parse(reader);
    this.assertEquals("a",result.value().defv(""));
  }
}