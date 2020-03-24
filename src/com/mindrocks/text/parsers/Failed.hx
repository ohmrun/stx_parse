package com.mindrocks.text.parsers;

class Failed<I,O> extends Direct<I,O>{
  var msg     : String;
  var isError : Bool;

  public function new(msg,isError = false,?id){
    super(id);
    this.msg      = msg;
    this.isError  = isError;
  }
  override function do_parse(ipt){
    return failed(msg.errorAt(ipt).newStack(), ipt, isError);
  }
}