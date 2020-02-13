package com.mindrocks.text;

class StringEnumerable extends Enumerable<String,String>{
	public function new(v, ?i) {
		super(v, i);
	}
	override public function isEnd() {
		return !(this.data.length > this.index);
	}
	override public function match(e:String->Bool){
		var to_match = this.take();
		//trace('|||${to_match}|||');
		return e(to_match);
	}
	override public function prepend(v:String):Enumerable<String,String> {
		var left 	= this.data.substr(0, index);
		var right = this.data.substr(index);
		
		return new StringEnumerable( this.data = left + v + right , this.index );
	}
	override public function take(?len:Null<Int>):String {
		len = len == null ? this.data.length - this.index : len;
		len = len == 0 ? 1 : len;
		var out = data.substr(index, len);
		return out;
	}
	override public function drop(i:Int):Enumerable<String,String>{
		return new StringEnumerable(this.data,this.index+i);
	}
	override public function head():String{
		return this.data.charAt(index);
	}
}