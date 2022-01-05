package stx.parse.test;

class OneManyTest extends TestCase{
	public function test_greedy(){
		var input 	= 'aa'.reader();
		var parser 	= __.parse().id('a').one_many();
		var result 	= parser.provide(input).fudge();
		is_true(result.is_ok());
	}
	public function test_one(){
		var input 	= 'a'.reader();
		var parser 	= __.parse().id('a').one_many();
		var result 	= parser.provide(input).fudge();
		is_true(result.is_ok());
	}
	public function test_fail_empty(){
		var input 	= ''.reader();
		var parser 	= __.parse().id('a').one_many();
		var result 	= parser.provide(input).fudge();
		is_false(result.is_ok());
	}
	public function test_eof_ok(){
		var input 	= 'aa'.reader();
		var parser 	= __.parse().id('a').one_many().and_(Parsers.Eof());
		var result 	= parser.provide(input).fudge();
		is_true(result.is_ok());
	}
}