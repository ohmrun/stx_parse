package stx.parse.parser.term;

class SyncAnon<P,R> extends SyncBase<P,R,Input<P> -> ParseResult<P,R>>{

  public function new(method:Input<P> -> ParseResult<P,R>,?id:Pos){
    super(method,id);
  }
  override inline public function apply(ipt:Input<P>):ParseResult<P,R>{
    #if test
    __.assert().exists(id);
    #end
    return delegation(ipt);
  }
}