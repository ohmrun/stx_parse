package stx.parse.lift;

class LiftParseFailureCodeRefuse{
  static public function toParseFailure_with<P,R>(self:Refuse<ParseFailureCode>,rest:ParseInput<P>,fatal=false):Refuse<ParseFailure>{
    return self.errate(
      e -> ParseFailure.make(rest.position(),e,fatal)
    );
  }
}