package stx.parse.parser.term;

class Something<I> extends Sync<I,I>{
  inline public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return if(input.is_end()){
      input.erration('EOF').failure(input);
    }else{
      __.log().trace('${input.head().def(null)}');
      input.head().fold(
        v 	-> input.tail().ok(v),
        e 	-> e.toParseFailure_with(input).failure(input),
        () 	-> input.tail().erration('Something').failure(input)
      );
    }
  }
  override public function toString(){
    return "*";
  }
}