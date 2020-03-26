package stx.parse.pack.parser.term;

class Anon<I,O> extends Direct<I,O>{

  var method : Input<I> -> ParseResult<I,O>;
  public function new(method,?id){
    super(id);
    this.method = method;
  }
  override function do_parse(ipt:Input<I>){
    __.that(id).exists().errata(e -> e.map( _ -> E_UndefinedParseDelegate(ipt))).crunch(method);
    return this.method(ipt);
  }
}