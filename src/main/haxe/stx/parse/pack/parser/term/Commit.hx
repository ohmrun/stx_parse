package stx.parse.pack.parser.term;

class Commit<I,T> extends Delegate<I,T>{
  public function new(delegation,?id){
    super(delegation,id);
  }
  override function applyII(ipt:Input<I>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
    return delegation.forward(ipt).process(
      (res:ParseResult<I,T>) -> res.fold(
        ok    -> ParseResult.success(ok),
        (err) -> ParseResult.failure((!err.is_fatal() || err.is_parse_fail()).if_else(
          () -> err,
          () -> err.next(ParseError.at_with(err.rest,'Cannot Commit',true))
        ))
      )
    ).prepare(cont);
  }
}