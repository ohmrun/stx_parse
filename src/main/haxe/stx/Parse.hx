package stx;

using stx.Pico;
using stx.Fail;
using stx.Nano;
using stx.Parse;
using stx.Fn;
using stx.Log;

import stx.parse.Parsers.*;

typedef LiftArrayReader       = stx.parse.lift.LiftArrayReader;
typedef LiftClusterReader     = stx.parse.lift.LiftClusterReader;
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
typedef ParseFailure 					= stx.fail.ParseFailure;
typedef ParseFailureCode 			= stx.fail.ParseFailureCode;
typedef ParseFailureCodeSum   = stx.fail.ParseFailureCode.ParseFailureCodeSum;

class Parse{
	/**
	 * Returns `stx.parse.parsers.StringParsers`
	 * @param self 
	 */
	static public function string(self:stx.parse.module.Parsers){
		return stx.parse.parsers.StringParsers;
	}
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
}
class LiftParse{
  static public function parse(wildcard:Wildcard){
    return new stx.parse.Module();
  }
  static public function ok<P,R>(rest:ParseInput<P>,match:R):ParseResult<P,R>{
    return ParseResult.make(rest,Some(match),null);
	}
	static public function nil<P,R>(rest:ParseInput<P>):ParseResult<P,R>{
    return ParseResult.make(rest,None,null);
  }
	static public function failure<P,R>(self:Refuse<ParseFailure>,rest:ParseInput<P>):ParseResult<P,R>{
		return ParseResult.make(rest,None,self);
	}
	static public function no<P,R>(rest:ParseInput<P>,message:ParseFailureCode,fatal=false):ParseResult<P,R>{
		return ParseResult.make(rest,None,erration(rest,message,fatal));
	}
	static public function cache<P,R>(parser:Void->Parser<P,R>):Parser<P,R>{
		return Parsers.LAnon(parser).asParser();
	}
  static public function erration<P>(rest:ParseInput<P>,message:ParseFailureCode,fatal=false):Refuse<ParseFailure>{
    return Refuse.pure(ParseFailure.make(@:privateAccess rest.content.index,message,fatal));
  }
	static public function sub<I,O,Oi,Oii>(p:Parser<I,O>,p0:Option<O>->Couple<ParseInput<Oi>,Parser<Oi,Oii>>){
		return stx.parse.Parsers.Sub(p,p0);
	}
	static public inline function tagged<I,T>(p : Parser<I,T>, tag : String):Parser<I,T> {
    p.tag = Some(tag);
    return TagRefuse(p, tag);
	}
	@:noUsing static public inline function succeed<I,O>(v:O):Parser<I,O>{
    return new stx.parse.parser.term.Succeed(v).asParser();
	}
}
//typedef LiftParseInputForwardToParser 	= stx.parse.lift.LiftParseInputForwardToParser;
typedef LiftArrayOfParser 							= stx.parse.lift.LiftArrayOfParser;
typedef LiftParseFailureCodeRefuse 			= stx.parse.lift.LiftParseFailureCodeRefuse;
typedef LiftParseFailureCodeResult 		  = stx.parse.lift.LiftParseFailureCodeResult;

class LiftParseFailure{
	static public inline function is_parse_fail(self:Defect<ParseFailure>):Bool{
    return (self.error.toIterable().toIter()).lfold( 
			(next:Error<Decline<ParseFailure>>,memo:Bool) -> memo.if_else(
				() -> true,
				() -> next.data.fold(
					ok -> switch(ok){
						case EXTERNAL(x) : x.msg != ParseFailure.FAIL;
						default : false;
					},
					() -> false
				)
			),
			false
		);

	}
  static public inline function is_fatal(self:Defect<ParseFailure>):Bool{
    return self.error.toIterable().toIter().lfold( 
			(next:Refuse<ParseFailure>,memo:Bool) -> memo.if_else(
				() -> true,
				() -> next.data.fold(
					(ok) -> ok.fold(
						x -> x.fatal,
						_ -> false,
						_ -> false
					),
					() -> false
				)
			),
			false
		);
  }
  static public function toString(self:Defect<ParseFailure>){
    return self.toRefuse().toIterable().toIter().map(
			 x -> x.data.fold(
				 ok -> ok.fold(
					 okI 	-> Std.string(okI),
					 _ 	  -> '',
					 _ 		-> ''
				 ),
				 () -> ''
			 )
		).lfold1((n,m) -> '$m,$n');
  }
}