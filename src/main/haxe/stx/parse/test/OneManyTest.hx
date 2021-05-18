package stx.parse.test;

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