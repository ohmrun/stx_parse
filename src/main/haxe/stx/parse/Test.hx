package stx.parse;

using stx.Nano;
using stx.Fn;
using stx.Assert;

import stx.Parse;
import stx.parse.test.*;
import stx.unit.Test;

using stx.parse.Test;


class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		var f = stx.log.Facade.ZERO;
				f.includes.push('stx.parse');
				f.includes.push('stx.parse.With');
				f.includes.push('stx.parse.Many');
				f.includes.push('stx.async.Terminal');
				f.includes.push('stx.parse.test');
				f.includes.push("stx.async");
				//f.includes.push(__.tracer()(Terminal.identifier()));
				f.includes.push("stx.async.work.Crunch");
				//f.level = DEBUG;

		__.unit(
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
				new DebugTest(),
				new OptionTest(),
				new RepSepTest(),
				new Issue1(),
				new Issue2(),
			],
			[ManyTest]
		);
	} 
}
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