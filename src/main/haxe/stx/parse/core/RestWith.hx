package stx.parse.core;

class RestWithCls<P,T>{
  public var rest(default,null) : Input<P>;
  public var with(default,null) : T;
  public function new(rest,with){
    this.rest = rest;
    this.with = with;
  }
  public function toString(){
    return @:privateAccess 'RestWith@${rest.content.index}(${with.toString()})';
  }
}
typedef RestWithDef<P,T> = {
  public var rest(default,null) : Input<P>;
  public var with(default,null) : T;
}
@:forward abstract RestWith<P,T>(RestWithDef<P,T>) from RestWithDef<P,T> to RestWithDef<P,T>{
  public function new(self) this = self;
  static public function lift<P,T>(self:RestWithDef<P,T>):RestWith<P,T> return new RestWith(self);
  
  static public function make<P,T>(rest:Input<P>,with:T){
    return lift(new RestWithCls(rest,with));
  }
  

  public function prj():RestWithDef<P,T> return this;
  private var self(get,never):RestWith<P,T>;
  private function get_self():RestWith<P,T> return lift(this);
}