package com.mindrocks.text.parsers;

class Predicate<I,O> extends Delegate<I,O>{
  var predicate :  O -> Bool;
  public function new(delegation,predicate,?id){
    this.predicate = predicate;
    __.that(id).exists().errata( e -> e.fault().of(UndefinedParseDelegate())).crunch(delegation);
    super(
      new AndThen(delegation,(o:O) -> this.predicate(o) ? o.success() : "predicate failed".fail(false))
      ,id
    );
    
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return delegate.parse(ipt);
  }
}