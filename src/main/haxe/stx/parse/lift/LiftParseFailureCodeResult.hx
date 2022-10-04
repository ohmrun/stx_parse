package stx.parse.lift;

class LiftParseFailureCodeResult{
  static public function toParseResult_with<P,R>(self:Refuse<ParseFailureCode>,rest:ParseInput<P>,fatal=false):ParseResult<P,R>{
    return self.toParseFailure_with(rest,fatal).failure(rest);
  }
}