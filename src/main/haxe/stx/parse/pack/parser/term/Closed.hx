package stx.parse.pack.parser.term;

class Closed<I,O> extends Base<I,O,Forward<ParseResult<I,O>>>{
  override public function doApplyII(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.prepare(cont);
  }
}