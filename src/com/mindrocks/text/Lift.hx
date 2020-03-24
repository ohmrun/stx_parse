package com.mindrocks.text;

class Lift{
  static public inline function errorAt<I>(msg : String, pos : Input<I>) : FailureMsg {
    return {
      msg : msg,
      pos : pos.offset
    };
  }
  static public inline function newStack(failure : FailureMsg,?pos:Pos) : FailureStack {
    return __.fault(pos).of(ParseFailed(failure));
  }
  static public inline function report(stack : FailureStack, msg : Err<ParserFailure>) : FailureStack {
    return stack.next(msg);
  }

  static public inline function fail<I,T>(msg : String, isError : Bool) : Parser<I,T>
    return new Failed(msg,isError).asParser();

  
  static public inline function success<I, T>(v : T):Parser<I,T>  
	  return Parser.lift(new Succeed(v));
  
  static public inline function identifier(str:String){
    return Parsers.identifier(str);
  }
  static public inline function ors<I,O>(arr:Array<Parser<I,O>>){
    return Parsers.ors(arr);
  }
  static public inline function option<I,O>(ps:Parser<I,O>):Parser<I,Option<O>>{
    return Parsers.option(ps);
  }
  static public inline function regexParser(s:String):Parser<String,String>{
    return Parsers.regexParser(s);
  }
  static public inline function defer<I,O>(f:Void->Parser<I,O>):Parser<I,O>{
    return Parser.fromConstructor(f);
  }
  static public function yes<I,O>(o:O,ipt:Input<I>):ParseResult<I,O>{
    return Success(o,ipt);
  }
  static public function no<I,O>(str:String,pos:Input<I>,?is_error = false,?p:Pos):ParseResult<I,O>{
    return Failure(newStack(errorAt(str,pos)),pos,is_error,p);
  }
}
class LiftArray{
  @:from inline public static function reader<T>(arr : Array<T>) : Input<T> return {
    return Input.pure(new ArrayEnumerable(arr));
  }
}
class LiftString{
  @:from inline public static function reader(str : String) : Input<String> return {
    return Input.pure(new StringEnumerable(str));
  }
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