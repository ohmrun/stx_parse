package com.mindrocks.text.parsers;


class RepSep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  override public function do_parse(ipt:Input<I>){
    return delegation.option().and(
      sep._and(delegation).many()
    ).then(
      (t:Tuple2<Option<O>,Array<O>>) -> switch(t){
        case tuple2(Some(l),r) : r.cons(l);
        case tuple2(None,_)    : [].ds();
      }
    ).asParser().parse(ipt);
  }
}