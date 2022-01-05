package stx;

import stx.parse.Parsers.*;

#if(test==stx_parse)
typedef Test                  = stx.parse.test.Test;
#end
typedef LiftArrayReader       = stx.parse.lift.LiftArrayReader;
typedef LiftStringReader      = stx.parse.lift.LiftStringReader;
typedef LiftLinkedListReader  = stx.parse.lift.LiftLinkedListReader;


typedef ParseInput<P>         = stx.parse.ParseInput<P>;
typedef ParseResult<P,T>      = stx.parse.ParseResult<P,T>;
typedef ParseResultLift       = stx.parse.ParseResult.ParseResultLift;

typedef ParserApi<P,R>        = stx.parse.ParserApi<P,R>;
typedef ParserCls<P,R>       	= stx.parse.ParserCls<P,R>;
typedef Parser<P,R>           = stx.parse.Parser<P,R>;
typedef Parsers            		= stx.parse.Parsers;
typedef ParserLift            = stx.parse.parser.ParserLift;


class Parse{
	@:noUsing static public function mergeString(a:String,b:String){
		return a + b;
	}
	@:noUsing static public function mergeArray<T>(a:Array<T>,b:Array<T>){
		return a.concat(b);
	}
	@:noUsing static public function mergeOption<T>(a:String, b:Option<String>){
		return switch (b){ case Some(v) : a += v ; default : ''; } return a; 
	}
	@:noUsing static public function mergeTAndArray<T>(a:T, b:Array<T>):Array<T>{
		return [a].concat(b);
	}
	@:noUsing static public function mergeOptionAndArray<T>(a:Option<T>, b:Array<T>):Array<T>{
		return a.fold(
			(t) -> [t].concat(b),
			() 	-> b
		);
	}
	static public var boolean 		= __.parse().id('true').or(__.parse().id('false'));
	static public var integer     = __.parse().reg("^[\\+\\-]?\\d+");
  static public var float 			= __.parse().reg("^[\\+\\-]?\\d+(\\.\\d+)?");
  
	static public function primitive():Parser<String,Primitive>{
		return boolean.then((x) -> PBool(x == 'true' ? true : false))
		.or(float.then(Std.parseFloat.fn().then(PFloat)))
		.or(integer.then((str) -> PInt(__.option(Std.parseInt(str)).defv(0))))
		.or(literal.then(PString));
	}
		

	static public var lower				= Range(97, 122);
	static public var upper				= Range(65, 90);
	static public var alpha				= Or(upper,lower);
	static public var digit				= Range(48, 57);
	static public var alphanum		= alpha.or(digit);
	static public var ascii				= Range(0, 255);
	
	static public var valid				= alpha.or(digit).or(__.parse().id('_'));
	
	static public var tab					= __.parse().id('	');
	static public var space				= __.parse().id(' ');
	
	static public var nl					= __.parse().id('\n');
	static public var cr					= __.parse().id('\r\n');
	static public var cr_or_nl		= nl.or(cr);

	static public var gap					= tab.or(space);
	static public var whitespace	= Range(0, 33);
	

	//static public var camel 			= lower.and_with(word, mergeString);
	static public var word				= lower.or(upper).one_many().tokenize();//[a-z]*
	static public var quote				= __.parse().id('"').or(__.parse().id("'"));
	static public var escape			= __.parse().id('\\');
	static public var not_escaped	= __.parse().id('\\\\');
	
	static public var x 					= not_escaped.not()._and(escape);
	static public var x_quote 		= x._and(quote);

	static public var literal 		= new stx.parse.term.Literal().asParser();

	static public	final brkt_l_square = __.parse().id('[');
	static public	final brkt_r_square = __.parse().id(']');

