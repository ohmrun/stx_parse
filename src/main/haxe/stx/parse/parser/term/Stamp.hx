package stx.parse.parser.term;

class Stamp<P,R> extends ParserCls<P,R>{
  public var value(default,null):ParseResult<P,R>;
  public function new(value,?pos:Pos){
    super(pos);
    this.value = value;
  }
  inline public function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,R>,Noise>):Work{
    return cont.receive(cont.value(value));
  }
  inline public function apply(input:ParseInput<P>):ParseResult<P,R>{
    return value;
  }
  override public function toString(){
    return 'Stamp($value)';
  }
}