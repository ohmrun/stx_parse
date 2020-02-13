package com.mindrocks.text.parsers;

class Inspect<I,O> extends Delegate<I,O>{
  var prefix  : Input<I> -> Void;
  var postfix : ParseResult<I,O> -> Void;
  public function new(delegation,prefix,postfix,?id){
    this.prefix   = prefix;
    this.postfix  = postfix;
    super(delegation,id);
  }
  override function do_parse(ipt){
    this.prefix(ipt);
    var out = this.delegation.parse(ipt);
    this.postfix(out);
    return out;
  }
}