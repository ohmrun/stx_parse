package stx.parse.core.enumerable.term;

import stx.ds.LinkedList in StxLinkedList;

class LinkedList<T> extends EnumerableCls<StxLinkedList<T>,T>{
  
  override public function is_end(){
    return !this.data.is_defined();
  }
  override public function match(fn){
    return fn(head());
  }
  override public function prepend(v:T):Enumerable<StxLinkedList<T>,T>{
    return new LinkedList(this.data.cons(v),index);
  }
  override public function take(?len:Null<Int>):StxLinkedList<T>{
    return if(len == null){
      this.data;
    }else{
      function go(source:StxLinkedList<T>,i:Int):StxLinkedList<T>{
        return switch([source,i]){
          case [_,0]          : Nil.ds();
          case [Cons(x,xs),_] : go(xs,i--).cons(x);
          case [Nil,_]        : Nil.ds();
          case [null,_]       : Nil.ds();
        }
      }
      go(this.data,len);
    }
  }
  override public function drop(n:Int):Enumerable<StxLinkedList<T>,T>{
    var i = n;
    var x = this.data;
    while(i>0){
      x = switch(x){
        case Cons(x,xs) : xs;
        default         : Nil;
      }
      i = i - 1;
    }
    return new LinkedList(x,index+n);
  }
  override public function head():T{
    return this.data.head();
  }
  public function asEnumerable():Enumerable<StxLinkedList<T>,T>{
    return this;
  }
}