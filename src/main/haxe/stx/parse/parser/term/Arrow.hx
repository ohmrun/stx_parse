package stx.parse.parser.term;


class Arrow<I,O> extends Base<I,O,Arrowlet<Input<I>,ParseResult<I,O>,Noise>>{

  override public inline function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    return @:privateAccess delegation.toInternal().defer(ipt,cont);
  }
  override public inline function apply(ipt:Input<I>):ParseResult<I,O>{
    return @:privateAccess delegation.toInternal().apply(ipt);
  }
}