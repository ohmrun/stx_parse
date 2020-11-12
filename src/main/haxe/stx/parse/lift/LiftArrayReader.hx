package stx.parse.lift;

class LiftArrayReader{
  inline public static function reader<T>(arr : Array<T>) : ParseInput<T> return {
    return ParseInput.pure(Enumerable.array(arr));
  }
}