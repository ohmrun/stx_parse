package com.mindrocks.text;

@:forward abstract Parser<I,O>(Interface<I,O>) to Interface<I,O>{
  public function new(self:Interface<I,O>){
    this = self;
  }
  @:noUsing static inline public function eof<I,O>():Parser<I,O>{
    return new Parser(new Anon(Parsers.eof));
  }
  @:noUsing static inline public function fromConstructor<I,O>(fn:Void->Parser<I,O>):Parser<I,O>{
    return lift(new LAnon(fn));
  }
  @:noUsing static inline public function fromInterface<I,O>(it:Interface<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  @:noUsing static inline public function fromFunction<I,O>(f:Input<I>->ParseResult<I,O>):Parser<I,O>{
    return new Anon(f).asParser();
  }
  @:noUsing static inline public function lift<I,O>(it:Interface<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  public function mkHead() : Head return {
    headParser    : cast elide(),
    involvedSet   : List.unit(),
    evalSet       : List.unit()
  }
  inline public function elide<U>() : Parser<I,U> return cast(self);

  inline public function andWith<U,V>(that:Parser<I,U>,fn:O->U->V):Parser<I,V>{
    return Parsers.andWith(self,that,fn);
  }
  inline public function and<U>(that:Parser<I,U>):Parser<I,Tuple2<O,U>>{
    return Parsers.and(self,that);
  }
  inline public function and_seq(that:Parser<I,O>):Parser<I,Array<O>>{
    return Parsers.and_seq(self,that);
  }
  inline public function _and<U>(that:Parser<I,U>):Parser<I,U>{
    return Parsers._and(self,that);
  }
  inline public function and_<U>(that:Parser<I,U>):Parser<I,O>{
    return Parsers.and_(self,that);
  }


  inline public function or(that:Parser<I,O>):Parser<I,O>{
    return Parsers.or(self,that);
  }


  inline public function many():Parser<I,Array<O>>{
    return Parsers.many(self);
  }
  inline public function oneMany():Parser<I,Array<O>>{
    return Parsers.oneMany(self);
  }


  inline public function commit():Parser<I,O>{
    return Parsers.commit(self);
  }

  inline public function then<U>(fn:O->U):Parser<I,U>{
    return Parsers.then(self,fn);
  }
  inline public function andThen<U>(fn:O->Parser<I,U>):Parser<I,U>{
    return Parsers.andThen(self,fn);
  }
  inline public function trace(fn):Parser<I,O>{
    return Parsers.trace(self,fn);
  }
  inline public function filter(fn:O->Bool):Parser<I,O>{
    return Parsers.filter(self,fn);
  }

  inline public function tagged(tag : String):Parser<I,O> {
    return Parsers.tagged(self,tag);
  }
  inline public function xs(fn):Parser<I,O>{
    return Parsers.xs(self,fn);
  }

  inline public function repsep<U>(sep:Parser<I,U>):Parser<I,Array<O>>{
    return Parsers.repsep(self,sep);
  }
  inline public function repsep0(sep:Parser<I,O>):Parser<I,Array<O>>{
    return Parsers.repsep0(self,sep);
  }
  inline public function rep1sep<U>(sep:Parser<I,U>):Parser<I,Array<O>>{
    return Parsers.rep1sep(self,sep);
  }
  inline public function rep1sep0(sep:Parser<I,O>):Parser<I,Array<O>>{
    return Parsers.repsep0(self,sep);
  }
  inline public function inspect(pre,post):Parser<I,O>{
    return Parsers.inspect(self,pre,post);
  }








  inline public function memo():Parser<I,O>{
    return LRs.memo(self);
  }
  inline public function recall(genKey : Int -> String, input : Input<I>) : Option<MemoEntry>{
    return LRs.recall(self,genKey,input);
  }
  inline public function lrAnswer(genKey : Int -> String, input: Input<I>, growable: LR){
    return LRs.lrAnswer(self,genKey,input,growable);
  }
  var self(get,never):Parser<I,O>;
  function get_self():Parser<I,O>{
    return lift(this);
  }
  public inline function asParser():Parser<I,O>{
    return self;
  }
}