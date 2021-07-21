package stx.parse;

using stx.Nano;
using stx.Fn;
using stx.Assert;
using stx.Test;

import stx.Parse;
import stx.parse.test.*;
import stx.Test;

using stx.parse.Test;


class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		var f = __.log().global;
				f.includes.push('stx/parse');
				

		__.test(
			[
				new SimpleParserTest(),
				new SimpleRecursionLangTest(),
				new PrimitiveTest(),
				//new MemoisationIdentityTest(),
				new RegexTest(),
				new EofTest(),
				new NotTest(),
				new OrTest(),
				new RepSep0Test(),
				new ManyTest(),
				//new DebugTest(),
				new OptionTest(),
				new RepSepTest(),
				new Issue1(),
				new Issue2(),
			],
			[Issue1]
		);
	} 
}
//TODO should this even work?
class Issue1 extends TestCase{
	@:timeout(1000000000)
	public function test(async:Async){
		var reader = 'abac'.reader();
		var parser = Parser.Never().not()._and(Parser.Something()).many(); 
    //var parser = __.parse().id('x').not()._and(Parser.Something()).many(); 
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
		var parser = Parser.Regex('abac').and_(Parser.Eof());
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