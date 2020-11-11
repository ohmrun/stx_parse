package stx.parse.parser.term;

class AnonWith<I,T,U,V> extends With<I,T,U,V>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,__transform:Null<T>->Null<U>->Option<V>,?pos:Pos){
    super(l,r,pos);
    this.__transform = __transform;
  }
  public dynamic function __transform(lhs:Null<T>,rhs:Null<U>){
    return throw 'constructor not called';
  }
  override public inline function transform(lhs:Null<T>,rhs:Null<U>):Option<V>{
    return __transform(lhs,rhs);
  }
}