package stx.parse.pack.parser.term;

class SyncAnon<P,R> extends Sync<P,R>{

  var method : Input<P> -> ParseResult<P,R>;
  public function new(method,?tag:String,?id:Pos){
    super(id);
    this.tag    = __.option(tag);
    this.method = method;
  }
  override function do_parse(ipt:Input<P>){
    __.that(id).exists().errata(e -> e.map( _ -> E_UndefinedParseDelegate(ipt))).crunch(method);
    return method(ipt);
  }
}