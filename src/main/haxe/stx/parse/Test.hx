package stx.parse;

import utest.Assert.*;

using stx.Nano;
using stx.Fn;
using stx.Assert;

import stx.parse.Pack;
import stx.parse.test.*;
import stx.Test;

class Test {
	public static function here(){
		return __.here();
	}
	public static function main() {
		var f = stx.log.Facade.ZERO;
				f.includes.push('stx.parse.test');

		stx.Test.test(
			[
				new SimpleParserTest(),
				new SimpleRecursionLangTest(),
				new PrimitiveTest(),
				new MemoisationIdentityTest(),
				new RegexTest(),
			],
			[SimpleRecursionLangTest]
		);
	}
  
}
class MemoisationIdentityTest extends utest.Test{
	public function test_id_secure(){
		
	}
}