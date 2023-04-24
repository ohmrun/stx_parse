package stx.parse.test;

import stx.parse.parsers.StringParsers in SParse;

class OneManyTest extends TestCase{
	public function test_greedy(){
		var input 	= 'aa'.reader();
		var parser 	= SParse.id('a').one_many();
		var result 	= parser.apply(input);
		for(x in result.value){
			same(['a','a'].imm(),x);
		}
	}
	public function test_one(){
		var input 	= 'a'.reader();
		var parser 	= SParse.id('a').one_many();
		var result 	= parser.apply(input);
		for(x in result.value){
			same(['a'].imm(),x);
		}
	}
	public function test_fail_empty(){
		var input 	= ''.reader();
		var parser 	= SParse.id('a').one_many();
		var result 	= parser.apply(input);
		trace(result);
	}
	public function test_eof_ok(){
		var input 	= 'aa'.reader();
		var parser 	= SParse.id('a').one_many().and_(Parsers.Eof());
		var result 	= parser.apply(input);
		is_true(result.is_ok());
	}
}