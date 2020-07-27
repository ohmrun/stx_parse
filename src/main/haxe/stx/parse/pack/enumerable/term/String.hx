package stx.parse.pack.enumerable.term;

import stx.ext.alias.StdString;

class String extends stx.parse.pack.enumerable.term.Base<StdString,StdString>{
	public function new(v, ?i) {
		__.assert().exists(v);
		super(v, i);
	}
	override public function is_end() {
		return !(this.data.length > this.index);
	}
	override public function match(e:StdString->Bool){
		var to_match = this.take();
		//trace('|||${to_match}|||');
		return e(to_match);
	}
	override public function prepend(v:StdString):Enumerable<StdString,StdString> {
		var left 	= this.data.substr(0, index);
		var right = this.data.substr(index);
		
		return new String( this.data = left + v + right , this.index );
	}
	override public function take(?len:Null<Int>):StdString {
		len = len == null ? this.data.length - this.index : len;
		len = len == 0 ? 1 : len;
		var out = data.substr(index, len);
		return out;
	}
	override public function drop(i:Int):Enumerable<StdString,StdString>{
		return new String(this.data,this.index+i);
	}
	override public function head():StdString{
		return this.data.charAt(index);
	}
	public function toString(){
		return 'Enumerable($data)';
	}
}