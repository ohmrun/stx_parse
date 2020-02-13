package com.mindrocks.text.parsers;

class OptionP<I,T> extends Base<I,Option<T>,Parser<I,T>>{
  public function new(delegation:Parser<I,T>,?id){
    super(delegation,id);
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,Option<T>>{
    if(delegation == null){  throw('undefined parse delegate'); }
    return delegation
      .then(Some)
      .or(None.success())
      .parse(ipt);
  }
}