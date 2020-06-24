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
      (s:ParseSuccess<I,T>) -> 
        s.with.map(flatmap)
         .map((parser:Parser<I,U>) -> parser.parse(s.rest))
         .defv(ParseFailure.make(s.rest,ParseError.at_with(s.rest,"FAIL",false))),
      Failure
    );
  }
}