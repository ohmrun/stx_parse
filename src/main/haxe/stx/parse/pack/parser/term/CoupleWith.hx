package stx.parse.pack.parser.term;

class CoupleWith<I,T,U> extends With<I,T,U,Couple<T,U>>{
  override function transform(l:Null<T>,r:Null<U>){
    return __.option(__.couple(l,r));
  }
}