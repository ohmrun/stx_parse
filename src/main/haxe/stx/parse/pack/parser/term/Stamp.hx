package stx.parse.pack.parser.term;

class Stamp<P,R> extends ParserCls<P,R>{
  public var value(default,null):ParseResult<P,R>;
  public function new(value,?pos:Pos){
    super(pos);
    this.value = value;
  }
  override inline public function defer(input:Input<P>,cont:Terminal<ParseResult<P,R>,Noise>):Work{
    return cont.value(value).serve();
  }
  override inline public function apply(input:Input<P>):ParseResult<P,R>{
    return value;
  }
}