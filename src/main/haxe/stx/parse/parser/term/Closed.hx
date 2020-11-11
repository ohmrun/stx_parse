package stx.parse.parser.term;

class Closed<I,O> extends Base<I,O,Provide<ParseResult<I,O>>>{
  override inline public function defer(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.prepare(cont);
  }
  override inline public function apply(ipt:Input<I>):ParseResult<I,O>{
    return throw E_Arw_IncorrectCallingConvention;
  }
}