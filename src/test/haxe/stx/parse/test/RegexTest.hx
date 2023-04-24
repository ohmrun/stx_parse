package stx.parse.test;

import stx.parse.parsers.StringParsers.*;

class RegexTest extends TestCase{
	public function test_integer_ok(){
		final a = integer.apply("1".reader());
		for(x in a.toUpshot().fudge()){
			equals("1",x);
		}
	}
	public function test_integer_with_plus_ok(){
		final a = integer.apply("+1".reader());
		for(x in a.toUpshot().fudge()){
			equals("+1",x);
		}
	}
	public function test_integer_with_minus_ok(){
		final a = integer.apply("-1".reader());
		for(x in a.toUpshot().fudge()){
			equals("-1",x);
		}
	}
	public function test_float_ok(){
		final a = float.apply("1.0".reader());
		for(x in a.toUpshot().fudge()){
			equals("1.0",x);
		}
	}
	public function test_float_dot_escaped(){
		final a = float.and_(Parsers.Eof()).apply("1n0".reader());
		raises(
			() -> {
				a.toUpshot().fudge();
			}
		);
		
	}
	// public function test_any_regex(){
	// 	var parser = Parsers.Regex(".");
	// 	var reader = "ok".reader();
	// 	parser.toFletcher().environment(
	// 		reader,
	// 		result -> {
	// 			is_true(result.is_ok());
	// 		}
	// 	);
	// }
	// public function test_integer(){
	// 	var parser = Parse.integer;
	// 	var reader = "+1".reader();
	// 	parser.toFletcher().environment(reader,
	// 		result -> {
	// 			is_true(result.is_ok());
	// 		}	
	// 	).crunch();
	// }
	// public function test_integer_minus(){
	// 	var parser = Parse.integer;
	// 	var reader = "-1".reader();
	// 	parser.toFletcher().environment(
	// 		reader,
	// 		result -> {
	// 			is_true(result.is_ok());
	// 		}
	// 	).crunch();
	// }
}