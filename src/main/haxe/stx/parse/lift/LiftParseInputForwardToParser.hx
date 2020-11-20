package stx.parse.lift;

class LiftParseInputForwardToParser{
  static inline public function asParser<I,O>(self:ParseInput<I>->Provide<ParseResult<I,O>>,tag):Parser<I,O>{
    return Parser.fromParseInputProvide(self,tag);
  }
}