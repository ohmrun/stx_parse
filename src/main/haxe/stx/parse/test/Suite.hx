package stx.parse.test;

@:keep
class Suite{
  static public function tests(){
    return [
      new stx.parse.term.json.Test()
    ];
  }
}