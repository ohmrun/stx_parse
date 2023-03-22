package stx.parse.test;

using stx.parse.test.RepSepTest;

inline function id(str){
	return __.parse().id(str);
}

class RepSepTest extends TestCase{
	@timeout(100000)
	public function test(){
		// var reader = 'a.b'.reader();
		// var parser = Parsers.Something().repsep('.'.id());
		// var result = parser.provide(reader);
		// 		result.environment(
		// 			result -> {
		// 				trace(result);
		// 				same(Cluster.lift(['a','b']),result.fudge());
		// 				async.done();
		// 			}
		// 		).submit();
	}
	public function _test_1(){
		// var reader = 'a'.reader();
		// var parser = Parsers.Identifier('a').repsep('.'.id());
		// var result = parser.provide(reader).fudge();
		// same(Cluster.lift(['a']),result.fudge());
	}
	public function _test_2(){
		// var reader = 'a.'.reader();
		// var parser = Parsers.Identifier('a').repsep('.'.id());
		// var result = parser.provide(reader).fudge();
		// same(Cluster.lift(['a']),result.fudge());
	}

	// public function _test_3(){
	// 	var reader = ''.reader();
	// 	var parser = Parsers.Identifier('a').repsep('.'.id());
	// 	raises(
	// 		() -> parser.provide(reader).fudge()
	// 	);
	// }
	public function _test_4(){
		// var reader = 'a'.reader();
		// var parser = __.parse().id('a').repsep(__.parse().id("."));
		// var result = parser.provide(reader).fudge();
		// trace(result);
	}
}