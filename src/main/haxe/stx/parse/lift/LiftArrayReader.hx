package stx.parse.lift;

class LiftArrayReader{
  inline public static function reader<T>(arr : Array<T>) : Input<T> return {
    return Input.pure(Enumerable.array(arr));
  }
}