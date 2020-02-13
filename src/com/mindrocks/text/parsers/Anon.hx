package com.mindrocks.text.parsers;

class Anon<I,O> extends Direct<I,O>{

  var method : Input<I> -> ParseResult<I,O>;
  public function new(method,?id){
    super(id);
    this.method = method;
  }
  override function do_parse(ipt:Input<I>){
    __.that(id).exists().errata(e -> e.map( _ -> UndefinedParseDelegate(ipt))).crunch(method);
    return this.method(ipt);
  }
}