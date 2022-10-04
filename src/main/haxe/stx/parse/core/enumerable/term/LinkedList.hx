package stx.parse.core.enumerable.term;

import stx.ds.LinkedList in StxLinkedList;

class LinkedList<T> extends EnumerableCls<StxLinkedList<T>,T>{
  
  public function is_end(){
    return !this.data.is_defined();
  }
  public function match(fn){
    return switch(head()){
      case Val(v) : fn(v);
      default     : false;
    }
  }
  public function prepend(v:T):Enumerable<StxLinkedList<T>,T>{
    return new LinkedList(this.data.cons(v),index);
  }
  public function take(?len:Null<Int>):StxLinkedList<T>{
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
  public function drop(n:Int):Enumerable<StxLinkedList<T>,T>{
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
  public function head():Chunk<T,ParseFailureCode>{
    return if(index >= this.data.size()){
      End(__.fault().of(E_Parse_Eof));
    }else{
      Val(this.data.head());
    }
  }
  public function asEnumerable():Enumerable<StxLinkedList<T>,T>{
    return this;
  }
}