package stx.parse.parser.term;

abstract class BoundFun<I,O,Oi> extends ParserCls<I,Oi>{
  var parser : Parser<I,O>;

  public function new(parser:Parser<I,O>,?pos:Pos){
    super(pos);
    this.parser = parser;
  }
  abstract private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,Oi>;

  override public function defer(i:ParseInput<I>,cont:Terminal<ParseResult<I,Oi>,Noise>):Work{
    return @:privateAccess Arrowlet.ThenFun(parser.toArrowlet(),bound.bind(i)).toInternal().defer(i,cont);
  }
  override public function apply(input:ParseInput<I>):ParseResult<I,Oi>{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> bound(input,parser.toInternal().apply(input))
    );
  }
  
  override public function get_convention(){
    return this.parser.toInternal().convention;
  }
  override public function toString(){
    return parser.toString();
  }  
}