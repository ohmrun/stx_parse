package stx.parse.parser.term;

class Something<I> extends Sync<I,I>{
  inline public function apply(input:ParseInput<I>):ParseResult<I,I>{
    return if(input.is_end()){
      input.fail('EOF');
    }else{
      input.head().fold(
        v 	-> input.tail().ok(v),
        () 	-> input.tail().fail('Something')
      );
    }
  }
  override public function toString(){
    return "()";
  }
}