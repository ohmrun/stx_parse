package stx.parse;

import stx.parse.Pack;
import stx.parse.test.*;

class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		__.test([
			new SimpleParserTest()
		]);
		//new Parser(new stx.parse.pack.parser.term.Base());
		//LangParser.numberParserTest();
		//LangParser.langTest();
		//ParserTest.jsonTest();
		//SimpleParser.test();
	}
  
}
