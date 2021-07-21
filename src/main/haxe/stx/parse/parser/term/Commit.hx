package stx.parse.parser.term;

class Commit<I,T> extends Base<I,T,Parser<I,T>>{
  inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
    return cont.receive(
      delegation.toFletcher().forward(ipt).flat_fold(
        (result) -> cont.value(mod(result)),
        (error)  -> cont.error(error) 
      )
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