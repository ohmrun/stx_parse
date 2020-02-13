package com.mindrocks.text;

@:forward abstract ParseResult<I,T>(ParseResultT<I,T>) from ParseResultT<I,T>{
  @:noUsing static public inline function fail<I,T>(error,rest, isError : Bool,?pos:Pos):ParseResult<I,T>{
    return ParseResultT.Failure(error,rest,isError,pos);
  }
  // public function info(){
  //   return switch(this){
  //     case Success(_,xs)   : (xs.length - xs.index);
  //     case Failure(_,xs,_) : (xs.length - xs.index);
  //   }
  // }
  public function pos() : Input<I>
    return switch (this) {
      case Success(_, xs)     : xs;
      case Failure(_, xs, _)  : xs;
    }

  public function match()
    return switch (this) {
      case Success(x, _)    : Std.string(x);
      case Failure(_, _, _) : "";
    }
  inline public function elide<U>() : ParseResult<I,U> return cast(this);

  public function mkLR(rule,head){
    return ParseResults.mkLR(this,rule,head);
  }
  public function fold<Z>(succ:T->Input<I>->Z,fail:FailureStack->Input<I>->Bool->Z){
    return switch(this){
      case Success(match, xs)                 : succ(match,xs);
      case Failure(errorStack, xs, isError)   : fail(errorStack,xs,isError);
    }
  }
  public function sfold<Z>(succ:ParseResult<I,T>->T->Input<I>->Z,fail:ParseResult<I,T>->FailureStack->Input<I>->Bool->Z){
    return switch(this){
      case Success(m, xs)                     : succ(this,m,xs);
      case Failure(errorStack, xs, isError)   : fail(this,errorStack,xs,isError);
    }
  }
  public function toString(){
    return fold(
      (v:T,i:Input<I>)  -> __.show(v),
      (e,_,_)           -> __.show(e)
    );
  }
  public function isSuccess(){
    return fold(
      (_,_)   -> true,
      (_,_,_) -> false
    );
  }
  //public function pipe()
  @:noUsing static public function succeed<I,O>(x:O,xs:Input<I>):ParseResult<I,O>{
    return Success(x,xs);
  }
  @:noUsing static public function failed<I,O>(stack,xs,isError):ParseResult<I,O>{
    return Failure(stack,xs,isError);
  }
  public function thread(fn:T->(Input<I>->ParseResult<I,T>)):ParseResult<I,T>{
    return switch(this){
      case Success(match, rest) : fn(match)(rest);
      default                   : this;
    }
  }
  public function mod(fn:T->T):ParseResult<I,T>{
    return switch(this){
      case Success(x,xs)  : Success(fn(x),xs);
      default             : this;
    }
  }
  public function asParser():Parser<I,T>{
    return new Pure(this).asParser();
  }
  public function def(fn:Void->T){
    return switch(this){
      case Success(x,_) : x;
      default           : fn();
    }
  }
} 