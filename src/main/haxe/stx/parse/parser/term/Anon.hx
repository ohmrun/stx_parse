package stx.parse.parser.term;

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

  var method : ParseInput<P> -> Terminal<ParseResult<P,R>,Noise> -> Work;
  
  public function new(method: ParseInput<P> -> Terminal<ParseResult<P,R>,Noise> -> Work,tag:Option<String>,?pos:Pos){
    super(tag,pos);
    this.method = method;
  }
  override inline public function defer(ipt:ParseInput<P>,cont:Terminal<ParseResult<P,R>,Noise>){
    #if test
    __.assert().exists(id);
    #end
    return this.method(ipt,cont);
  }
  override public function toString(){
    return 'Anon($tag)';
  }
}