package stx.parse.test;

import stx.parse.parser.term.Identifier;
using stx.parse.test.SimpleParserTest;

inline function id(str:String){
  return __.parse().id(str);
}
inline function regex(str:String){
  return return __.parse().reg(str);
}

class SimpleParserTest extends TestCase{
  public function testIdentifier(){
    var reader = "if".reader();
    var parser = new Identifier("if").asParser();
    var result = parser.provide(reader).fudge();
    equals("if",result.value().defv(""));
  }
  public function testOr(){
    var reader = "if".reader();
    var parser = "id".id().or("if".id()).asParser();
    var result = parser.provide(reader).fudge();
    equals("if",result.value().defv(""));
  }
  // public function testOrs(){
  //   var reader = "if".reader();
  //   var parser = ["id".id(),"if".id()].ors().asParser();
  //   var result = parser.provide(reader).fudge();
  //   equals("if",result.value().defv(""));
  // }
  // public function testMany(){
  //   var reader = "ifif".reader();
  //   var parser = "if".id().many().asParser();
  //   var result = parser.provide(reader).fudge();
  //   equals("ifif",result.value().defv([]).join(""));
  // }
  // public function testOneMany(){
  //   var reader = "ifif".reader();
  //   var parser = "if".id().one_many().asParser();
  //   var result = parser.provide(reader).fudge();
  //   equals("ifif",result.value().defv([]).join(""));
  // }
  // public function testAndThen(){
  //   var reader = "if".reader();
  //   var parser = 'if'.id().and_then(
  //     (_) -> Parser.Succeed('${_}fo')
  //   ).asParser();
  //   var result = parser.provide(reader).fudge();
  //   equals("iffo",result.value().defv(""));
  // }
  // public function testThen(){
  //   var reader = "if".reader();
  //   var parser = 'if'.id().then(
  //     (_) -> '${_}fo'
  //   ).asParser();
  //   var result = parser.provide(reader).fudge();
  //   equals("iffo",result.value().defv(""));
  // }
  // public function testRegex(){
  //   var reader = "ifY".reader();
  //   var parser = "^i[a-z][A-Z]".regex();
  //   var result = parser.provide(reader).fudge();
  //   equals("ifY",result.value().defv(""));
  // }
  // public function testSyncAnon(){
  //   var reader = "a".reader();
  //   var parser   = Parser.SyncAnon(
  //     function (input:ParseInput<String>):ParseResult<String,String>{
  //       return input.head().fold(
  //         (v:String) 	-> input.tail().ok(v),
  //         () 	        -> input.tail().nil()
  //       );
  //     }
  //   ,Some('stat'));
  //   var result = parser.provide(reader).fudge();
  //   equals("a",result.value().defv(""));
  // }
  // public function testAndR(){
  //   var reader = " a".reader();
  //   var parser = __.parse().id(" ")._and(__.parse().id("a"));
  //   var result = parser.provide(reader).fudge();
  //   equals("a",result.value().defv(""));
  // }
  // public function testAndL(){
  //   var reader = " a".reader();
  //   var parser = " ".id().and_("a".id());
  //   var result = parser.provide(reader).fudge();
  //   equals(" ",result.value().defv(""));
  // }
  // public function testMany_empty(){
  //   var reader  = "".reader();
  //   var parser  = "a".id().many();
  //   var result  = parser.provide(reader).fudge();
  //   equals("",result.value().defv([]).join(""));
  // }
  // public function test_choose(){
  //   var reader  = "a".reader();
  //   var parser  = Parser.Choose((str:String) -> (Some(str)));
  //   var result  = parser.provide(reader).fudge();
  //   same("a",result.value().fudge());
  // }
}