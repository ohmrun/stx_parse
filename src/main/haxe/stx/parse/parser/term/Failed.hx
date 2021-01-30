package stx.parse.parser.term;

class Failed<P,R> extends Sync<P,R>{
  var msg       : String;
  var is_error  : Bool;

  public function new(msg,is_error = false,?id:Pos){
    super(id);
    this.msg        = msg;
    this.is_error   = is_error;
  }
  inline function apply(ipt:ParseInput<P>):ParseResult<P,R>{
    return ipt.fail(msg,is_error,pos);
  }
}