package stx;

import stx.parse.pack.parser.term.LAnon;
import stx.parse.pack.parser.term.Regex;
import stx.parse.pack.parser.term.Or;
import stx.parse.pack.parser.term.Identifier;

typedef Test                  = stx.parse.test.Test;
typedef LiftArrayReader       = stx.parse.lift.LiftArrayReader;
typedef LiftStringReader      = stx.parse.lift.LiftStringReader;

typedef EnumerableApi<C,T>    = stx.parse.pack.Enumerable.EnumerableApi<C,T>;
typedef Enumerable<C,T>       = stx.parse.pack.Enumerable<C,T>;

typedef ParseSuccess<P,T>     = stx.parse.pack.ParseSuccess<P,T>;

typedef ParseErrorInfo        = stx.parse.pack.ParseError.ParseErrorInfo;
typedef ParseError            = stx.parse.pack.ParseError;
typedef ParseFailure<P>       = stx.parse.pack.ParseFailure<P>;

typedef ParseResult<P,T>      = stx.parse.pack.ParseResult<P,T>;
typedef ParseResultLift       = stx.parse.pack.ParseResult.ParseResultLift;

typedef RestWithDef<P,T>      = stx.parse.pack.RestWith.RestWithDef<P,T>;
typedef RestWith<P,T>         = stx.parse.pack.RestWith<P,T>;

typedef Head                  = stx.parse.pack.Head;
typedef Input<P>              = stx.parse.pack.Input<P>;
typedef LR                    = stx.parse.pack.LR;
typedef LRLift                = stx.parse.pack.LR.LRLift;

typedef Memo                  = stx.parse.pack.Memo;
typedef MemoEntry             = stx.parse.pack.Memo.MemoEntry;
typedef MemoKey               = stx.parse.pack.Memo.MemoKey;

typedef ParserApi<P,R>        = stx.parse.pack.Parser.ParserApi<P,R>;
typedef Parser<P,R>           = stx.parse.pack.Parser<P,R>;
typedef ParserLift            = stx.parse.pack.Parser.ParserLift;

typedef ParseSystemFailure    = stx.parse.pack.ParseSystemFailure;

class LiftParse{
  static public function parse(wildcard:Wildcard){
    return new stx.parse.Module();
  }
  static public inline function ok<P,R>(rest:Input<P>,match:R):ParseResult<P,R>{
    return ParseSuccess.make(rest,match);
  }
  static public inline function fail<P,R>(rest:Input<P>,message:String,fatal:Bool=false,?pos:Pos):ParseResult<P,R>{
    return ParseFailure.at_with(rest,message,fatal,pos);
  }
  @:access(com.mindrocks.text) static public function parsify(regex:hre.RegExp,ipt:Input<String>):hre.Match{
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
  static public inline function regex(s:String):Parser<String,String>{
    return new Regex(s).asParser();
  }
  static public inline function defer<I,O>(f:Void->Parser<I,O>):Parser<I,O>{
    return new LAnon(f).asParser();
  }
}