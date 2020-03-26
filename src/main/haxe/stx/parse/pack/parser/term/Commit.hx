package stx.parse.pack.parser.term;

class Commit<I,T> extends Delegate<I,T>{
  public function new(delegation,?id){
    super(delegation,id);
  }
  override function do_parse(ipt){
    return delegation.parse(ipt).fold(
      Success,
      (err) -> (!err.is_fatal() || err.is_parse_fail()).if_else(
        () -> err,
        () -> err.next(ParseError.at_with(err.rest,'Cannot Commit',true))
      )
    );
  }
}