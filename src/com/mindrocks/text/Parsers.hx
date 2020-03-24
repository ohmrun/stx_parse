package com.mindrocks.text;

@:native("Parsers") class Parsers {
  static public inline function or<I,T>(p1 : Parser<I,T>, p2 : Parser<I,T>):Parser <I,T>{
    return new Or(p1,p2).asParser();
  }
  static public inline function ors<I,T>(ps:Array<Parser<I,T>>):Parser<I,T>{
    return new Ors(ps).asParser();
  }
  static public inline function then<I,T,U>(p:Parser<I,T>,f : T -> U):Parser<I,U>{
    return new Then(p,f).asParser();
  }
  static public inline function andThen<I,T,U>(p:Parser<I,T>,fn:T->Parser<I,U>):Parser<I,U>{
    return new AndThen(p,fn).asParser();
  }
  static public inline function many<I,T>(p1:Parser<I,T>):Parser<I,Array<T>>{
    return new Many(p1).asParser();
  }
  static public inline function oneMany<I,T>(p1:Parser<I,T>):Parser<I,Array<T>>{
    return new OneMany(p1).asParser();
  }
  static public inline function and_<I,T,U>(p1:Parser<I,T>,p2 : Parser<I, U>):Parser <I,T> {
    return new With(p1,p2,(a,_) -> a).asParser();
  }
  static public inline function and<I,T,U>(p1:Parser<I,T>,p2 : Parser<I,U>):Parser<I,Couple<T,U>>{
    return new With(p1,p2,(l:T,r:U) ->__.couple(l,r)).asParser();
  }
  static public inline function and_seq<I,T>(p1:Parser<I,T>,p2 : Parser<I,T>):Parser<I,Array<T>>{
    return new With(p1,p2,(l:T,r:T) -> [l,r]).asParser();
  }
  @:native("__and") // Prevent a bug with hxcpp
  static public inline function _and<I,T,U>(p1:Parser<I,T>, p2 : Parser<I,U>):Parser<I,U> {
    return andWith(p1,p2, (_,b) -> b);
  }
  static public inline function andWith<I,T,U,V>(p1:Parser<I,T>,p2:Parser<I,U>,f:T->U->V):Parser<I,V>{
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
    return or(rep1sep0(p1,sep),[].success()).asParser();
  }
  static public inline function repsep<I,T,U>(p1:Parser<I,T>,sep : Parser<I,U> ):Parser < I, Array<T> > {
    return new RepSep(p1,sep).asParser(); /* Optimize that! */
  }
  static public inline function withError<I,T>(p:Parser<I,T>, name : String ):Parser<I,T>
    return new ErrorTransformer(p,ErrorNamed.bind(name)).asParser();

  
  @:noUsing static public inline function tagged<I,T>(p : Parser<I,T>, tag : String):Parser<I,T> {
    p.tag = Some(tag);
    return withError(p, tag);
  } 
  static public inline function filter<I,T>(p:Parser<I,T>,fn:T->Bool):Parser<I,T>{
    return new AndThen(
      p,
      function(o){
        return fn(o) ? Parser.lift(new Succeed(o)) : Parser.lift(new Failed('filter failed',false)); 
      }
    ).asParser();
  }
  static public inline function option<I,T>(p:Parser<I,T>):Parser<I,Option<T>>{
    return new Parser(new OptionP(p));
  }
  static public inline function eof<I,U>(input:Input<I>):ParseResult<I,U>{
    return input.isEnd() ? com.mindrocks.text.Lift.yes(null,input) : com.mindrocks.text.Lift.no("not at end",input);
  }
  static public inline function succeed<I,O>(v:O):Parser<I,O>{
    return new Succeed(v).asParser();
  }
  static public function inspect<I,O>(parser:Parser<I,O>,pre,post):Parser<I,O>{
    return new Inspect(parser,pre,post).asParser();
  }

}
