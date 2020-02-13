package com.mindrocks.text.parsers;

class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  var transform : T -> U;
  public function new(delegation:Parser<I,T>,transform:T->U,?id){
    super(delegation,id);
    __.that(id).exists().crunch(delegation);
    this.transform  = transform; 
    this.tag        = delegation.tag;
  }
  override public function check(){
    __.that(id).exists().errata(e -> e.fault().of(UndefinedParseDelegate())).crunch(delegation);
  }
  override function do_parse(input:Input<I>):ParseResult<I,U>{
    return switch(delegation.parse(input)){
      case Success(m, r)    :  Success(transform(m), r);
      case x                :  x.elide();
    };
  }

}