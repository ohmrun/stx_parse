package stx.parse.parser.term;


class Arrow<I,O> extends Base<I,O,Arrowlet<ParseInput<I>,ParseResult<I,O>,Noise>>{

  override public inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    return @:privateAccess delegation.toInternal().defer(ipt,cont);
  }
  public inline function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    return @:privateAccess delegation.toInternal().apply(ipt);
  }
}