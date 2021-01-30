package stx.parse.parser.term;

class Lookahead<P,R> extends Mod<P,R>{
  public function bound(input:ParseInput<P>,result:ParseResult<P,R>):ParseResult<P,R>{
    return result.fold(
      (ok) 	-> input.nil(),
      (no)	-> ParseResult.failure(no)
    );
  }
  override public function toString(){
    return 'Lookahead($delegate)';
  }
}