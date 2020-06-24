package stx.parse.pack;

import stx.parse.pack.parser.term.AndThen;
import stx.parse.pack.parser.term.AndL;
import stx.parse.pack.parser.term.AndR;
import stx.parse.pack.parser.term.Anon;
import stx.parse.pack.parser.term.Base;
import stx.parse.pack.parser.term.Commit;
import stx.parse.pack.parser.term.Delegate;
import stx.parse.pack.parser.term.Direct;
import stx.parse.pack.parser.term.ErrorTransformer;
import stx.parse.pack.parser.term.Failed;
import stx.parse.pack.parser.term.Identifier;
import stx.parse.pack.parser.term.Inspect;
import stx.parse.pack.parser.term.LAnon;
import stx.parse.pack.parser.term.Many;
import stx.parse.pack.parser.term.Memoise;
import stx.parse.pack.parser.term.OneMany;
import stx.parse.pack.parser.term.Option;
import stx.parse.pack.parser.term.Or;
import stx.parse.pack.parser.term.Ors;
//import stx.parse.pack.parser.term.Predicate;
import stx.parse.pack.parser.term.Pure;
import stx.parse.pack.parser.term.Regex;
import stx.parse.pack.parser.term.Rep1Sep;
import stx.parse.pack.parser.term.RepSep;
import stx.parse.pack.parser.term.Succeed;
import stx.parse.pack.parser.term.TaggedAnon;
import stx.parse.pack.parser.term.Then;
import stx.parse.pack.parser.term.With;

interface ParserApi<I,O>{
  public var tag                            : Option<String>;
  public var id(default,null)               : Pos;
  
  public var uid(default,null)              : Int;
  public function parse(ipt:Input<I>)       : ParseResult<I,O>;
  
  public function name():String;
}

@:using(stx.parse.pack.Parser.ParserLift)
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
    return new Anon(f).asParser();
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

  @:noUsing static public function Anon<P,R>(fn:Input<P> -> ParseResult<P,R>,?pos:Pos):Parser<P,R>{
    return new Anon(fn,pos).asParser();
  }
  @:noUsing static public function TaggedAnon<P,R>(fn:Input<P> -> ParseResult<P,R>,tag,?pos:Pos):Parser<P,R>{
    return new TaggedAnon(fn,tag,pos).asParser();
  }
  @:noUsing static public function Failed<P,R>(msg,is_error = false,?id):Parser<P,R>{
    return new Failed(msg,is_error,id).asParser();
  }
  @:noUsing static public function Succeed<P,R>(value,?id):Parser<P,R>{
    return new Succeed(value,id).asParser();
  }
  var self(get,never):Parser<I,O>;
  function get_self():Parser<I,O>{
    return lift(this);
  }
  public inline function asParser():Parser<I,O>{
    return self;
  }
}
class ParserLift{
  static public inline function or<I,T>(p1 : Parser<I,T>, p2 : Parser<I,T>):Parser <I,T>{
    return new Or(p1,p2).asParser();
  }
  static public inline function ors<I,T>(ps:Array<Parser<I,T>>):Parser<I,T>{
    return new Ors(ps).asParser();
  }
  static public inline function then<I,T,U>(p:Parser<I,T>,f : T -> U):Parser<I,U>{
    return new Then(p,f).asParser();
  }
  static public inline function and_then<I,T,U>(p:Parser<I,T>,fn:T->Parser<I,U>):Parser<I,U>{
    return new AndThen(p,fn).asParser();
  }
  static public inline function many<I,T>(p1:Parser<I,T>):Parser<I,Array<T>>{
    return new Many(p1).asParser();
  }
  static public inline function one_many<I,T>(p1:Parser<I,T>):Parser<I,Array<T>>{
    return new OneMany(p1).asParser();
  }
  static public inline function and_<I,T,U>(p1:Parser<I,T>,p2 : Parser<I, U>):Parser <I,T> {
    return new AndL(p1,p2).asParser();
  }
  static public inline function and<I,T,U>(p1:Parser<I,T>,p2 : Parser<I,U>):Parser<I,Couple<T,U>>{
    return new With(p1,p2,(l:T,r:U) ->__.couple(l,r)).asParser();
  }
  static public inline function and_seq<I,T>(p1:Parser<I,T>,p2 : Parser<I,T>):Parser<I,Array<T>>{
    return new With(p1,p2,(l:T,r:T) -> [l,r]).asParser();
  }
  //@:native("__and") // Prevent a bug with hxcpp
  static public inline function _and<I,T,U>(p1:Parser<I,T>, p2 : Parser<I,U>):Parser<I,U> {
    return new AndR(p1,p2).asParser();
  }
  static public inline function and_with<I,T,U,V>(p1:Parser<I,T>,p2:Parser<I,U>,f:T->U->V):Parser<I,V>{
    return new With(p1,p2,f).asParser();
  }
  static public inline function commit<I,T> (p1 : Parser<I,T>):Parser <I,T>{
    return new Commit(p1).asParser();
  }
  static public inline function notEmpty<T>(arr:Array<T>):Bool return arr.length>0;


