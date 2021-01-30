package stx.parse.parser.term;

class Closed<I,O> extends Base<I,O,Provide<ParseResult<I,O>>>{
  override inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.prepare(cont);
  }
  inline public function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    return throw E_Arw_IncorrectCallingConvention;
  }
}