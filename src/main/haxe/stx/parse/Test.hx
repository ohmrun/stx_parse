package stx.parse;

import utest.Assert.*;

using stx.Nano;
using stx.Fn;
using stx.Assert;

import stx.Parse;
import stx.parse.test.*;
import stx.Test;

using stx.parse.Test;

function id(str){
	return __.parse().id(str);
}
class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		var f = stx.log.Facade.ZERO;
				f.includes.push('stx.parse');
				f.includes.push('stx.parse.test');
				f.includes.push("stx.async");
				//f.includes.push(__.tracer()(Terminal.identifier()));
				//f.includes.push("stx.async.work.Crunch");
				f.level = DEBUG;

		stx.Test.test(
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
			],
			[ManyTest]
		);
	} 
}
class RepSepTest extends utest.Test{
	public function test(){
		var reader = 'a.b'.reader();
		var parser = Parser.Something().repsep('.'.id());
		var result = parser.provide(reader).fudge();
		same(Some(['a','b']),result.fudge());
	}
	public function test_1(){
		var reader = 'a'.reader();
		var parser = Parser.Identifier('a').repsep('.'.id());
		var result = parser.provide(reader).fudge();
		trace(result);
	}
	public function test_2(){
		var reader = 'a.'.reader();
		var parser = Parser.Identifier('a').repsep('.'.id());
		var result = parser.provide(reader).fudge();
		trace(result);
	}
	public function test_3(){
		var reader = ''.reader();
		var parser = Parser.Identifier('a').repsep('.'.id());
		var result = parser.provide(reader).fudge();
		trace(result);
	}
}
class OptionTest extends utest.Test{
	public function test(){
		var reader = 'a'.reader();
		var parser = Parser.Something().option();
		var result = parser.provide(reader).fudge();
		same(Some('a'),result.fudge());
		var reader = 'a'.reader();
		var parser = Parser.Identifier('a').option();
		var result = parser.provide(reader).fudge();
		same(Some('a'),result.fudge());
		var reader = 'a'.reader();
		var parser = Parser.Identifier('b').option();
	 	var result = parser.provide(reader).fudge();
		same(None,result.fudge());
	}
}
class DebugTest extends utest.Test{
	public 
	function test_something(){
		var input 	= 'aa'.reader();
		var parser 	= Parse.something().many();
		var result  = parser.provide(input).fudge();
		trace(result);
	}
}

class OneManyTest extends utest.Test{
	public function test_greedy(){
		var input 	= 'aa'.reader();
		var parser 	= __.parse().id('a').one_many();
		var result 	= parser.provide(input).fudge();
		isTrue(result.ok());
	}
	public function test_one(){
		var input 	= 'a'.reader();
		var parser 	= __.parse().id('a').one_many();
		var result 	= parser.provide(input).fudge();
		isTrue(result.ok());
	}
	public function test_fail_empty(){
		var input 	= ''.reader();
		var parser 	= __.parse().id('a').one_many();
		var result 	= parser.provide(input).fudge();
		isFalse(result.ok());
	}
	public function test_eof_ok(){
		var input 	= 'aa'.reader();
		var parser 	= __.parse().id('a').one_many().and_(Parser.Eof());
		var result 	= parser.provide(input).fudge();
		isTrue(result.ok());
	}
}
class RepSep0Test extends utest.Test{
	public function test(){

	}
}
class OrTest extends utest.Test{ 
	public function test(){
		var input 		= 'a'.reader();
		var a 				= __.parse().id('a');
		var b 				= __.parse().id('b');
		var fst_succ 	= a.or(b);
		var snd_succ  = b.or(a);
		var not_succ  = b.or(b);

		var i 				= fst_succ.provide(input).fudge();
		//__.log().debug(i);
		var ii 				= snd_succ.provide(input).fudge();
		//__.log().debug(ii);
		var iii 			= not_succ.provide(input).fudge();
		//__.log().debug(iii);
		pass();
	}
}
class MemoisationIdentityTest extends utest.Test{
	public function test_id_secure(){
		
	}
}