package stx.parse.lift;

class LiftLinkedListReader{
  inline public static function reader<T>(arr : LinkedList<T>) : ParseInput<T> return {
    return ParseInput.pure(Enumerable.LinkedList(arr));
  }
}