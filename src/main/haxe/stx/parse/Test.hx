package stx.parse;

using stx.Nano;
using stx.Fn;
using stx.Assert;
using stx.Test;

using stx.Parse;
import stx.parse.Parsers.*;

import stx.parse.test.*;
import stx.Test;

using stx.parse.Test;
import stx.parse.test.Suite;

class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		var f = __.log().global;
				f.level = TRACE;
				f.includes.push("stx/parse/test");
				f.includes.push('stx/parse');
				//f.includes.push('eu/ohmrun/fletcher');
				// f.includes.push('**');
				// f.includes.push('stx/stream');
				// f.includes.push('stx/test');
				// f.includes.push('stx/stream/DEBUG');
		__.test().auto();
			[
				//,
				//new WithTest(),
				//new EofTest(),
				//new ManyTest(),
				//new OptionTest(),
				//new LookaheadTest(),
				//new ThenTest(),
				//new Issue3Test(),
				//new SimpleParserTest(),
				//new SimpleRecursionLangTest(),
				//new PrimitiveTest(),
				//new MemoisationIdentityTest(),
				// new RegexTest(),
				// ,
				// new NotTest(),
				// new OrTest(),
				// new RepSep0Test(),
				
				// //new DebugTest(),
				// new RepSepTest(),
				// new Issue1(),
				// new Issue2(),
			];
		//new SimpleRecursionLangTest().test_one();
	} 
}
class RefuseTest extends TestCase{
	
}