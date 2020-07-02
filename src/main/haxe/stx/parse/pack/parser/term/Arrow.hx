package stx.parse.pack.parser.term;


class Arrow<I,O> extends Base<I,O,Arrowlet<Input<I>,ParseResult<I,O>,Noise>>{

  override public function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    return delegation.applyII(ipt,cont);
  }
}