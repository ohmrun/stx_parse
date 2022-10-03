package stx.parse.parser.term;

import stx.parse.Parsers.*;

class Filter<I,O> extends Base<I,O,Parser<I,O>>{
  var predicate : O -> Bool;
  public function new(delegation:Parser<I,O>,predicate:O->Bool,?id:Pos){
    super(delegation,id);
    this.predicate = predicate;
    super(
      AndThen(delegation,(o:O) -> this.predicate(o) ? Succeed(o) : Failed("predicate failed") )
      ,id
    );
  }
  public function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    return this.apply(ipt);
  }
}