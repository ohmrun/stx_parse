package stx.parse.pack.parser.term;

import stx.arw.Provide in ProvideArrow;

class Forward<I,O> extends Direct<I,O>{

  override public inline function defer(ipt,cont):Work{
    return parse(ipt).prepare(cont);
  }
  private function parse(ipt:Input<I>):ProvideArrow<ParseResult<I,O>>{
    return ProvideArrow.fromFunXR(() -> ipt.fail('parse'));
  }
}