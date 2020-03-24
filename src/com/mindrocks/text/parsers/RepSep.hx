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
      __.decouple(
        (l:Option<O>,r:Array<O>) -> switch([l,r]){
          case [Some(l),r] : r.cons(l);
          case [None,_]    : [];
        }
      )
    ).asParser().parse(ipt);
  }
}