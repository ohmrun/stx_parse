package stx.parse.test;

class PrimitiveTest extends utest.Test{
	public function test_anything(){
		var parser = Parser.Whatever();
		var reader = "a".reader();
		var result = parser.apply(reader);
				isTrue(result.ok());
	}
}