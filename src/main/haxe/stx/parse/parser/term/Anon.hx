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
class Anon<P,R> extends Base<P,R,ParseInput<P> -> ParseResult<P,R>>{

  public function new(delegation: ParseInput<P> -> ParseResult<P,R>,tag:Option<String>,?pos:Pos){
    super(delegation,tag,pos);
  }
  inline public function apply(ipt:ParseInput<P>):ParseResult<P,R>{
    #if debug __.assert().exists(pos); #end
    return this.delegation(ipt);
  }
  override public function toString(){
    return 'Anon($tag)';
  }
}