package stx.parse.pack;

typedef RestWithDef<P,T> = {
  public var rest : Input<P>;
  public var with : T;
}
@:forward abstract RestWith<P,T>(RestWithDef<P,T>) from RestWithDef<P,T> to RestWithDef<P,T>{
  public function new(self) this = self;
  static public function lift<P,T>(self:RestWithDef<P,T>):RestWith<P,T> return new RestWith(self);
  
  static public function make<P,T>(rest:Input<P>,with:T){
    return lift({
      rest : rest,
      with : with
    });
  }
  

  public function prj():RestWithDef<P,T> return this;
  private var self(get,never):RestWith<P,T>;
  private function get_self():RestWith<P,T> return lift(this);
}