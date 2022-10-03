package stx.parse.test;

class PrimitiveTest extends TestCase{
	public function test_anything(async:Async){
		// var parser = Parsers.Whatever();
		// var reader = "a".reader();
		
		// __.ctx(
		// 	reader,
		// 	(x:ParseResult<String,String>) -> {
		// 		is_true(x.is_ok());
		// 		async.done();
		// 	}
		// ).load(parser.toFletcher())
		//  .submit();
	}
	public function test_something_many(){
		var input 	= 'aa'.reader();
		var parser 	= Parsers.Something().many();
		var result  = parser.provide(input).fudge();
		same(result.value,Some(["a","a"]));
	}
}