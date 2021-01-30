package stx.parse.parser.term;

class Materialize<I,O> extends Base<I,O,Parser<I,O>>{
  override public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return delegation.defer(
      ipt,
      cont.joint(
        (outcome:Reaction<ParseResult<I,O>>) -> outcome.map(
          result -> result.is_defined() ? result : ipt.fail('result of $delegation is not defined ')
        )
      )
    );
  }
  public function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    var result = delegation.toInternal().apply(ipt);
    return if(result.is_defined()){
      result;
    }else{
      ipt.fail('result of $delegation is not defined');
    }
  }
}