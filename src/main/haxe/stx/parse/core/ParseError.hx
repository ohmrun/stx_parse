package stx.parse.core;

typedef ParseErrorDef = {
  public var idx(default,null)              : Int;
  public var msg(default,null)              : String;
  public var fatal(default,null)            : Bool;
  @:optional public var label(default,null) : String;
}
@:forward abstract ParseError(ParseErrorDef) from ParseErrorDef{
  static public var FAIL(default,never) = 'FAIL';
  
  public function new(self) this = self;

  @:noUsing static public function make(idx:Int,msg:String,fatal:Bool,?label):ParseError{
    return new ParseError({
      idx   : idx,
      msg   : msg,
      fatal : fatal,
      label : label
    });
  }
  public function tag(name):ParseError{
    return make(this.idx,name,this.fatal);
  }
  public function toString(){
    return '${this.msg}@${this.idx}';
  }
  @:to public function toDefect(){
    return Defect.pure(this);
  }
  @:to public function toError(){
    return Error.make(Some(this),None,null);
  }
}