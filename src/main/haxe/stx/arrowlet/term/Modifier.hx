package stx.arrowlet.term;

class Modifier<I,T> extends ArrowletCls<Input<I>,ParseResult<I,T>,Noise>{

  var fmap : ParseResult<I,T> -> ParseResult<I,U>;
  public function new(fmap){
    this.fmap = fmap
  }
  public function defer(i:Input<I>,cont:Terminal<ParseResult<I,T>,Noise):Work{

  }
}