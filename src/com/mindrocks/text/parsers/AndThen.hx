package com.mindrocks.text.parsers;

class AndThen<I,T,U> extends Base<I,U,Parser<I,T>>{
  var flatmap  : T->Parser<I,U>;

  public function new(delegation,flatmap,?id){
    super(delegation,id);
    this.flatmap  = flatmap;
  }
  override function do_parse(input):ParseResult<I,U>{
    if(delegation == null){  throw('undefined parse delegate'); }
    return switch (delegation.parse(input)) {
      case Success(m, r): flatmap(m).parse(r);
      case def          : def.elide();
    }
  }
}