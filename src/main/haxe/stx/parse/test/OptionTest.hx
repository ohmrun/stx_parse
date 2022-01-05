package stx.parse.test;

class OptionTest extends TestCase{
	public function test(){
		var reader = 'a'.reader();
		var parser = Parsers.Something().option();
		var result = parser.provide(reader).fudge();
		same(Some('a'),result.fudge());
		var reader = 'a'.reader();
		var parser = Parsers.Identifier('a').option();
		var result = parser.provide(reader).fudge();
		same(Some('a'),result.fudge());
		var reader = 'a'.reader();
		var parser = Parsers.Identifier('b').option();
	 	var result = parser.provide(reader).fudge();
		same(None,result.value);
	}
}