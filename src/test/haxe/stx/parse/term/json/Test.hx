package stx.parse.term.json;

import stx.parse.term.Json;
import stx.parse.test.Suite;

using stx.Log;
using stx.Nano;
using stx.Parse;
using stx.Test;

@:access(stx) class Test extends TestCase{
  static public function main(){
    final log = __.log().global;
          //log.includes.push("**/*");
          //log.level = TRACE;
    __.test().auto();
  }
  //public var github_author = __.resource("github_author").string();
  //public var github = __.resource("github").string();
  public var simple = __.resource("simple").string();
  public var haxe   = __.resource("haxe").string();

  public function test_literal(){
    var target = __.parse().parsers().string().literal.apply('"helsldf\\"o"'.reader());
    __.log().trace('$target');
    for(v in target.value){
      same('helsldf\\"o',v);
    }
  }
  public function test_identifier(){
    var target = Json.ident_p.apply('"TEst"'.reader());
    for(v in target.value){
      same('TEst',v);
    }
  }
  public function test_zero_length_literal(){
    var target = __.parse().parsers().string().literal.apply('""'.reader());
    __.log().trace('${target.value}');
    for(x in target.value){
      same("",x);
    }
  }
  public function test_simple(){
    var target = new stx.parse.term.Json().parser().apply(simple.reader());
    __.log().trace('$target');
  }
  public function testOneMany(){
    //var target = Base.anything().one_many().parse("abs".reader());
    //trace(target);
  }
  public function test(){
    //var parser  = new Json().parser();
    //var target  = parser.parse(haxe.reader());
    //trace(haxe.Json.parse(github));
    //var texpr   = TExpr.fromJsValue(target.value().core().release());
    //$type(target);
    //__.log().debug(_ -> _.show(target));
    //trace(target.isSuccess());
    //trace(texpr);
  }
  public function test_escaped_double_quotes(){

  }
}