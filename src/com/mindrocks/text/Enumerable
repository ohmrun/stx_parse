package com.mindrocks.text;

class Enumerable<C,T>{
	
	public var data 	: C;
	public var index 	: Int;

	public function new(data,?index = 0) {
		this.data 	= data;
		this.index 	= index;
	}
	public function isEnd(){
		throw "abstract function";
		return true;
	}
	public function match(fn:T -> Bool):Bool{
		throw "abstract function";
		return false;
	}
	public function prepend(v:T):Enumerable<C,T> {
		throw "abstract function";
		return null;
	}
	public function head():T{
		throw "abstract function";
		return null;
	}
	public function drop(n:Int):Enumerable<C,T>{
		throw "abstract function";
		return null;
	}
	public function take(?len : Null<Int>) : C {
		throw "abstract function";
		return null;
  }
} 