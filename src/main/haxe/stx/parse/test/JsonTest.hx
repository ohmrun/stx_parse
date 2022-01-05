package stx.parse.test;

import stx.parse.term.Json;

@:access(stx) class JsonTest extends haxe.unit.TestCase{
  public var github_author = __.resource("github_author").string();
  public var github = __.resource("github").string();
  public var simple = __.resource("simple").string();

  public function Xtest_literal(){
    var target = Parse.literal.parse('"helsldf\\"o"'.reader());
    this.assertTrue(target.value().is_defined());
  }
  public function Xtest_identifier(){
    var target = Json.ident_p.parse('"TEst"'.reader());
    this.assertTrue(target.value().is_defined());
  }
  public function Xtest_zero_length_literal(){
    var target = Parse.literal.parse('""'.reader());
    this.assertTrue(target.value().is_defined());
  }
  public function Xtest_simple(){
    //var target = new Json().parse(simple.reader());
    //trace(target);
  }
  public function XtestOneMany(){
    //var target = Base.anything().one_many().parse("abs".reader());
    //trace(target);
  }
  public function test(){
      var parser  = new Json().parser();
      var target  = parser.parse(github.reader());
      //trace(haxe.Json.parse(github));
      //var texpr   = TExpr.fromJsValue(target.value().core().release());
      
      //trace(target.toString());
      //trace(target.isSuccess());
      //trace(texpr);
  }
}