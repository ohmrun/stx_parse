package stx.parse.core.enumerable.term;

class Array<T> extends EnumerableCls<StdArray<T>, T > {
	public function new(v,?i) {
		super(v, i);
	}
	public function is_end() {
		return !(this.data.length > this.index); 	
	}
	public function match(e:T->Bool){
		return switch(head()){
			case Val(x) : e(x);
			default 		: false;
		}
	}
	public function prepend(v:T):Enumerable<StdArray<T>,T> {
		var lhs = this.data.slice(0,index);
		var rhs = this.data.slice(index);
		return new Array(lhs.concat(rhs.cons(v)) , this.index);
	}
	public function take(?len:Null<Int>):StdArray<T> {
		len = len == null ? this.data.length - this.index : len;
		return data.prj().slice(this.index, this.index + len);
	}
	public function drop(i:Int):Enumerable<StdArray<T>,T>{
		return new Array(this.data,this.index + i);
	}
	public function head():Chunk<T,ParseFailureCode>{
		return if(index >= this.data.length){
			End(__.fault().of(E_Parse_Eof));
		}else{
			switch(this.data[index]){
				case null : Tap;
				case x 		: Val(x);
			}
		}
	}
} 