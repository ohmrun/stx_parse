package stx.parse.pack.parser.term;

class LAnon<I,O> extends Anon<I,O>{
  var closure : Void -> Parser<I,O>;
  public function new(closure:Void->Parser<I,O>,?id){
    super(id);
    __.assert().exists(closure);
    this.closure = closure.fn().cache().prj();
  }
  override private function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    return if(method == null){
      var delegate = __.option(closure()).fudge();
      //this.id       = delegate.id;
      //this.tag      = delegate.tag;
      this.method     = delegate.applyII;
      __.that().exists().errata( e -> e.fault().of(E_UndefinedParseDelegate(ipt))).crunch(method);
      this.method(ipt,cont);
    }else{
      this.method(ipt,cont);
    }
  }
}