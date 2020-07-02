package stx.parse.pack;

abstract UID(Int) to Int{
  public function new(){
    this = UIDs.parserUid();
  }
}
private class UIDs{
  static var _parserUid = 0;
  public static function parserUid() {
    return __.option(_parserUid).is_defined() ? ++_parserUid : _parserUid = 0;
  }
}