  static public inline function trace<I,T>(p : Parser<I,T>, f : T -> String):Parser<I,T> return
    return then(p,function (x:T) { trace(f(x)); return x;} );

  //static public inline function print<I,O>(p : Parser<I,O>,f : Input<I> -> String):Parser<I,I>{
    //return Parser.
  //}
  static public inline function xs<I,T>(p:Parser<I,T>, f : Input<I> -> Void):Parser<I,T>{
    return new Parser(new Anon(function(i:Input<I>):ParseResult<I,T>{
      var out = p.parse(i);
      f(out.pos());
      return out;
    }));
  }
  static public inline function identifier(x : String):Parser<String,String>{
    return new Identifier(x).asParser();
  }

  static public inline function regexParser(str : String):Parser<String,String>{
    return new Parser(new Regex(str));
  }
    
  static public inline function rep1sep<I,T,U>(p1:Parser<I,T>,sep : Parser<I,U> ):Parser < I, Array<T> > {
    return new Rep1Sep(p1,sep).asParser(); /* Optimize that! */
  }
  static public inline function rep1sep0<I,T,U>(p1:Parser<I,T>,sep : Parser<I,T> ):Parser<I,Array<T>> {
    var next : Parser<I,Array<Couple<T,T>>> = many(and(sep,p1)).asParser();
    return then(and(p1,next).asParser(),
      function (t){ 
        var fst = t.fst();
        var snd = Lambda.array(Lambda.flatMap(t.snd(),
          (tp) -> [tp.fst(),tp.snd()]
        ));
        var out = [t.fst()].concat(snd);
        return out;
      }
    ).asParser(); /* Optimize that! */
  }
  static public inline function repsep0<I,T>(p1:Parser<I,T>,sep : Parser<I,T> ):Parser < I, Array<T> > {
    return or(rep1sep0(p1,sep),Succeed.pure([])).asParser();
  }
  static public inline function repsep<I,T,U>(p1:Parser<I,T>,sep : Parser<I,U> ):Parser < I, Array<T> > {
    return new RepSep(p1,sep).asParser(); /* Optimize that! */
  }
  static public inline function with_error_tag<I,T>(p:Parser<I,T>, name : String ):Parser<I,T>
    return new ErrorTransformer(p,
      (err:ParseError) -> err.map(
        info -> info.tag(name)
      )
  ).asParser();
 
  static public inline function filter<I,T>(p:Parser<I,T>,fn:T->Bool):Parser<I,T>{
    return new AndThen(
      p,
      function(o:T){
        return fn(o) ? Parser.lift(new Succeed(o)) : Parser.lift(new Failed('filter failed',false)); 
      }
    ).asParser();
  }
  static public inline function option<I,T>(p:Parser<I,T>):Parser<I,Option<T>>{
    return new Parser(new OptionP(p));
  }
  static public inline function eof<I,U>(input:Input<I>):ParseResult<I,U>{
    //trace(input);
    //trace(input.offset);
    //trace(input.is_end());
    return input.is_end() ? input.nil() : input.fail('not at end');
  }
  static public function inspect<I,O>(parser:Parser<I,O>,pre:Input<I>->Void,post:ParseResult<I,O>->Void):Parser<I,O>{
    return new Inspect(parser,pre,post).asParser();
  }
}
