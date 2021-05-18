package stx.parse;

import stx.parse.parser.term.*;
@:using(stx.parse.parser.ParserLift)
@:forward abstract Parser<I,O>(ParserApi<I,O>) to ParserApi<I,O>{
  public inline function new(self:ParserApi<I,O>) this = self;
  static public var _(default,never) = ParserLift;
   
  @:noUsing static inline public function fromConstructor<I,O>(fn:Void->Parser<I,O>):Parser<I,O>{
    return lift(new LAnon(fn));
  }
  @:noUsing static inline public function fromParserApi<I,O>(it:ParserApi<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  @:noUsing static inline public function fromFunction<I,O>(f:ParseInput<I>->ParseResult<I,O>,tag):Parser<I,O>{
    return new SyncAnon(f,tag).asParser();
  }
  @:noUsing static inline public function fromParseInputProvide<I,O>(self:ParseInput<I>->Provide<ParseResult<I,O>>,tag):Parser<I,O>{
    return lift(Anon(Convert.fromConvertProvide(self).toFletcher(),tag));
  }
  @:noUsing static inline public function lift<I,O>(it:ParserApi<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  public function mkHead() : Head return {
    headParser    : cast elide(),
    involvedSet   : LinkedList.unit(),
    evalSet       : LinkedList.unit()
  }
  inline public function elide<U>() : Parser<I,U> return cast(self);

  @:noUsing static inline public function Forward<P,R>(fn:ParseInput<P>->Provide<ParseResult<P,R>>,?pos:Pos):Parser<P,R>{
    return Arrow(
      Convert.fromFun1Provide(fn).toFletcher() 
    ,pos).asParser();
  }
  @:noUsing static inline public function Arrow<P,R>(fn:Fletcher<ParseInput<P>,ParseResult<P,R>,Noise>,?pos:Pos):Parser<P,R>{
    return new Arrow(fn,pos).asParser();
  }
  @:noUsing static inline public function Anon<P,R>(fn:ParseInput<P> -> Terminal<ParseResult<P,R>,Noise> -> Work,tag:Option<String>,?pos:Pos):Parser<P,R>{
    //trace(fn);
    return new Anon(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function SyncAnon<P,R>(fn:ParseInput<P> -> ParseResult<P,R>,tag:Option<String>,?pos:Pos):Parser<P,R>{
    return new SyncAnon(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function TaggedAnon<P,R>(fn:ParseInput<P> -> Terminal<ParseResult<P,R>,Noise> -> Work,tag,?pos:Pos):Parser<P,R>{
    return new TaggedAnon(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function Failed<P,R>(msg,is_error = false,?id:Pos):Parser<P,R>{
    return new Failed(msg,is_error,id).asParser();
  }
  @:noUsing static inline public function Succeed<P,R>(value:R,?pos:Pos):Parser<P,R>{
    return new Succeed(value,pos).asParser();
  }
  @:noUsing static inline public function Stamp<P,R>(result:ParseResult<P,R>,?pos:Pos):Parser<P,R>{
    return new Stamp(result,pos).asParser();
  }
  @:noUsing static inline public function Closed<P,R>(self:Provide<ParseResult<P,R>>,?pos:Pos):Parser<P,R>{
    return new Closed(self,pos).asParser();
  }
  @:noUsing static inline public function Range(min:Int,max:Int):Parser<String,String>{
    return new stx.parse.parser.term.Range(min,max).asParser();
  }
  @:noUsing static inline public function Named<P,R>(self:Parser<P,R>,name:String):Parser<P,R>{
    return new stx.parse.parser.term.Named(self,name).asParser();
  }
  @:noUsing static inline public function Regex(str:String):Parser<String,String>{
    return new stx.parse.parser.term.Regex(str).asParser();
  }
  @:noUsing static inline public function Or<I,T>(pI : Parser<I,T>, pII : Parser<I,T>):Parser <I,T>{
    return new stx.parse.parser.term.Or(pI,pII).asParser();
  }
  @:noUsing static inline public function Ors<I,T>(ps : Array<Parser<I,T>>):Parser <I,T>{
    return new stx.parse.parser.term.Ors(ps).asParser();
  }
  @:noUsing static inline public function AnonThen<I,T,U>(p : Parser<I,T>, f : T -> U):Parser <I,U>{
    return new stx.parse.parser.term.AnonThen(p,f).asParser();
  }
  @:noUsing static inline public function AndThen<I,T,U>(p: Parser<I,T>, f : T -> Parser<I,U>):Parser <I,U>{
    return new stx.parse.parser.term.AndThen(p,f).asParser();
  }
  @:noUsing static inline public function Many<I,T>(p: Parser<I,T>):Parser<I,Array<T>>{
    return new stx.parse.parser.term.Many(p).asParser();
  }
  @:noUsing static inline public function OneMany<I,T>(p: Parser<I,T>):Parser<I,Array<T>>{
    return new stx.parse.parser.term.OneMany(p).asParser();
  }
  @:noUsing static inline public function Eof<I,O>():Parser<I,O>{
    return new stx.parse.parser.term.Eof().asParser();
  }
  @:noUsing static inline public function Lookahead<I,O>(parser:Parser<I,O>):Parser<I,O>{
    return new stx.parse.parser.term.Lookahead(parser).asParser();
  }
  @:noUsing static inline public function Identifier(str:String):Parser<String,String>{
    return new stx.parse.parser.term.Identifier(str).asParser();
  }
  @:noUsing static public function Option<I,O>(p:Parser<I,O>): Parser<I,Option<O>>{
    return new stx.parse.parser.term.Option(p).asParser();
  }
  @:noUsing static public inline function Choose<I,O>(fn:I->Option<O>,?tag:Option<String>,?pos:Pos): Parser<I,O>{
    return new stx.parse.parser.term.Choose(fn,tag,pos).asParser();
  }
  @:noUsing static public inline function When<I>(fn:I->Bool,?tag:Option<String>,?pos:Pos):Parser<I,I>{
    return new stx.parse.parser.term.When(fn,tag,pos).asParser();
  }
  @:noUsing static public inline function Materialize<I,O>(parser:Parser<I,O>):Parser<I,O>{
    return new stx.parse.parser.term.Materialize(parser).asParser();
  }
  @:noUsing static public function Inspect<I,O>(parser:Parser<I,O>,?prefix:ParseInput<I>->Void,?postfix:ParseResult<I,O>->Void,?pos:Pos):Parser<I,O>{
    return new stx.parse.parser.term.Inspect(parser,prefix,postfix,pos).asParser();
  }
  @:noUsing static inline public function TagError<I,O>(parser:Parser<I,O>,name:String,?pos:Pos):Parser<I,O>{
    return new stx.parse.parser.term.TagError(parser,name,pos).asParser();
  }
  @:noUsing static inline public function Debug<P,R>(parser:Parser<P,R>):Parser<P,R>{
    return new stx.parse.parser.term.Debug(parser).asParser();
  }
  @:noUsing static inline public function Something<P>():Parser<P,P>{
    return new stx.parse.parser.term.Something().asParser();
  }
  @:noUsing static inline public function Whatever<P>():Parser<P,P>{
    return new stx.parse.parser.term.Whatever().asParser();
  }
  @:noUsing static inline public function Nothing<P>():Parser<P,P>{
    return new stx.parse.parser.term.Nothing().asParser();
  }
  @:noUsing static inline public function Never<P>():Parser<P,P>{
    return new stx.parse.parser.term.Never().asParser();
  } 
  var self(get,never):Parser<I,O>;
  function get_self():Parser<I,O> return lift(this);
  public inline function asParser():Parser<I,O> return self;

  @:to public inline function toFletcher():Fletcher<ParseInput<I>,ParseResult<I,O>,Noise>{
    return Fletcher.lift(this.toFletcher());
  }
  @:to public inline function toFletcherDef():FletcherDef<ParseInput<I>,ParseResult<I,O>,Noise>{
    return this.toFletcher();
  }
  /**implicit override issue**/
  public inline function then<Oi>(f : O -> Oi):Parser<I,Oi>   return _.then(lift(this),f);
  /**implicit override issue**/
  public inline function or(p2 : Parser<I,O>):Parser <I,O>    return _.or(lift(this),p2);
  
}
