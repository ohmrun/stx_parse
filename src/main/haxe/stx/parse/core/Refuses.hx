package stx.parse.core;

class Refuses{
  static public function e_parse_failure(digests:Digests):Digest{
    return new EParseFailure();
  }
}
class EParseFailure extends Digest{
  public function new(){
    super("01FRQ9XPNHGFY88XHMMSS8GBPZ","parse failed");
  }
}