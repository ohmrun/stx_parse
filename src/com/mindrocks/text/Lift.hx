package com.mindrocks.text;

class Lift{
  // static public inline function errorAt<I>(msg : String, pos : Input<I>) : FailureMsg {
  //   return {
  //     msg : msg,
  //     pos : pos.offset
  //   };
  // }
  // static public inline function newStack(failure : FailureMsg,?pos:Pos) : FailureStack {
  //   return __.fault(pos).of(ParseFailed(failure));
  // }
  // static public inline function report(stack : FailureStack, msg : Err<ParserFailure>) : FailureStack {
  //   return stack.next(msg);
  // }
}
class LiftRegexWorkaround{
  @:access(com.mindrocks.text) static public function parsify(regex:hre.RegExp,ipt:Input<String>):hre.Match{
    //trace(ipt.content.data);
    var data : String = (cast ipt).content.data;
    if(data == null){
      data = "";
    }
    data = data.substr(ipt.offset);
    return regex.exec(data);
  }
}