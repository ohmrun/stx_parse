package stx.parse.lift;

class LiftInputForwardToParser{
  static inline public function asParser<I,O>(self:Input<I>->Forward<ParseResult<I,O>>):Parser<I,O>{
    return Parser.fromInputForward(self);
  }
}