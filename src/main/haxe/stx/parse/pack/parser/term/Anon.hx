package stx.parse.pack.parser.term;

/*
  Here be monsters.

  function builder(...){
    return Parser.Anon(
      ...
    );
  }
  var a = builder(...);
  var b = builder(...);
  Memo(a) == Memo(b)//true
*/
class Anon<P,R> extends Direct<P,R>{

  var method : Input<P> -> Terminal<ParseResult<P,R>,Noise> -> Work;
  
  public function new(method: Input<P> -> Terminal<ParseResult<P,R>,Noise> -> Work,?id:Pos){
    super(id);
    this.method = method;
  }
  override function doApplyII(ipt:Input<P>,cont:Terminal<ParseResult<P,R>,Noise>){
    __.that(id).exists().errata(e -> e.map( _ -> E_UndefinedParseDelegate(ipt))).crunch(method);
    return this.method(ipt,cont);
  }
}