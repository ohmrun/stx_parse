package stx.parse.pack.parser.term;

class Many<I,O> extends Base<I,Array<O>,Parser<I,O>>{
  public function new(delegation:Parser<I,O>,?id:Pos){
    __.that(id).exists().errata( e -> e.fault().of(E_UndefinedParserInConstructor(this))).crunch(delegation);
    super(delegation,id);
    this.tag = switch (delegation.tag){
      case Some(v)  : Some('($v)*');
      default       : None;
    }
  }
  override public function check(){
    __.that(id).exists().errata( e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    var arr     = [];

    return  Arrowlet._.then(
      delegation,
      Arrowlet.Anon(
        function rec(i:ParseResult<I,O>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
          return i.fold(
            (ok) -> {
              for (v in ok.with){
                arr.push(v);
              }
              return Arrowlet.Then(delegation,Arrowlet.Anon(rec)).applyII(ok.rest,cont);
            },
            (no) -> cont.value(no.is_fatal() ? no.toParseResult() : input.ok(arr)).serve()
          );
        }
      )
    ).applyII(input,cont);
  }
}