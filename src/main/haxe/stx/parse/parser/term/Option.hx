package stx.parse.parser.term;

class Option<P,R> extends Base<P,StdOption<R>,Parser<P,R>>{

  public function new(delegation:Parser<P,R>,?pos:Pos){
    super(delegation,pos);
  }
  function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,StdOption<R>>,Noise>):Work{
    return cont.receive(
      delegation.toFletcher().forward(input).map(
        (result:ParseResult<P,R>) -> result.has_error().if_else(
          () -> result.is_fatal().if_else(
            () -> result.map(Some),
            () -> input.ok(None)
          ),
          () -> result.map(Some)
        )
      )
    );
  }
  override public function toString(){
    return '$delegation?';
  }
}