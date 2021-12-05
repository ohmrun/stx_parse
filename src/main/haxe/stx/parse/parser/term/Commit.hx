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
    return result.is_ok().if_else(
      () -> result,
      //|| result.is_parse_fail()?
      () -> (!result.is_fatal()).if_else(
        () -> result,
        () -> ParseResult.lift(
          result.errata(
            err -> err.concat(ParseError.make(@:privateAccess result.asset.content.index,'Cannot Commit',true).toError())
          )
        )
      )
    );
  }
}