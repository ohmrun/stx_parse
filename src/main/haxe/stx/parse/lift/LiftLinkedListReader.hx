package stx.parse.lift;

class LiftLinkedListReader{
  inline public static function reader<T>(arr : LinkedList<T>) : Input<T> return {
    return Input.pure(Enumerable.linked_list(arr));
  }
}