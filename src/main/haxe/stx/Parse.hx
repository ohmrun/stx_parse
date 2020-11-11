package stx;

import stx.parse.parser.term.Not;
import stx.parse.parser.term.Head;
import stx.parse.parser.term.LAnon;
import stx.parse.parser.term.Regex;
import stx.parse.parser.term.Or;
import stx.parse.parser.term.Identifier;

#if(test==stx_parse)
typedef Test                  = stx.parse.test.Test;
#end
typedef LiftArrayReader       = stx.parse.lift.LiftArrayReader;
typedef LiftStringReader      = stx.parse.lift.LiftStringReader;
typedef LiftLinkedListReader  = stx.parse.lift.LiftLinkedListReader;


typedef Input<P>              = stx.parse.Input<P>;
typedef ParseResult<P,T>      = stx.parse.ParseResult<P,T>;
typedef ParseResultLift       = stx.parse.ParseResult.ParseResultLift;

typedef ParserApi<P,R>        = stx.parse.ParserApi<P,R>;
typedef ParserCls<P,R>       	= stx.parse.ParserCls<P,R>;
typedef Parser<P,R>           = stx.parse.Parser<P,R>;
typedef ParserLift            = stx.parse.parser.ParserLift;


class Pack{

}
class Parse{
	static public function head<I,O>(fn:I->Option<Couple<O,Option<I>>>):Parser<I,O>{
		return new stx.parse.parser.term.Head(fn).asParser();
	}
  static public function anything<I>():Parser<I,I>{
		return new stx.parse.parser.term.Anything().asParser();
	}
	static public function something<I>():Parser<I,I>{
		return Parser.SyncAnon(
			(input:Input<I>)->{
			return if(input.is_end()){
				input.fail('EOF');
			}else{
				__.noop()(input.head()).fold(
					v 	-> input.tail().ok(v),
					() 	-> input.tail().fail('anything')
				);
			}
		}).asParser();
	}
	@:note("0b1kn00b","Lua fix")
	@:noUsing static public function range(min:Int, max:Int):Parser<String,String>{
		return Parser.Range(min,max);
	}
	@:noUsing static public function mergeString(a:String,b:String){
		return a + b;
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
	static public var truth 			= 'true'.id().or('false'.id());
	static public var integer     = "^[\\+\\-]?\\d+".regex();
  static public var float 			= "^[\\+\\-]?\\d+(\\.\\d+)?".regex();
  
	static public function primitive():Parser<String,Primitive>{
		return truth.then((x) -> PBool(x == 'true' ? true : false))
		.or(float.then(Std.parseFloat.fn().then(PFloat)))
		.or(integer.then((str) -> PInt(__.option(Std.parseInt(str)).defv(0))))
		.or(literal.then(PString));
	}
		

	static public var lower				= range(97, 122);
	static public var upper				= range(65, 90);
	static public var alpha				= Parser._.or(upper,lower);
	static public var digit				= range(48, 57);
	static public var alphanum		= alpha.or(digit);
	static public var ascii				= range(0, 255);
	
	static public var valid				= alpha.or(digit).or('_'.id());
	
	static public var tab					= '	'.id();
	static public var space				= ' '.id();
	
	static public var nl					= '\n'.id();
	static public var cr					= '\r\n'.id();
	static public var cr_or_nl		= nl.or(cr);

	static public var gap					= tab.or(space);
	static public var whitespace	= range(0, 33);
	

	//static public var camel 			= lower.and_with(word, mergeString);
	static public var word				= lower.or(upper).one_many().token();//[a-z]*
	static public var quote				= '"'.id().or("'".id());
	static public var escape			= '\\'.id();
	static public var not_escaped	= '\\\\'.id();
	
	static public var x 					= not_escaped.not()._and(escape);
	static public var x_quote 		= x._and(quote);

	
	static public var literal 		= new stx.parse.term.Literal().asParser();
	
	static public function spaced( p : Parser<String,String> ) {
		return p.and_(gap.many());
	}
	static public function returned(p : Parser<String,String>) {
		return p.and_(whitespace.many());
	}
	// static public function until<I>(p:Parser<I,I>):Parser<I,Array<I>>{
	// 	function rec(input:Input<I>,memo:Array<I>):Provide<ParseResult<I,Array<I>>>{ 
	// 		return Parser.Arrow(Arrowlet.Then(
	// 			p,
	// 			Arrowlet.Anon(
	// 				(res:ParseResult<I,I>,cont:Terminal<ParseResult<I,Array<I>>,Noise>) -> res.fold(
	// 					(ok) -> cont.value(ok.rest.ok(memo)).serve(),
	// 					(no) -> something().and_then(
	// 						(x:I) -> Parser.fromInputProvide(
	// 							rec.bind(_,memo.snoc(x))
	// 						)
	// 					).defer(input,cont)
	// 				)
	// 			)
	// 		)).provide(input);
	// 	};
	// 	return Parser.Forward(rec.bind(_,[])).asParser();
	// }
	@:noUsing static public function eq<I>(v:I):Parser<I,I>{
		return Parser.Named(Parser.SyncAnon(
			(input:Input<I>) -> input.head().fold(
				(vI) -> v == vI ? input.tail().ok(vI) : input.fail('eq'),
				() -> input.fail('eq')
			)
		).asParser(),'eq').asParser();
	}
	static public function eof<P,R>():Parser<P,R>{
    return Parser.Named(Parser.SyncAnon(ParserLift.eof).asParser(),'eof').asParser();
	}

  /**
	 * Takes a predicate function for an item of Input and returns it's parser.
   */
   @:noUsing static public function predicated<I>(p:I->Bool) : Parser<I,I> {
		return Parser.Named(Parser.SyncAnon(function(input:Input<I>) {
			var res = input.head().map(p).defv(false);
			//trace(x.offset + ":z" + x.content.at(x.offset)  + " " + Std.string(res));
			return
				if ( res && !input.is_end() ) {
          input.drop(1).ok(input.take(1));
				}else {
					input.fail("predicate failed",false);
				}
		}).asParser(),'predicated').asParser();
  }
  @:noUsing static public function Filter<I,O>(fn:I->Option<O>): Parser<I,O>{
    return new  stx.parse.parser.term.Filter(fn).asParser();
  }
}
class LiftParse{
  static public function parse(wildcard:Wildcard){
    return new stx.parse.Module();
  }
  static public inline function ok<P,R>(rest:Input<P>,match:R):ParseResult<P,R>{
    return ParseSuccess.make(rest,Some(match));
	}
	static public inline function nil<P,R>(rest:Input<P>):ParseResult<P,R>{
    return ParseSuccess.make(rest,None);
  }
  static public inline function fail<P,R>(rest:Input<P>,message:String,fatal:Bool=false,?pos:Pos):ParseResult<P,R>{
    return ParseFailure.at_with(rest,message,fatal,pos);
  }
  static public function parsify(regex:hre.RegExp,ipt:Input<String>):hre.Match{
    //trace(ipt.content.data);
    var data : String = (cast ipt).content.data;
    if(data == null){
      data = "";
    }
    data = data.substr(ipt.offset);
    return regex.exec(data);
  }
  static public inline function identifier(str:String,?pos:Pos):Parser<String,String>{
    return new Identifier(str,pos).asParser();
  }
  static public inline function alts<I,O>(arr:Array<Parser<I,O>>){
    return arr.lfold1((next,memo:Parser<I,O>) -> new Or(memo,next).asParser());
  }
  static public inline function regex(str:String):Parser<String,String>{
    return Parser.Regex(str);
  }
  static public inline function defer<I,O>(f:Void->Parser<I,O>):Parser<I,O>{
    return new LAnon(f).asParser();
  }
  static public function lookahead<I,O>(p:Parser<I,O>):Parser<I,O>{
		return Parser.TaggedAnon((input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>)->
			Arrowlet.Then(
				p,
				Arrowlet.Sync(
					(res:ParseResult<I,O>) -> res.fold(
						(ok) 	-> input.nil(),
						(no)	-> ParseResult.failure(no)
					) 
				)
			).toInternal().defer(input,cont)
		,'lookahead: ${p.tag}').asParser();
	}
	static public function sub<I,O,Oi,Oii>(p:Parser<I,O>,p0:Option<O>->Couple<Input<Oi>,Parser<Oi,Oii>>){
		return Parser.Anon(
			(input:Input<I>,cont:Terminal<ParseResult<I,Oii>,Noise>) -> {
				return Arrowlet.Then(
					p,
					Arrowlet.Anon(
						(res:ParseResult<I,O>,cont:Terminal<ParseResult<I,Oii>,Noise>) -> __.noop()(res).fold(
							(ok) -> {
								var defer		= Future.trigger();
								var inner 	= cont.inner(
									(resI:Outcome<ParseResult<Oi,Oii>,Array<Noise>>) -> {
										defer.trigger(
											resI.fold(
												(resII) -> resII.fold(
													ok 		-> Success(ParseSuccess.make(res.rest,ok.with).toParseResult()),
													no		-> Success(ParseFailure.make(input,no.with).toParseResult())
												),
												(no) -> Failure([Noise])
											)
										);
									}
								);
								var out 		= p0(ok.with);
								var reader 	= out.fst();
								var parser 	= out.snd(); 
								//trace(out.snd());
								var result 	= parser.defer(out.fst(),inner);

								return cont.later(defer.asFuture()).after(result);
							},
							(no) -> cont.value(ParseResult.failure(no)).serve()
						)
					)
				).toInternal().defer(input,cont);
			}
		);
	}
	static public function token(p:Parser<String,Array<String>>):Parser<String,String>{
		return p.then(
			(arr) -> __.option(arr).defv([]).join("")
		);
	}
  /**
	 * Returns true if the parser fails and vice versa.
	 */
	static public function not<I,O>(p:Parser<I,O>):Parser<I,O>{
		return new Not(p).asParser();
	}
	
  public static function id(s:String) {
		return identifier(s);
	}
	static public function inspector<I,O>(__:Wildcard,?pre:Input<I>->Void,?post:ParseResult<I,O>->Void,?pos:Pos):Parser<I,O>->Parser<I,O>{
		return (prs:Parser<I,O>) -> {
			return prs.inspect(
				__.option(pre).defv(
					(v) -> {
						if(v.tag!=null){
							__.log()('${v.tag} "${v.head()}"',pos);
						}
					}
				),
				__.option(post).defv(
					(v) -> {
						__.log()(v.toString(),pos);
					}
				)
			);
		};
	}
	static public inline function tagged<I,T>(p : Parser<I,T>, tag : String):Parser<I,T> {
    p.tag = Some(tag);
    return Parser._.with_error_tag(p, tag);
	}
	@:noUsing static public inline function succeed<I,O>(v:O):Parser<I,O>{
    return new stx.parse.parser.term.Succeed(v).asParser();
  }
}
typedef LiftInputForwardToParser 	= stx.parse.lift.LiftInputForwardToParser;
typedef LiftArrayOfParser 				= stx.parse.lift.LiftArrayOfParser;