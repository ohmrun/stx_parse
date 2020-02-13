package com.mindrocks.text.parsers;

class Commit<I,T> extends Delegate<I,T>{
  public function new(delegation,?id){
    super(delegation,id);
  }
  override function do_parse(ipt){
    var res = delegation.parse(ipt);
    return switch(res) {
      case Success(_, _): 
        res;
      case Failure(err, xs, isError) :
        (isError || err.isParseFail())  ? res : err.toParseResult(xs,true);
    }
  }
}