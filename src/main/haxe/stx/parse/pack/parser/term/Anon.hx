package stx.parse.pack.parser.term;

class Anon<P,R> extends Direct<P,R>{

  var method : Input<P> -> ParseResult<P,R>;
  public function new(method,?id){
    super(id);
    this.method = method;
  }
  override function do_parse(ipt:Input<P>){
    __.that(id).exists().errata(e -> e.map( _ -> E_UndefinedParseDelegate(ipt))).crunch(method);
    return this.method(ipt);
  }
}