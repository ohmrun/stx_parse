package stx.parse.lift;

class LiftClusterReader{
  inline public static function reader<T>(arr : Cluster<T>) : ParseInput<T> return {
    return ParseInput.pure(Enumerable.Array(@:privateAccess arr.prj()));
  }
}