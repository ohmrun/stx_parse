package stx.parse;

import stx.parse.Parsers.*;

@:using(stx.parse.parser.ParserLift)
@:forward abstract Parser<I,O>(ParserApi<I,O>) to ParserApi<I,O>{
  public inline function new(self:ParserApi<I,O>) this = self;
  static public var _(default,never) = ParserLift;
   
  @:noUsing static inline public function fromConstructor<I,O>(fn:Void->Parser<I,O>):Parser<I,O>{
    return lift(LAnon(fn));
  }
  @:noUsing static inline public function fromParserApi<I,O>(it:ParserApi<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  @:noUsing static inline public function fromFunction<I,O>(f:ParseInput<I>->ParseResult<I,O>,tag):Parser<I,O>{
    return SyncAnon(f,tag).asParser();
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
 
  var self(get,never):Parser<I,O>;
  function get_self():Parser<I,O> return lift(this);
  public inline function asParser():Parser<I,O> return self;

  /**implicit override issue**/
  public inline function then<Oi>(f : O -> Oi):Parser<I,Oi>   return _.then(lift(this),f);
  /**implicit override issue**/
  public inline function or(p2 : Parser<I,O>):Parser <I,O>    return _.or(lift(this),p2);
  
}
