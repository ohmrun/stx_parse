package stx.parse;

typedef SiteDef = {
  final ?file   : String;
  final line    : Int;
  final column  : Int;
  final ?length : Int;
}
@:using(stx.parse.Site.SiteLift)
abstract Site(SiteDef) from SiteDef to SiteDef{
  static public var _(default,never) = SiteLift;
  public inline function new(self:SiteDef) this = self;
  @:noUsing static inline public function lift(self:SiteDef):Site return new Site(self);

  public function prj():SiteDef return this;
  private var self(get,never):Site;
  private function get_self():Site return lift(this);
}
class SiteLift{
  static public inline function lift(self:SiteDef):Site{
    return Site.lift(self);
  }
}
