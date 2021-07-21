package stx.parse.test;

class OrTest extends TestCase{ 
	public function test(){
		var input 		= 'a'.reader();
		var a 				= __.parse().id('a');
		var b 				= __.parse().id('b');
		var fst_succ 	= a.or(b);
		var snd_succ  = b.or(a);
		var not_succ  = b.or(b);

		var i 				= fst_succ.provide(input).fudge();
		//__.log().debug(i);
		var ii 				= snd_succ.provide(input).fudge();
		//__.log().debug(ii);
		var iii 			= not_succ.provide(input).fudge();
		//__.log().debug(iii);
		pass();
	}
}