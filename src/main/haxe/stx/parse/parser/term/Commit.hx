package stx.parse.parser.term;

class Commit<I,T> extends Base<I,T,Parser<I,T>>{
  override inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
    return delegation.defer(
      ipt,
      cont.joint(joint.bind(_,cont))
    );
  }
  override inline function apply(input:ParseInput<I>){
    return mod(delegation.apply(input));
  }
  private function joint(outcome:Outcome<ParseResult<I,T>,Defect<Noise>>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
    return outcome.fold(
      (result) -> cont.value(mod(result)).serve(),
      (error)  -> cont.error(error).serve()
    );
  }
  private function mod(result:ParseResult<I,T>){
    return result.fold(
      ParseResult.success,
      (err) -> ParseResult.failure((!err.is_fatal() || err.is_parse_fail()).if_else(
        () -> err,
        () -> err.next(ParseError.at_with(err.rest,'Cannot Commit',true))
      ))
    );
  }
}