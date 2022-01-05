package stx.parse.parser.term;

class Pure<I,O> extends SyncBase<I,O,Noise>{
  var value : ParseResult<I,O>;
  public function new(value,?pos){
    this.value = value;
    super(pos);
  }
  inline public function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    return value;
  }
}