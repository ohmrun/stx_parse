package stx.parse.core.enumerable.term;

import String in StdString;

class String extends EnumerableCls<StdString,StdString>{
	public function new(v, ?i) {
		__.assert().exists(v);
		super(v, i);
	}
	public function is_end() {
		return !(this.data.length > this.index);
	}
	public function match(e:StdString->Bool){
		var to_match = this.take();
		__.log().trace(_ -> _.thunk(() -> 'match |<[${to_match}]>| is_end? ${is_end()}'));
		return e(to_match);
	}
	public function prepend(v:StdString):Enumerable<StdString,StdString> {
		var left 	= this.data.substr(0, index);
		var right = this.data.substr(index);
		
		return new String( this.data = left + v + right , this.index );
	}
	public function take(?len:Null<Int>):StdString {
		len = len == null ? this.data.length - this.index : len;
		len = len == 0 ? 1 : len;
		var out = data.substr(index, len);
		return out;
	}
	public function drop(i:Int):Enumerable<StdString,StdString>{
		return new String(this.data,this.index+i);
	}
	public function head():Chunk<StdString,ParseFailureCode>{
		return if(index >= this.data.length){
			End(__.fault().of(E_Parse_Eof));
		}else{
			Val(this.data.charAt(index));
		}
	}
	public function toString(){
		return 'Enumerable($data)';
	}
}