package com.mindrocks.text.parsers;

class Rep1Sep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  override public function do_parse(ipt:Input<I>){
    return delegation.and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:O,r:Array<O>) -> r.cons(l)
      )
    ).asParser().parse(ipt);
  }
}