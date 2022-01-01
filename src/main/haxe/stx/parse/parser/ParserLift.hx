package stx.parse.parser;

import stx.parse.parser.term.*;

class ParserLift{
  static public inline function or<I,T>(pI : Parser<I,T>, p2 : Parser<I,T>):Parser <I,T>{
    return Parser.Or(pI,p2).asParser();
  }
  static public inline function ors<I,T>(self:Parser<I,T>,rest:Array<Parser<I,T>>):Parser<I,T>{
    //return Parser.Ors([self].concat(rest)).asParser();
    return [self].concat(rest).lfold1((memo,next) -> memo.or(next)).defv(self);
  }
  static public inline function then<I,T,U>(p:Parser<I,T>,f : T -> U):Parser<I,U>{
    return Parser.AnonThen(p,f).asParser();
  }
  static public inline function and_then<I,T,U>(p:Parser<I,T>,fn:T->Parser<I,U>):Parser<I,U>{
    return Parser.AndThen(p,fn).asParser();
  }
  static public inline function many<I,T>(pI:Parser<I,T>):Parser<I,Array<T>>{
    return Parser.Many(pI).asParser();
  }
  static public inline function one_many<I,T>(pI:Parser<I,T>):Parser<I,Array<T>>{
    return new OneMany(pI).asParser();
  }
  static public inline function and_<I,T,U>(pI:Parser<I,T>,p2 : Parser<I, U>):Parser <I,T> {
    return new AndL(pI,p2).asParser();
  }
  static public inline function and<I,T,U>(pI:Parser<I,T>,p2 : Parser<I,U>):Parser<I,Couple<T,U>>{
    return new stx.parse.parser.term.CoupleWith(pI,p2).asParser();
  }
  static public inline function and_seq<I,T>(pI:Parser<I,T>,p2 : Parser<I,T>):Parser<I,Array<T>>{
    return new stx.parse.parser.term.AnonWith(pI,p2,(l:T,r:T) -> [l,r]).asParser();
  }
  //@:native("__and") // Prevent a bug with hxcpp
  static public inline function _and<I,T,U>(pI:Parser<I,T>, p2 : Parser<I,U>):Parser<I,U> {
    return new AndR(pI,p2).asParser();
  }
  static public inline function and_with<I,T,U,V>(pI:Parser<I,T>,p2:Parser<I,U>,f:Null<T>->Null<U>->Option<V>):Parser<I,V>{
    return new AnonWith(pI,p2,f).asParser();
  }
  static public inline function commit<I,T> (pI : Parser<I,T>):Parser <I,T>{
    return new Commit(pI).asParser();
  }
  static public inline function mod<I,T,TT>(p:Parser<I,T>,fn:ParseResult<I,T>->ParseResult<I,TT>):Parser<I,TT>{
    return Parser.Arrow(Fletcher.Then(
      p,
      Fletcher.Sync(fn)
    ));
  }
  //TODO: pretty sure this is map now
  static public inline function postfix<I,T,TT>(p:Parser<I,T>,fn:ParseResult<I,T>->TT):Fletcher<ParseInput<I>,TT,Noise>{
    return Fletcher.Then(
      p,
      Fletcher.Sync(fn)
    );
  }

  static public inline function notEmpty<T>(arr:Array<T>):Bool return arr.length>0;


  static public inline function trace<I,T>(p : Parser<I,T>, f : T -> String):Parser<I,T> return
    return then(p,function (x:T) { trace(f(x)); return x;} );

  // static public inline function xs<I,T>(p:Parser<I,T>, f : ParseInput<I> -> Void):Parser<I,T>{
  //   return new Parser(new Anon(function(i:ParseInput<I>):ParseResult<I,T>{
  //     var out = p.parse(i);
  //     f(out.pos());
  //     return out;
  //   }));
  // }  
  static public inline function rep1sep<I,T,U>(pI:Parser<I,T>,sep : Parser<I,U> ):Parser <I, Array<T>> {
    return new Rep1Sep(pI,sep).asParser(); /* Optimize that! */
  }
  static public inline function rep1sep0<I,T,U>(pI:Parser<I,T>,sep : Parser<I,T> ):Parser<I,Array<T>>{
    var next : Parser<I,Array<Couple<T,T>>> = many(and(sep,pI)).asParser();
    return then(and(pI,next).asParser(),
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
  static public inline function repsep0<I,T>(pI:Parser<I,T>,sep : Parser<I,T> ):Parser < I, Array<T> > {
    return or(rep1sep0(pI,sep),Succeed.pure([])).asParser();
  }
  static public inline function repsep<I,T,U>(pI:Parser<I,T>,sep : Parser<I,U> ):Parser < I, Array<T> > {
    return new Rep1Sep(pI,sep).asParser(); /* Optimize that! */ 
  }
  static public inline function option<I,T>(p:Parser<I,T>):Parser<I,StdOption<T>>{
    return new Parser(new stx.parse.parser.term.Option(p));
  }
  static public function inspect<I,O>(parser:Parser<I,O>,pre:ParseInput<I>->Void,post:ParseResult<I,O>->Void):Parser<I,O>{
    return new Inspect(parser,pre,post).asParser();
  }
  static public function provide<I,O>(parser:Parser<I,O>,input:ParseInput<I>):Provide<ParseResult<I,O>>{
    return Provide.fromFunTerminalWork(parser.defer.bind(input));
  }
  static public function lookahead<I,O>(p:Parser<I,O>):Parser<I,O>{
    return Parser.Lookahead(p);
  }
  /**
	 * Returns true if the parser fails and vice versa.
	 */
	static public inline function not<I,O>(p:Parser<I,O>,?pos:Pos):Parser<I,O>{
		return new Not(p,pos).asParser();
	}
  static public inline function filter<I,T>(p:Parser<I,T>,fn:T->Bool):Parser<I,T>{
    return new stx.parse.parser.term.AndThen(
      p,
      function(o:T){
        return fn(o) ? Parser.lift(Parser.Succeed(o)) : Parser.lift(Parser.Failed('filter failed',false)); 
      }
    ).asParser();
  }
  static public function tokenize(p:Parser<String,Array<String>>):Parser<String,String>{
		return p.then(
			(arr) -> __.option(arr).defv([]).join("")
		);
  }
  static public inline function tag_error<I,T>(p:Parser<I,T>, name : String, ?pos: Pos ):Parser<I,T>
    return Parser.TagError(p,name,pos);

  static public inline function with_tag<P,R>(p:Parser<P,R>,tag:String){
    return Parser.Named(p,tag);
  }
  /**
   * Lift a parser to a packrat parser (memo is derived from scala's library)
   */
	 public static function memo<I,T>(p : Parser<I,T>) : Parser<I,T>{
    return new stx.parse.parser.term.Memoise(p).asParser();
  };
}
