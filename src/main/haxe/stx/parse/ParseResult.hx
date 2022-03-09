package stx.parse;

@:using(stx.parse.ParseResult.ParseResultLift)
class ParseResultCls<P,R> extends EquityCls<ParseInput<P>,Option<R>,ParseError>{
  public function toString():String{
    return ParseResult._.toString(this);
  }
  public function errate(fn:ParseError->ParseError):ParseResult<P,R>{
    return errata(x -> x.errate(fn));
  }
  public function errata(fn:Error<ParseError>->Error<ParseError>):ParseResult<P,R>{
    return ParseResult._.errata(this,fn);
  }
}
typedef ParseResultDef<P,R> = EquityDef<ParseInput<P>,Option<R>,ParseError>;

@:using(stx.nano.Equity.EquityLift)
@:using(stx.parse.ParseResult.ParseResultLift)
@:forward abstract ParseResult<P,R>(ParseResultDef<P,R>) from ParseResultDef<P,R> to ParseResultDef<P,R>{
  static public var _(default,never) = ParseResultLift;
  public function new(self) this = self;
  static public function lift<P,R>(self:ParseResultDef<P,R>):ParseResult<P,R> return new ParseResult(self);
  @:noUsing static public function make<I,O,E>(asset:ParseInput<I>,value:Null<Option<O>>,?error:Iter<ParseError>){
    return lift(new ParseResultCls(error,value,asset).toEquity());
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
  public function elide():ParseResult<P,Dynamic>{
    return this;
  }
  public function prj():ParseResultDef<P,R> return this;
  private var self(get,never):ParseResult<P,R>;
  private function get_self():ParseResult<P,R> return lift(this);

  public inline function pos(){
    return this.asset;
  }
  public function errata(fn:Error<ParseError>->Error<ParseError>):ParseResult<P,R>{
    return _.errata(this,fn);
  }
  public function toRes(){
    return _.toRes(this);
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
      ()  -> __.reject(self.toDefect().toError().except())
    );
  }
  static public function errata<I,O>(self:ParseResultDef<I,O>,fn:Error<ParseError>->Error<ParseError>):ParseResult<I,O>{
    return ParseResult.make(self.asset,self.value,self.error.errata(fn));
  }
  static public function with_errata<P,R>(self:ParseResultDef<P,R>,error:Errata<ParseError>):ParseResult<P,R>{
    return ParseResult.make(self.asset,self.value,self.error.concat(error));
  }
}