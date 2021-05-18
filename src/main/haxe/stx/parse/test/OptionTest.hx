package stx.parse.test;

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