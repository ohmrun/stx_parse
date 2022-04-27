package stx.parse.core;

typedef ParseRefuseDef = {
  public var idx(default,null)              : Int;
  public var msg(default,null)              : String;
  public var fatal(default,null)            : Bool;
  @:optional public var label(default,null) : String;
}
@:transitive @:forward abstract ParseRefuse(ParseRefuseDef) from ParseRefuseDef{
  static public var FAIL(default,never) = 'FAIL';
  
  public function new(self) this = self;

  @:noUsing static public function make(idx:Int,msg:String,fatal:Bool,?label):ParseRefuse{
    return new ParseRefuse({
      idx   : idx,
      msg   : msg,
      fatal : fatal,
      label : label
    });
  }
  public function tag(name):ParseRefuse{
    return make(this.idx,name,this.fatal);
  }
  public function toString(){
    return '${this.msg}@${this.idx}';
  }
  @:to public function toDefect(){
    return Defect.pure(this);
  }
  @:to public function toRefuse(){
    return Refuse.make(Some(EXTERIOR(this)),None,null);
  }
}