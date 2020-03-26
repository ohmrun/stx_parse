package stx.parse.lift;

class LiftStringReader{
  @:from inline public static function reader(str : String) : Input<String> return {
    return Input.pure(Enumerable.string(str));
  }
}