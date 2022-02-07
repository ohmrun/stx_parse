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


class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		var f = __.log().global;
				f.level = BLANK;
				f.includes.push("stx/parse/test");
				f.includes.push('stx/parse');
				f.includes.push('eu/ohmrun/fletcher');
				f.includes.push('**');
				f.includes.push('stx/stream');
				f.includes.push('stx/test');
				f.includes.push('stx/stream/DEBUG');
		__.test(
			[
				//new PrimitiveTest(),
				//new WithTest(),
				//new EofTest(),
				//new ManyTest(),
				//new OptionTest(),
				//new LookaheadTest(),
				//new ThenTest(),
				//new Issue3Test(),
				// new SimpleParserTest(),
				new SimpleRecursionLangTest(),
				// new PrimitiveTest(),
				// //new MemoisationIdentityTest(),
				// new RegexTest(),
				// ,
				// new NotTest(),
				// new OrTest(),
				// new RepSep0Test(),
				
				// //new DebugTest(),
				// new RepSepTest(),
				// new Issue1(),
				// new Issue2(),
			],
			[]
		);
		//new SimpleRecursionLangTest().test_one();
	} 
}
//TODO should this even work?W
class Issue1 extends TestCase{
	//@timeout(10000)
	public function test(async:Async){
		var reader = 'abac'.reader();
		var parser = Never().not()._and(Something()).many(); 
    //var parser = __.parse().id('x').not()._and(Something()).many(); 
    parser.provide(reader).environment(
			(x) -> {
				trace(x);
				async.done();
			}
		).submit();
	}
}
class Issue2 extends TestCase{
	@:timeout(-1)
	public function test(async:Async){
		var reader = 'abac'.reader();
		var parser = Regex('abac').and_(Eof());
		parser.provide(
			reader
		).environment(
			(x) -> {
				same('abac',x.fudge());
				async.done();
			}
		).submit();
	}
}