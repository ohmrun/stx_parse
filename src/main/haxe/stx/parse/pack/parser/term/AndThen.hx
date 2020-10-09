package stx.parse.pack.parser.term;

class AndThen<I,T,U> extends Base<I,U,Parser<I,T>>{
  var flatmap  : T->Parser<I,U>;

  public function new(delegation,flatmap,?id){
    super(delegation,id);
    this.flatmap  = flatmap;
  }
  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,U>,Noise>):Work{
    __.assert().exists(delegation);
    return Arrowlet.Then(
      delegation,
      Arrowlet.Anon(
        (res:ParseResult<I,T>,cont:Terminal<ParseResult<I,U>,Noise>) -> res.fold(
          (ok:ParseSuccess<I,T>) -> 
            ok.with.map(flatmap)
              .map((parser:Parser<I,U>) -> parser.forward(ok.rest))
              .defv(
                Provide.pure(
                 ParseFailure.make(ok.rest,ParseError.at_with(ok.rest,"FAIL",false)).toParseResult()
                ) 
              ) 
             .prepare(cont),
          (no) -> cont.value(__.failure(no.tack(input))).serve()
        )
      )
    ).applyII(input,cont);
  }
}