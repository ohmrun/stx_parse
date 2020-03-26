package com.mindrocks.text;

class ArrayEnumerable<T> extends Enumerable < Array<T>, T > {
	public function new(v,?i) {
		super(v, i);
	}
	override public function isEnd() {
		return !(this.data.length > this.index); 	
	}
	override public function match(e:T->Bool){
		return e(head());
	}
	override public function prepend(v:T):Enumerable<Array<T>,T> {
		return new ArrayEnumerable( this.data.cons(v) , this.index );
	}
	override public function take(?len:Null<Int>):Array<T> {
		len = len == null ? this.data.length - this.index : len;
		return data.prj().slice(this.index, this.index + len);
	}
	override public function drop(i:Int):Enumerable<Array<T>,T>{
		return new ArrayEnumerable(this.data,this.index + i);
	}
	override public function head():T{
		return this.data[index];
	}
} 