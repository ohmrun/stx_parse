package stx.parse.parser.term;

class SyncAnon<P,R> extends SyncBase<P,R,ParseInput<P> -> ParseResult<P,R>>{

  public function new(method:ParseInput<P> -> ParseResult<P,R>,tag:Option<String>,?pos:Pos){
    super(method,tag,pos);
  }
  inline public function apply(ipt:ParseInput<P>):ParseResult<P,R>{
    #if test
    __.assert().exists(id);
    #end
    var result = delegation(ipt);
    //trace('$this $result');
    return result;
  }
  override public function toString(){
    return 'SyncAnon($tag)';
  }
}