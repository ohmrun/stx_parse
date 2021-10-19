package stx.parse.parser.term;

class Lookahead<P,R> extends Mod<P,R>{
  public function bound(input:ParseInput<P>,result:ParseResult<P,R>):ParseResult<P,R>{
    return result.is_ok().if_else(
      () 	-> input.nil(),
      ()	-> result
    );
  }
  override public function toString(){
    return 'Lookahead($delegate)';
  }
}