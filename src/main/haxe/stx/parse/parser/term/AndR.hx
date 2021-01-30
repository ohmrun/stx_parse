package stx.parse.parser.term;

class AndR<I,T,U> extends With<I,T,U,U>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?pos:Pos){
    __.assert().exists(l);
    __.assert().exists(r);
    super(l,r,pos);
  }
  override function check(){
    __.assert().exists(delegation);
  }
  public inline function transform(lhs:Null<T>,rhs:Null<U>){
    return __.option(rhs);
  }
}