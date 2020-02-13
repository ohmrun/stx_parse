package com.mindrocks.text.parsers;

class Delegate<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,?id){
    __.that(id).exists().crunch(delegation);
    super(delegation,id);
    this.tag = delegation.tag;
  }
  override function check(){
    __.that(id).exists().crunch(delegation);
  }
  override function do_parse(ipt){
    return this.delegation.parse(ipt);
  }
}