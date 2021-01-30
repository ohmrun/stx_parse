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
  override public inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return if(delegation == null){
      open();
      __.assert().exists(delegation);
      this.delegation.defer(ipt,cont);
    }else{
      this.delegation.defer(ipt,cont);
    }
  }
  inline function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    return if(delegation == null){
      open();
      this.delegation.apply(ipt);
    }else{
      this.delegation.apply(ipt);
    }
  } 
  override function get_convention(){
    return (this.delegation == null).if_else(
      () -> {
        open();
        this.delegation.convention;
      },
      () -> this.delegation.convention
    );
  }
}