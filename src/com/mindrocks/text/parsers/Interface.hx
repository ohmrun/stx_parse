package com.mindrocks.text.parsers;


@:allow(com.mindrocks)interface Interface<I,O>{
  public var tag                            : Option<String>;
  public var id(default,null)               : Pos;
  
  public var uid(default,null)              :Int;
  public function parse(ipt:Input<I>)       :ParseResult<I,O>;
  
  public function name():String;
}