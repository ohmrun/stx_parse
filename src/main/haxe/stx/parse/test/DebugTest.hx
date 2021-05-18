package stx.parse.test;

class DebugTest extends utest.Test{
	public 
	function test_something(){
		var input 	= 'aa'.reader();
		var parser 	= Parser.Something().many();
		var result  = parser.provide(input).fudge();
		trace(result);
	}
}