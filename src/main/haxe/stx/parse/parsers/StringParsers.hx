package stx.parse.parsers;

import stx.parse.Parsers.*;

class StringParsers{
  static public inline function reg(str:String):Parser<String,String>{
		return Regex(str).asParser();
	}
	static public inline function id(str:String):Parser<String,String>{
		return Identifier(str);
	}
	static public inline function code(int:Int):Parser<String,String>{
		return CharCode(int);
	}
	static public inline function range(start:Int,finish:Int):Parser<String,String>{
		return Range(start,finish);
  }
  static public var boolean 				= id('true').or(id('false'));
	static public var integer     		= reg("^[+-]?\\d+");
  static public var float 					= reg("^[+-]?\\d+(\\.\\d+)?");
  
	static public function primitive():Parser<String,Primitive>{
		return boolean.then((x) -> PBool(x == 'true' ? true : false))
		.or(float.then(Std.parseFloat.fn().then(x -> PSprig(Byteal(NFloat(x))))))
		.or(integer.then((str) -> PSprig(Byteal(NFloat((__.option(Std.parseInt(str)).defv(0)))))))
		.or(literal.then(x -> PSprig(Textal(x))));
	}
		

	static public var lower						= Range(97, 122);
	static public var upper						= Range(65, 90);
	static public var alpha						= Or(upper,lower);
	static public var digit						= Range(48, 57);
	static public var alphanum				= alpha.or(digit);
	static public var ascii						= Range(0, 255);
	
	static public var valid						= alpha.or(digit).or(id('_'));
	
	static public var tab							= id('	');
	static public var space						= id(' ');
	
	static public var nl							= id('\n');
	static public var cr							= id('\r\n');
	static public var cr_or_nl				= nl.or(cr);

	static public var gap							= tab.or(space);
	static public var whitespace			= Range(0, 32).tagged('whitespace');

	//static public var camel 				= lower.and_with(word, mergeString);
	static public var word						= lower.or(upper).one_many().tokenize();//[a-z]*
	static public var quote						= id('"').or(id("'"));
	static public var escape					= id('\\');
	static public var not_escaped			= id('\\\\');
	
	static public var x 							= not_escaped.not()._and(escape);
	static public var x_quote 				= x._and(quote);

	static public var literal 				= new stx.parse.term.Literal().asParser();
	static public var symbol 					= Parsers.When(x -> StringTools.fastCodeAt(x,0) >= 33).one_many().tokenize().tagged('symbol');

	static public	final brkt_l_square = id('[');
	static public	final brkt_r_square = id(']');

	static public function spaced( p : Parser<String,String> ) {
		return p.and_(gap.many());
	}
	static public function returned(p : Parser<String,String>) {
		return p.and_(whitespace.many());
	}
}