package stx.parse.parser.term;


class Option<I,T> extends Base<I,StdOption<T>,Parser<I,T>>{
  public function new(delegation:Parser<I,T>,?pos:Pos){
    super(delegation,pos);
  }
  override function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,StdOption<T>>,Noise>):Work{
    return delegation.defer(
      input,
      cont.joint(
        (outcome:Reaction<ParseResult<I,T>>) -> {
          return cont.issue(
            outcome.map(
              (result:ParseResult<I,T>) -> result.fold(
                ok -> ParseSuccess.make(
                  ok.rest,
                  __.option(ok.with)
                ).toParseResult(),
                no -> no.is_fatal() ? no : no.rest.ok(None)
              )
            )
          ).serve();
        }
      )
    );
  }
  public function apply(input:ParseInput<I>):ParseResult<I,StdOption<T>>{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function get_convention(){
    return this.delegation.convention;
  }
  override public function toString(){
    return '$delegation?';
  }
}