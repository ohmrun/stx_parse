package stx.parse.pack.enumerable.term;

import stx.ds.pack.LinkedList in StxLinkedList;

class LinkedList<T> extends Base<StxLinkedList<T>,T>{
  
  override public function isEnd(){
    return !this.data.is_defined();
  }
  override public function match(fn){
    return fn(head());
  }
  override public function prepend(v:T):Enumerable<StxLinkedList<T>,T>{
    return new ListEnumerable(this.data.cons(v),index);
  }
  override public function take(?len):LinkedList<T>{
    return if(len == null){
      this.data;
    }else{
      var go = null;
      var go = (source,i) -> {
        return switch([source,i]){
          case [_,0]          : Nil.ds();
          case [Cons(x,xs),_] : go(xs,i--).cons(x);
          case [Nil,_]        : Nil.ds();
        }
      }
      go(this.data,len);
    }
  }
  override public function drop(n:Int):Enumerable<LinkedList<T>,T>{
    var i = n;
    var x = this.data;
    while(i>0){
      x = switch(x){
        case Cons(x,xs) : xs;
        default         : Nil;
      }
      i = i - 1;
    }
    return new ListEnumerable(x,index+n);
  }
  override public function head():T{
    return this.data.head();
  }
  public function asEnumerable():Enumerable<LinkedList<T>,T>{
    return this;
  }
}