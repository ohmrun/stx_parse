package com.mindrocks.text.parsers;

class Succeed<I,O> extends Direct<I,O>{
  var value : O;
  public function new(value:O){
    super();
    this.value = value;
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return succeed(this.value,ipt); 
  }
}