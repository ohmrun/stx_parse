package stx.parse.parser.term;

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
    __.that(pos).exists().errata( e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  override public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    var arr     = [];
    return delegation.toFletcher().receive(input).flat_fold(
      oc -> oc.fold(
        res  -> res.fold(
          ok -> {
            arr.push(ok.with);
            return this.toFletcher().receive(input);
          },
          no -> {
            if(no.is_fatal()){
              return input.no.toParseResult();
            }else{
                  
            }
          }
        ),
        no   -> cont.error(no)
      )
    );
  }
}