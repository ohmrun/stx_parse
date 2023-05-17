package stx.parse.parser.term;

class AndL<I,T,U> extends With<I,T,U,T>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?pos:Pos){
    super(l,r,pos);
  }
  override function check(){
    __.assert().that().exists(delegation);
  }
  public inline function transform(lhs:Null<T>,rhs:Null<U>){
    return __.option(lhs);
  }
}