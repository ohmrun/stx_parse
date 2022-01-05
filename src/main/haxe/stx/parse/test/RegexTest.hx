package stx.parse.test;

class RegexTest extends TestCase{
	public function test_any_regex(){
		var parser = Parsers.Regex(".");
		var reader = "ok".reader();
		parser.toFletcher().environment(
			reader,
			result -> {
				is_true(result.is_ok());
			}
		);
	}
	public function test_integer(){
		var parser = Parse.integer;
		var reader = "+1".reader();
		parser.toFletcher().environment(reader,
			result -> {
				is_true(result.is_ok());
			}	
		).crunch();
	}
	public function test_integer_minus(){
		var parser = Parse.integer;
		var reader = "-1".reader();
		parser.toFletcher().environment(
			reader,
			result -> {
				is_true(result.is_ok());
			}
		).crunch();
	}
}