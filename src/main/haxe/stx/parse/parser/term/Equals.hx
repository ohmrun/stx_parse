package stx.parse.parser.term;

class Equals<I> extends ParserCls<I,I>{
  final value : I;
  public function new(value,?tag,?pos){
    super(tag,pos);
    this.value = value;
  }
  public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return input.head().fold(
      (vI) 	-> value == vI ? input.tail().ok(vI) : input.erration('eq').failure(input),
      (e) 	-> e.toParseFailure_with(input,false).failure(input),
      () 		-> input.erration(E_Parse_ParseFailed('eq')).failure(input)
    );
  }
}