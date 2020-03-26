package stx.parse.pack.parser.term;

class Many<I,O> extends Base<I,stx.core.pack.Array<O>,Parser<I,O>>{
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
  override function do_parse(input:Input<I>):ParseResult<I,Array<O>>{
    var arr     = [];
    var n_input = input;

    while (true) {
      var res : ParseResult<I,O> = delegation.parse(n_input);
      switch (res) {
        case Success(m): 
          arr.push(m.with); 
          n_input = m.rest;
        case Failure(e) if( e.is_fatal() == true) : 
          return e;
        default :
          break;
      }
    }
    //trace(arr);
    return n_input.ok(arr);
  }

}