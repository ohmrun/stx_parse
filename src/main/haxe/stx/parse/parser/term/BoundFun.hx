package stx.parse.parser.term;

abstract class BoundFun<I,O,Oi> extends ParserCls<I,Oi>{
  var parser : Parser<I,O>;

  public function new(parser:Parser<I,O>,?pos:Pos){
    super(pos);
    this.parser = parser;
  }
  abstract private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,Oi>;

  public function defer(i:ParseInput<I>,cont:Terminal<ParseResult<I,Oi>,Noise>):Work{
    return cont.receive(parser.toFletcher().forward(i).map(
      result  -> bound(i,result)
    ));
  }
  override public function toString(){
    var a = this.name();
    var b = parser.toString();
    return '$a($b)';
  }  
}