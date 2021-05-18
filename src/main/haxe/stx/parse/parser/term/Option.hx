package stx.parse.parser.term;


class Option<I,T> extends Base<I,StdOption<T>,Parser<I,T>>{
  public function new(delegation:Parser<I,T>,?pos:Pos){
    super(delegation,pos);
  }
  override function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,StdOption<T>>,Noise>):Work{
    return cont.receive(delegation.toFletcher().receive(input).fold_map(
      (result:ParseResult<I,T>) -> __.success(result.fold(
        ok -> ParseSuccess.make(
          ok.rest,
          __.option(ok.with)
        ).toParseResult(),
        no -> no.is_fatal() ? no : no.rest.ok(None)
      )),          
      e -> __.failure(e)
    ));
  }
  override public function toString(){
    return '$delegation?';
  }
}