package stx.parse.pack;

import stx.parse.pack.enumerable.term.Array;
import stx.parse.pack.enumerable.term.String;
import stx.parse.pack.enumerable.term.LinkedList;

interface EnumerableApi<C,T>{
	
	public var data(default,null) 	: C;
	public var index(default,null) 	: Int;

	public function head():T;
	public function take(?len : Null<Int>):C;

	public function drop(n:Int):Enumerable<C,T>;

	
	public function match(fn:T -> Bool):Bool;
	public function prepend(v:T):Enumerable<C,T>;
	
	public function is_end():Bool;
} 

@:forward abstract Enumerable<C,T>(EnumerableApi<C,T>) from EnumerableApi<C,T> to EnumerableApi<C,T>{
  public function new(self) this = self;
  static public function lift<C,T>(self:EnumerableApi<C,T>):Enumerable<C,T> return new Enumerable(self);
  
	@:noUsing static public function array<T>(array:std.Array<T>):Enumerable<std.Array<T>,T>{
		return new Array(array);
	}
	@:noUsing static public function string(string:std.String):Enumerable<std.String,std.String>{
		return new String(string);
	}
	@:noUsing static public function linked_list<T>(list:stx.ds.LinkedList<T>):Enumerable<stx.ds.LinkedList<T>,T>{
		return new LinkedList(list);
	}
  

  public function prj():EnumerableApi<C,T> return this;
  private var self(get,never):Enumerable<C,T>;
  private function get_self():Enumerable<C,T> return lift(this);
}