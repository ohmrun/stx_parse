package stx.parse.parser.term;

abstract class BoundFun<I,O,Oi> extends ParserCls<I,Oi>{
  var parser : Parser<I,O>;

  public function new(parser:Parser<I,O>,?pos:Pos){
    super(pos);
    this.parser = parser;
  }
  abstract private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,Oi>;

  public function apply(i:ParseInput<I>):ParseResult<I,Oi>{
    return bound(i,parser.apply(i));
  }
  override public function toString(){
    var a = this.identifier().name;
    var b = parser.toString();
    return '$a($b)';
  }  
}