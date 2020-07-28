package stx.parse.pack.parser.term;

import stx.arw.Forward in ForwardArrow;

class Forward<I,O> extends Direct<I,O>{

  override function doApplyII(ipt,cont):Work{
    return parse(ipt).prepare(cont);
  }
  private function parse(ipt:Input<I>):ForwardArrow<ParseResult<I,O>>{
    return ForwardArrow.fromFunXR(() -> ipt.fail('parse'));
  }
}