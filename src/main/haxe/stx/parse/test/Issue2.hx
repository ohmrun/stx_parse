package stx.parse.test;

class Issue2 extends TestCase{
	@timeout(-1)
	public function test(){
		// var reader = 'abac'.reader();
		// var parser = Parsers.Regex('abac').and_(Parsers.Eof());
		// parser.provide(
		// 	reader
		// ).environment(
		// 	(x) -> {
		// 		same('abac',x.fudge());
		// 		async.done();
		// 	}
		// ).submit();
	}
}