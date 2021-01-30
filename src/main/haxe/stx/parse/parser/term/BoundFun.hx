package stx.parse.parser.term;

abstract class BoundFun<I,O,Oi> extends ParserCls<I,Oi>{
  var parser : Parser<I,O>;

  public function new(parser:Parser<I,O>,?pos:Pos){
    super(pos);
    this.parser = parser;
  }
  abstract private function bound(input:ParseInput<I>,result:ParseResult<I,O>):ParseResult<I,Oi>;

  public function defer(i:ParseInput<I>,cont:Terminal<ParseResult<I,Oi>,Noise>):Work{
    return parser.defer(
      i,
      cont.joint(
        (outcome) -> outcome.fold(
          result  -> cont.value(bound(i,result)).serve(),
          error   -> cont.error(error).serve()
        )
      )
    );
  }
  public function apply(input:ParseInput<I>):ParseResult<I,Oi>{
    return bound(input,parser.toInternal().apply(input));
  }
  
  override public function get_convention(){
    return this.parser.toInternal().convention;
  }
  override public function toString(){
    var a = this.name();
    var b = parser.toString();
    return '$a($b)';
  }  
}