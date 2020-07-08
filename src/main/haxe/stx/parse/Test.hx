package stx.parse;

import stx.parse.Pack;
import stx.parse.test.*;

class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		__.test([
			//new SimpleParserTest(),
			//new SimpleRecursionLangTest(),
			new PrimitiveTest()
		]);
		//new Parser(new stx.parse.pack.parser.term.Base());
		//LangParser.numberParserTest();
		//LangParser.langTest();
		//ParserTest.jsonTest();
		//SimpleParser.test();
	}
  
}
class PrimitiveTest extends haxe.unit.TestCase{
	public function test_float_parse(){
		var parser = Parse.integer;
		var reader = 'absd 2'.reader();
		var result = parser.forward(reader).fudge();
		trace(result);
	}
}