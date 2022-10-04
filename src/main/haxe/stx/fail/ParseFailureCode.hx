package stx.fail;

enum ParseFailureCodeSum{
  E_Parse_ParseFailed(detail:String);
  E_Parse_UndefinedParseDelegate;
  E_Parse_Eof;
  E_Parse_NotEof;
}
abstract ParseFailureCode(ParseFailureCodeSum) from ParseFailureCodeSum to ParseFailureCodeSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ParseFailureCodeSum):ParseFailureCode return new ParseFailureCode(self);

  public function prj():ParseFailureCodeSum return this;
  private var self(get,never):ParseFailureCode;
  private function get_self():ParseFailureCode return lift(this);
  @:from static public function fromString(self:String){
    return lift(E_Parse_ParseFailed(self));
  }
}