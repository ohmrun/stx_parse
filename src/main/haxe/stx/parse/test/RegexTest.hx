package stx.parse.test;

class RegexTest extends utest.Test{
	public function test_any_regex(){
		var parser = Parser.Regex(".");
		var reader = "ok".reader();
		var result = parser.apply(reader);
		isTrue(result.ok());
	}
	public function test_integer(){
		var parser = Parse.integer;
		var reader = "+1".reader();
		var result = parser.apply(reader);
		isTrue(result.ok());
	}
	public function test_integer_minus(){
		var parser = Parse.integer;
		var reader = "-1".reader();
		var result = parser.apply(reader);
		isTrue(result.ok());
	}
}