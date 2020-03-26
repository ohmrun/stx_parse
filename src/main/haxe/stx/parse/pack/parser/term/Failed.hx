package stx.parse.pack.parser.term;

class Failed<P,R> extends Direct<P,R>{
  var msg       : String;
  var is_error  : Bool;

  public function new(msg,is_error = false,?id){
    super(id);
    this.msg        = msg;
    this.is_error   = is_error;
  }
  override function do_parse(ipt:Input<P>):ParseResult<P,R>{
    return ipt.fail(msg,is_error,id);
  }
}