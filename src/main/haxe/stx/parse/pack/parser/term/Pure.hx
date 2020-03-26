package stx.parse.pack.parser.term;

class Pure<I,O> extends Base<I,O,Parser<I,O>>{
  var value : ParseResult<I,O>;
  public function new(value,?pos){
    this.value = value;
    super(pos);
  }
  override public function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return value;
  }
  
}