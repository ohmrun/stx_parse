package stx.parse.pack.parser.term;

class AndThen<I,T,U> extends Base<I,U,Parser<I,T>>{
  var flatmap  : T->Parser<I,U>;

  public function new(delegation,flatmap,?id){
    super(delegation,id);
    this.flatmap  = flatmap;
  }
  override function do_parse(input):ParseResult<I,U>{
    __.assert().exists(delegation);
    return delegation.parse(input).fold(
      (s) -> flatmap(s.with).parse(s.rest),
      Failure
    );
  }
}