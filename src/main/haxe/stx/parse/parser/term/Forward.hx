package stx.parse.parser.term;

import stx.fletcher.Provide in ProvideFletcher;

class Forward<I,O> extends Direct<I,O>{

  override public inline function defer(ipt,cont):Work{
    return parse(ipt).prepare(cont);
  }
  private function parse(ipt:ParseInput<I>):ProvideFletcher<ParseResult<I,O>>{
    return ProvideFletcher.fromFunXR(() -> ipt.fail('parse'));
  }
}