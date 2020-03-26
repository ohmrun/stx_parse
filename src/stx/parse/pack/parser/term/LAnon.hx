package stx.parse.pack.parser.term;

class LAnon<I,O> extends Anon<I,O>{
  var closure : Void -> Parser<I,O>;
  public function new(closure:Void->Parser<I,O>,?id){
    super(id);
    __.assert().exists(closure);
    this.closure = closure.fn().cache().prj();
  }
  override function do_parse(ipt:Input<I>){
    return if(method == null){
      this.method = __.option(closure()).map(_ -> _.parse).fudge();
      __.that().exists().errata( e -> e.fault().of(E_UndefinedParseDelegate(ipt))).crunch(method);
      this.method(ipt);
    }else{
      this.method(ipt);
    }
  }
}