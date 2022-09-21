package stx.parse.term.site;

class Something<I:{ site : Site }> extends Sync<String,String>{
  inline public function apply(input:ParseInput<String>):ParseResult<String,String>{
    return if(input.is_end()){
      input.erration('EOF').failure(input);
    }else{
      __.log().trace('${input.head().def(null)}');
      input.head().fold(
        v 	-> input.tail().ok(v),
        () 	-> input.tail().erration('Something').failure(input)
      );
    }
  }
  override public function toString(){
    return "*";
  }
}