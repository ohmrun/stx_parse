package stx.parse.lift;

class LiftArrayOfParser{
  static public inline function ors<I,T>(self:Array<Parser<I,T>>):Parser<I,T>{
    return Parser.Ors(self).asParser();
  }
}