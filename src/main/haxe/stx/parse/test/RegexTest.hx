package stx.parse.test;

class RegexTest extends TestCase{
	public function test_any_regex(){
		var parser = Parser.Regex(".");
		var reader = "ok".reader();
		parser.toFletcher().environment(
			reader,
			result -> {
				isTrue(result.ok());
			}
		);
	}
	public function test_integer(){
		var parser = Parse.integer;
		var reader = "+1".reader();
		parser.toFletcher().environment(reader,
			result -> {
				isTrue(result.ok());
			}	
		).crunch();
	}
	public function test_integer_minus(){
		var parser = Parse.integer;
		var reader = "-1".reader();
		parser.toFletcher().environment(
			reader,
			result -> {
				isTrue(result.ok());
			}
		).crunch();
	}
}