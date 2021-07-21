package stx.parse.parser.term;

class LAnon<I,O> extends Base<I,O,Parser<I,O>>{
  var closure : Void -> Parser<I,O>;

  public function new(closure:Void->Parser<I,O>,?id:Pos){
    super(null,id);
    #if test
    __.assert().exists(closure);
    #end
    this.closure = closure;//.fn().cache().prj();
  }
  private function open(){
    this.delegation = closure();
  }
  public inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return if(delegation == null){
      open();
      __.assert().exists(delegation);
      this.delegation.defer(ipt,cont);
    }else{
      this.delegation.defer(ipt,cont);
    }
  } 
}