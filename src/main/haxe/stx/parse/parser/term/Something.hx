package stx.parse.parser.term;

class Something<I> extends Sync<I,I>{
  inline public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return if(input.is_end()){
      input.erration('EOF').failure(input);
    }else{
      input.head().fold(
        v 	-> input.tail().ok(v),
        () 	-> input.tail().erration('Something').failure(input)
      );
    }
  }
  override public function toString(){
    return "()";
  }
}