	static public function spaced( p : Parser<String,String> ) {
		return p.and_(gap.many());
	}
	static public function returned(p : Parser<String,String>) {
		return p.and_(whitespace.many());
	}
	@:noUsing static public function eq<I>(v:I):Parser<I,I>{
		return SyncAnon(
			(input:ParseInput<I>) -> input.head().fold(
				(vI) -> v == vI ? input.tail().ok(vI) : input.fail('eq'),
				() -> input.fail('eq')
			)
		,'eq').asParser();
	}
}
class LiftParse{
  static public function parse(wildcard:Wildcard){
    return new stx.parse.Module();
  }
  static public inline function ok<P,R>(rest:ParseInput<P>,match:R):ParseResult<P,R>{
    return ParseResult.make(rest,Some(match));
	}
	static public inline function nil<P,R>(rest:ParseInput<P>):ParseResult<P,R>{
    return ParseResult.make(rest,None);
  }
  static public inline function fail<P,R>(rest:ParseInput<P>,message:String,fatal:Bool=false):ParseResult<P,R>{
    return ParseResult.make(rest,None,[ParseError.make(@:privateAccess rest.content.index,message,fatal)]);
  }
  static public function parsify(regex:hre.RegExp,ipt:ParseInput<String>):hre.Match{
    __.log().trace(_ -> _.pure(@:privateAccess ipt.content.data));
    var data : String = (cast ipt).content.data;
    if(data == null){
      data = "";
    }
    data = data.substr(ipt.offset);
    return regex.exec(data);
  }
  
  static public inline function defer<I,O>(f:Void->Parser<I,O>):Parser<I,O>{
    return LAnon(f).asParser();
  }
  
	static public function sub<I,O,Oi,Oii>(p:Parser<I,O>,p0:Option<O>->Couple<ParseInput<Oi>,Parser<Oi,Oii>>){
		return Anon(
			(input:ParseInput<I>,cont:Terminal<ParseResult<I,Oii>,Noise>) -> {
				return cont.receive(
					Fletcher.Then(
						p,
						Fletcher.Anon(
							(res:ParseResult<I,O>,cont:Terminal<ParseResult<I,Oii>,Noise>) -> res.is_ok().if_else(
								() -> {
									var inner 	= (resII:ParseResult<Oi,Oii>) -> resII.is_ok().if_else(
										() 		-> resII.value.fold(
											ok 	-> res.asset.ok(ok),
											 () -> res.asset.nil() 
										),
										()		-> ParseResult.make(input,None,resII.error)
									);
									final out 		= p0(res.value);
									final reader 	= out.fst();
									final parser 	= out.snd(); 
									// //trace(out.snd());
									// var result 	= parser.defer(out.fst(),inner);

									// return cont.later(defer.asFuture()).after(result);
									return cont.receive(parser.toFletcher().then(Fletcher.Sync(inner)).forward(reader));
								},
								() -> cont.receive(cont.value(res.fails()))
							)
						)
					).forward(input)
				);
			},
			Some('sub')
		);
	}
	static public inline function tagged<I,T>(p : Parser<I,T>, tag : String):Parser<I,T> {
    p.tag = Some(tag);
    return TagError(p, tag);
	}
	@:noUsing static public inline function succeed<I,O>(v:O):Parser<I,O>{
    return new stx.parse.parser.term.Succeed(v).asParser();
	}
}
typedef LiftParseInputForwardToParser 	= stx.parse.lift.LiftParseInputForwardToParser;
typedef LiftArrayOfParser 							= stx.parse.lift.LiftArrayOfParser;

class LiftParseError{
	static public inline function is_parse_fail(self:Defect<ParseError>):Bool{
    return self.error.prj().lfold( 
			(next:ParseError,memo:Bool) -> memo.if_else(
				() -> true,
				() -> next.msg != ParseError.FAIL
			),
			false
		);

	}
  static public inline function is_fatal(self:Defect<ParseError>):Bool{
    return self.error.prj().lfold( 
			(next:ParseError,memo:Bool) -> memo.if_else(
				() -> true,
				() -> next.fatal
			),
			false
		);
  }
  static public function toString(self:Defect<ParseError>){
    return self.error.prj().map(Std.string).map(x -> Std.string(x)).lfold1((n,m) -> '$m,$n');
  }
}