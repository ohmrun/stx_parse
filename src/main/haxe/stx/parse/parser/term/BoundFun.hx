package stx.parse.parser.term;

abstract class BoundFun<I,O,Oi> extends ParserCls<I,Oi>{
  var parser : Parser<I,O>;

  public function new(parser:Parser<I,O>,?pos:Pos){
    super(pos);
    this.parser = parser;
  }
  abstract private function bound(input:Input<I>,result:ParseResult<I,O>):ParseResult<I,Oi>;

  override public inline function defer(i:Input<I>,cont:Terminal<ParseResult<I,Oi>,Noise>):Work{
    return @:privateAccess Arrowlet.ThenFun(parser.toArrowlet(),bound.bind(i)).toInternal().defer(i,cont);
  }
  override public function apply(input:Input<I>):ParseResult<I,Oi>{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> bound(input,parser.toInternal().apply(input))
    );
  }
  
  override public function get_convention(){
    return this.parser.toInternal().convention;
  }

  
}