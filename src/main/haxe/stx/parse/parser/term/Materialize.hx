package stx.parse.parser.term;

class Materialize<I,O> extends Base<I,O,Parser<I,O>>{
  override public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.receive(delegation.toFletcher().receive(ipt).map(
      result -> result.is_defined() ? result : ipt.fail('result of $delegation is not defined ')
    ));
  }
}