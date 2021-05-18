package stx.parse.parser.term;

class ErrorTransformer<I,O> extends Base<I,O,Parser<I,O>>{
  var transformer : ParseError -> ParseError;
  public function new(delegation,transformer,?pos:Pos){
    super(delegation,pos);
    this.transformer = transformer;
  }
  override inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.receive(delegation.toFletcher().then(
      Fletcher.Sync(mod)
    ).receive(input));
  }
  private function mod(result:ParseResult<I,O>):ParseResult<I,O>{
    return result.fold(
      ParseResult.success,
      (e) -> e.errata(transformer)
    );
  }
  inline public function apply(input:ParseInput<I>):ParseResult<I,O>{
    return mod(this.apply(input));
  }
  override public function toString(){
    return this.delegation.toString();
  }
}