package stx.parse.lift;

class LiftStringReader{
  @:from inline public static function reader(str : String) : ParseInput<String> return {
    return ParseInput.pure(Enumerable.string(str));
  }
}