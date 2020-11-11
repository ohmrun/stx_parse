package stx.parse.parser.term;

class ErrorTransformer<I,O> extends Base<I,O,Parser<I,O>>{
  var transformer : ParseError -> ParseError;
  public function new(delegation,transformer,?id:Pos){
    super(delegation,id);
    this.transformer = transformer;
  }
  override inline public function defer(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return delegation.defer(
      input,
      cont.joint(joint.bind(_,cont))
    );
  }
  private function joint(outcome:Outcome<ParseResult<I,O>,Defect<Noise>>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return outcome.fold(
      ok -> cont.value(mod(ok)).serve(),
      no -> cont.error(no).serve()
    );
  }
  private function mod(result:ParseResult<I,O>):ParseResult<I,O>{
    return result.fold(
      ParseResult.success,
      (e) -> e.mod(transformer)
    );
  }
  override inline public function apply(input:Input<I>):ParseResult<I,O>{
    return mod(this.apply(input));
  }
}