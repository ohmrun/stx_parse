package stx.parse.test;

class PrimitiveTest extends utest.Test{
	public function test_anything(){
		var parser = Parse.anything();
		var reader = "a".reader();
		var result = parser.apply(reader);
				isTrue(result.ok());
	}
}