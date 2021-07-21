package stx.parse.parser.term;

class Failed<P,R> extends Sync<P,R>{
  var msg       : String;
  var is_fatal  : Bool;

  public function new(msg,is_fatal = false,?id:Pos){
    super(id);
    this.msg        = msg;
    this.is_fatal   = is_fatal;
  }
  inline function apply(ipt:ParseInput<P>):ParseResult<P,R>{
    return ipt.fail(msg,is_fatal,pos);
  }
}