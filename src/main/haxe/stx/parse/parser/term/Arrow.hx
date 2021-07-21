package stx.parse.parser.term;


class Arrow<I,O> extends Base<I,O,Fletcher<ParseInput<I>,ParseResult<I,O>,Noise>>{
  public inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    return cont.receive(delegation.forward(ipt));
  }
}