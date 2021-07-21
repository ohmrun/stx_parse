package stx.parse.test;

class PrimitiveTest extends TestCase{
	public function test_anything(async:Async){
		var parser = Parser.Whatever();
		var reader = "a".reader();
		
		parser.toFletcher().environment(
			reader,
			(result) -> {
				isTrue(result.ok());
				async.done();
			},
			__.crack
		).submit();
	}
}