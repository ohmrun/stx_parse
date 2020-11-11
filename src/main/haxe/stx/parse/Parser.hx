package stx.parse;

import stx.parse.parser.term.*;
@:using(stx.parse.parser.ParserLift)
@:forward abstract Parser<I,O>(ParserApi<I,O>) to ParserApi<I,O>{
  public function new(self:ParserApi<I,O>) this = self;
  static public var _(default,never) = ParserLift;
   
  @:noUsing static inline public function fromConstructor<I,O>(fn:Void->Parser<I,O>):Parser<I,O>{
    return lift(new LAnon(fn));
  }
  @:noUsing static inline public function fromParserApi<I,O>(it:ParserApi<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  @:noUsing static inline public function fromFunction<I,O>(f:Input<I>->ParseResult<I,O>):Parser<I,O>{
    return new SyncAnon(f).asParser();
  }
  @:noUsing static inline public function fromInputProvide<I,O>(self:Input<I>->Provide<ParseResult<I,O>>):Parser<I,O>{
    return lift(Anon(Convert.fromConvertProvide(self).toArrowlet().defer));
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

  @:noUsing static inline public function Forward<P,R>(fn:Input<P>->Provide<ParseResult<P,R>>,?pos:Pos):Parser<P,R>{
    return Arrow(
      Convert.fromFun1Provide(fn).toArrowlet() 
    ,pos).asParser();
  }
  @:noUsing static inline public function Arrow<P,R>(fn:Arrowlet<Input<P>,ParseResult<P,R>,Noise>,?pos:Pos):Parser<P,R>{
    return new Arrow(fn,pos).asParser();
  }
  @:noUsing static inline public function Anon<P,R>(fn:Input<P> -> Terminal<ParseResult<P,R>,Noise> -> Work,?pos:Pos):Parser<P,R>{
    //trace(fn);
    return new Anon(fn,pos).asParser();
  }
  @:noUsing static inline public function SyncAnon<P,R>(fn:Input<P> -> ParseResult<P,R>,?pos:Pos):Parser<P,R>{
    return new SyncAnon(fn,pos).asParser();
  }
  @:noUsing static inline public function TaggedAnon<P,R>(fn:Input<P> -> Terminal<ParseResult<P,R>,Noise> -> Work,tag,?pos:Pos):Parser<P,R>{
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
  @:noUsing static inline public function Then<I,T,U>(p : Parser<I,T>, f : T -> U):Parser <I,U>{
    return new stx.parse.parser.term.Then(p,f).asParser();
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
    return new stx.parse.parser.term.Eof();
  }
  var self(get,never):Parser<I,O>;
  function get_self():Parser<I,O> return lift(this);
  public inline function asParser():Parser<I,O> return self;

  @:to public inline function toArrowlet():Arrowlet<Input<I>,ParseResult<I,O>,Noise>{
    return Arrowlet.lift(this.asArrowletDef());
  }
  @:to public inline function toArrowletDef():ArrowletDef<Input<I>,ParseResult<I,O>,Noise>{
    return this.asArrowletDef();
  }
  /**implicit override issue**/
  public inline function then<Oi>(f : O -> Oi):Parser<I,Oi>   return _.then(lift(this),f);
  /**implicit override issue**/
  public inline function or(p2 : Parser<I,O>):Parser <I,O>    return _.or(lift(this),p2);
  
}
