package stx.fail;

typedef ParseFailureDef = {
  public var idx(default,null)              : Int;
  public var msg(default,null)              : ParseFailureCode;
  public var fatal(default,null)            : Bool;
  @:optional public var label(default,null) : String;
}
@:transitive @:forward abstract ParseFailure(ParseFailureDef) from ParseFailureDef{
  static public var FAIL(default,never) = 'FAIL';
  
  public function new(self) this = self;

  @:noUsing static public function make(idx:Int,msg:ParseFailureCode,fatal:Bool,?label):ParseFailure{
    return new ParseFailure({
      idx   : idx,
      msg   : msg,
      fatal : fatal,
      label : label
    });
  }
  public function tag(name:String):ParseFailure{
    return make(this.idx,E_Parse_ParseFailed(name),this.fatal);
  }
  public function toString(){
    return '${this.msg}@${this.idx}';
  }
  @:to public function toDefect(){
    return Defect.pure(this);
  }
  @:to public function toRefuse(){
    return Refuse.make(Some(EXTERNAL(this)),None,null);
  }
}