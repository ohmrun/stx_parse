package stx.parse;

@:using(stx.parse.ParseResult.ParseResultLift)
typedef ParseResultDef<P,R> = EquityDef<ParseInput<P>,Option<R>,ParseError>;

@:using(stx.nano.Equity.EquityLift)
@:using(stx.parse.ParseResult.ParseResultLift)
@:forward abstract ParseResult<P,R>(ParseResultDef<P,R>) from ParseResultDef<P,R> to ParseResultDef<P,R>{
  public function new(self) this = self;
  static public function lift<P,R>(self:ParseResultDef<P,R>):ParseResult<P,R> return new ParseResult(self);
  @:noUsing static public function make<I,O,E>(asset:ParseInput<I>,value:Null<Option<O>>,?error:Defect<ParseError>){
    return lift({ asset : asset, value : value, error : Defect.make(error)});
  }
  public inline function map<Ri>(fn:R->Ri):ParseResult<P,Ri>{
    return lift(Equity._.map(this,opt -> opt.map(fn)));
  }
  public inline function is_ok(){
    return !this.error.is_defined();
  }
  public inline function fails<Ri>():ParseResult<P,Ri>{
    return make(this.asset,None,this.error);
  }
  // /**
  //   If you run a parser with a subset of the input, remember to hook up the rest of the original input using this.
  // **/
  // public function tack<Q>(success:ParseInput<Q>,failure:ParseInput<Q>):ParseResult<Q,R>{
  //   return lift(fold(
  //     (ok) -> Success(ParseSuccess.make(success,ok.with)),
  //     (no) -> Failure(ParseFailure.make(failure,no.with))
  //   ));
  // }
  public function elide():ParseResult<P,Dynamic>{
    return this;
  }
  public function prj():ParseResultDef<P,R> return this;
  private var self(get,never):ParseResult<P,R>;
  private function get_self():ParseResult<P,R> return lift(this);

  public inline function pos(){
    return this.asset;
  }
}
class ParseResultLift{
  static public function toString<I,O>(self:ParseResult<I,O>):String{
    return self.has_error().if_else(
      () -> Std.string(self.error),
      () -> Std.string(self.value) 
    );
  }
  static public function mkLR<I,T>(seed: ParseResult<I,Dynamic>, rule: Parser<I,T>, head: Option<Head>) : LR return {
    seed: seed,
    rule: rule.elide(),
    head: head
  }
  static public function mod<P,R>(self:ParseResult<P,R>,fn:ParseInput<P> -> ParseInput<P>):ParseResult<P,R>{
    return ParseResult.lift(self.copy(fn(self.asset)));
  }
  static public function flat_map<P,Ri,Rii>(self:ParseResult<P,Ri>,fn:Ri->ParseResult<P,Rii>):ParseResult<P,Rii>{
    return self.is_ok().if_else(
      () -> self.value.fold(
        ok -> fn(ok),
        () -> self.asset.nil()
      ),
      () -> self.fails()
    );   
  }
  static public inline function fudge<P,R>(self:ParseResult<P,R>):R{
    return self.value.fudge();
  }
  static public inline function toRes<P,R>(self:ParseResult<P,R>):Res<Option<R>,ParseError>{
    return self.is_ok().if_else(
      ()  -> __.accept(self.value),
      ()  -> __.reject(self.error.toErr())
    );
  }
}