package stx.parse.parser.term;

class Option<P,R> extends Base<P,StdOption<R>,Parser<P,R>>{

  public function new(delegation:Parser<P,R>,?pos:Pos){
    super(delegation,pos);
  }
  function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,StdOption<R>>,Noise>):Work{
    return cont.receive(
      delegation.toFletcher().forward(input).map(
        (result:ParseResult<P,R>) -> result.fold(
          (ok) -> ok.map(Some).toParseResult(),
          (no) -> no.is_fatal().if_else(
            () -> ParseResult.failure(no),
            () -> no.rest.ok(None)
          )
        )
      )
    );
  }
  override public function toString(){
    return '$delegation?';
  }
}