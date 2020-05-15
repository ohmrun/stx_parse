package stx.parse.pack.enumerable.term;


class Array<T> extends stx.parse.pack.enumerable.term.Base<StdArray<T>, T > {
	public function new(v,?i) {
		super(v, i);
	}
	override public function is_end() {
		return !(this.data.length > this.index); 	
	}
	override public function match(e:T->Bool){
		return e(head());
	}
	override public function prepend(v:T):Enumerable<StdArray<T>,T> {
		return new Array( this.data.cons(v) , this.index );
	}
	override public function take(?len:Null<Int>):StdArray<T> {
		len = len == null ? this.data.length - this.index : len;
		return data.prj().slice(this.index, this.index + len);
	}
	override public function drop(i:Int):Enumerable<StdArray<T>,T>{
		return new Array(this.data,this.index + i);
	}
	override public function head():T{
		return this.data[index];
	}
} 