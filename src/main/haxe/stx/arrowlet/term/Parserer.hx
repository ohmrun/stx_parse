package stx.arrowlet.term;

using stx.parse.Pack;
using stx.Arrowlet;

typedef ParsererDef<I,O> = ArrowletDef<Input<I>,ParseResult<I,O>,Noise>;

abstract Parserer<I,O>(ParsererDef<I,O>) from ParsererDef<I,O> to ParsererDef<I,O>{
  public function new(self) this = self;
  static public function lift<I,O>(self:ParsererDef<I,O>):Parserer<I,O> return new Parserer(self);
  

  

  public function prj():ParsererDef<I,O> return this;
  private var self(get,never):Parserer<I,O>;
  private function get_self():Parserer<I,O> return lift(this);
}