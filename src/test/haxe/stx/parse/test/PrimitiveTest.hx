package stx.parse.test;

class PrimitiveTest extends TestCase{
	public function test_whatever_with_value(){
		final parser = Parsers.Something();
		final reader = "a".reader();
		final result = parser.apply(reader).toChunk();
		for(x in result){
			same("a",x);
		}
	}
	public function test_always_success(){
		final parser = Parsers.Always();
		final reader = "1".reader();
		final result = parser.apply(reader).toChunk();
		trace(result);
		same(Tap,result);
	}
	public function test_always_failure(){
		final parser = Parsers.Always();
		final reader = "".reader();
		final result = parser.apply(reader);
		final iter 	 = result.error.toIterable().toIter().map_filter(x -> x.data.flat_map(y -> y.exterior()));
		for( e in iter ){
			same(E_Parse_Eof,e.msg);
		}
	}
	public function test_something_many(){
		// var input 	= 'aa'.reader();
		// var parser 	= Parsers.Something().many();
		// var result  = parser.provide(input).fudge();
		// same(result.value,Some(["a","a"]));
	}
}