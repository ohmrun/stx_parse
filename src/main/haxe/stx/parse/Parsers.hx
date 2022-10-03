package stx.parse;

class Parsers{
  @:noUsing static inline public function Anon<P,R>(fn:ParseInput<P> -> ParseResult<P,R>,tag:Option<String>,?pos:Pos):Parser<P,R>{
    return new stx.parse.parser.term.Anon(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function SyncAnon<P,R>(fn:ParseInput<P> -> ParseResult<P,R>,tag:Option<String>,?pos:Pos):Parser<P,R>{
    return new stx.parse.parser.term.SyncAnon(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function TaggedAnon<P,R>(fn:ParseInput<P> -> ParseResult<P,R>,tag,?pos:Pos):Parser<P,R>{
    return new stx.parse.parser.term.TaggedAnon(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function Failed<P,R>(msg,is_fatal = false,?id:Pos):Parser<P,R>{
    return new stx.parse.parser.term.Failed(msg,is_fatal,id).asParser();
  }
  @:noUsing static inline public function Succeed<P,R>(value:R,?pos:Pos):Parser<P,R>{
    return new stx.parse.parser.term.Succeed(value,pos).asParser();
  }
  @:noUsing static inline public function Stamp<P,R>(result:ParseResult<P,R>,?pos:Pos):Parser<P,R>{
    return new stx.parse.parser.term.Stamp(result,pos).asParser();
  }
  // @:noUsing static inline public function Closed<P,R>(self:Provide<ParseResult<P,R>>,?pos:Pos):Parser<P,R>{
  //   return new stx.parse.parser.term.Closed(self,pos).asParser();
  // }
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
  @:noUsing static inline public function Option<I,O>(p:Parser<I,O>): Parser<I,Option<O>>{
    return new stx.parse.parser.term.Option(p).asParser();
  }
  @:noUsing static inline public function Choose<I,O>(fn:I->Option<O>,?tag:Option<String>,?pos:Pos): Parser<I,O>{
    return new stx.parse.parser.term.Choose(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function When<I>(fn:I->Bool,?tag:Option<String>,?pos:Pos):Parser<I,I>{
    return new stx.parse.parser.term.When(fn,tag,pos).asParser();
  }
  @:noUsing static inline public function Materialize<I,O>(parser:Parser<I,O>):Parser<I,O>{
    return new stx.parse.parser.term.Materialize(parser).asParser();
  }
  @:noUsing static inline public function Inspect<I,O>(parser:Parser<I,O>,?prefix:ParseInput<I>->Void,?postfix:ParseResult<I,O>->Void,?pos:Pos):Parser<I,O>{
    return new stx.parse.parser.term.Inspect(parser,prefix,postfix,pos).asParser();
  }
  @:noUsing static inline public function TagRefuse<I,O>(parser:Parser<I,O>,name:String,?pos:Pos):Parser<I,O>{
    return new stx.parse.parser.term.TagRefuse(parser,name,pos).asParser();
  }
  // @:noUsing static inline public function Debug<P,R>(parser:Parser<P,R>):Parser<P,R>{
  //   return new stx.parse.parser.term.Debug(parser).asParser();
  // }
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
  @:noUsing static inline public function Head<I,O>(fn:I->Option<Couple<O,Option<I>>>):Parser<I,O>{
		return new stx.parse.parser.term.Head(fn).asParser();
	}
  @:noUsing static inline public function AndR<P,Ri,Rii>(l:Parser<P,Ri>,r:Parser<P,Rii>):Parser<P,Rii>{
    return new stx.parse.parser.term.AndR(l,r).asParser();
  }
  @:noUsing static inline public function AndL<P,Ri,Rii>(l:Parser<P,Ri>,r:Parser<P,Rii>):Parser<P,Ri>{
    return new stx.parse.parser.term.AndL(l,r).asParser();
  }
  @:noUsing static inline public function LAnon<P,R>(fn:Void->Parser<P,R>,?pos:Pos):Parser<P,R>{
    return new stx.parse.parser.term.LAnon(fn,pos).asParser();
  }
  @:noUsing static inline public function AnonWith<P,Ri,Rii,Riii>(pI:Parser<P,Ri>,pII:Parser<P,Rii>,f:Null<Ri>->Null<Rii>->Option<Riii>){
    return new stx.parse.parser.term.AnonWith(pI,pII,f).asParser();
  }
  static public inline function CoupleWith<P,Ri,Rii>(pI:Parser<P,Ri>,pII : Parser<P,Rii>):Parser<P,Couple<Ri,Rii>>{
    return new stx.parse.parser.term.CoupleWith(pI,pII).asParser();
  }
  static public inline function Rep1Sep<P,Ri,Rii>(pI:Parser<P,Ri>,sep : Parser<P,Rii> ):Parser <P, Cluster<Ri>> {
    return new stx.parse.parser.term.Rep1Sep(pI,sep).asParser(); /* Optimize that! */
  }
  static public inline function Commit<I,T> (pI : Parser<I,T>):Parser <I,T>{
    return new stx.parse.parser.term.Commit(pI).asParser();
  }
  static public inline function Not<I,O>(p:Parser<I,O>,?pos:Pos):Parser<I,O>{
		return new stx.parse.parser.term.Not(p,pos).asParser();
	}
  static public inline function Until<I,O>(p:Parser<I,O>,?pos:Pos):Parser<I,Cluster<O>>{
		return new stx.parse.parser.term.Until(p,pos).asParser();
	}
}

