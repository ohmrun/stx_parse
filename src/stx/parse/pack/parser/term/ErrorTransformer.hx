package stx.parse.pack.parser.term;

class ErrorTransformer<I,O> extends Delegate<I,O>{
  var transformer : ParseError -> ParseError;
  public function new(delegation,transformer,?id){
    super(delegation,id);
    this.transformer = transformer;
  }
  override function do_parse(ipt){
    return delegation.parse(ipt).fold(
      Success,
      (e) -> e.mod(transformer)
    );
  }
}