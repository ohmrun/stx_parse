package stx.parse.lift;

class LiftInputForwardToParser{
  static inline public function asParser<I,O>(self:Input<I>->Provide<ParseResult<I,O>>):Parser<I,O>{
    return Parser.fromInputProvide(self);
  }
}