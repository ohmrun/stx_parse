package stx.parse.parser.term;

class Materialize<I,O> extends Base<I,O,Parser<I,O>>{
  public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.receive(delegation.toFletcher().forward(ipt).map(
      result -> result.is_defined() ? 
        result : 
        result.asset.erration('result of $delegation is not defined ').failure(result.asset)
    ));
  }
}