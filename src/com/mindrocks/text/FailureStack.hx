package com.mindrocks.text;


@:forward abstract FailureStack(FailureStackT) from FailureStackT to FailureStackT{
  static inline public function nil(){
    return LinkedList.unit();
  }
  public function cons(x):FailureStack{
    return this.next(x);
  }
  public function isParseFail(){
    return switch(this.last().head()){
      case Some(ParseFailed(x)) if(x.msg == ParseFail.FAIL)   : true;
      default                                                 : false;
    }
  }
  public function toParseResult<I,T>(rest : Input<I>, isError,?pos:Pos):ParseResult<I,T>{
    return Failure(this,rest,isError,pos);
  }
  public function toString(){
    return Std.string(this.data);
  }
}