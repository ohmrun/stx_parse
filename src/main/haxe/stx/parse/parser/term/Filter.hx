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
  public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.defer(ipt,cont);
  }
}