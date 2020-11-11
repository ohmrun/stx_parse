package stx.parse;

@:using(stx.parse.ParseResult.ParseResultLift)
typedef ParseResultDef<P,R> = Outcome<ParseSuccess<P,R>,ParseFailure<P>>;

@:using(stx.parse.ParseResult.ParseResultLift)
@:forward abstract ParseResult<P,R>(ParseResultDef<P,R>) from ParseResultDef<P,R> to ParseResultDef<P,R>{
  public function new(self) this = self;
  static public function lift<P,R>(self:ParseResultDef<P,R>):ParseResult<P,R> return new ParseResult(self);
  
  @:from static public inline function fromSuccess<P,R>(self:ParseSuccess<P,R>):ParseResult<P,R>{
    return success(self);
  }
  @:noUsing static public function success<P,R>(self:ParseSuccess<P,R>):ParseResult<P,R>{
    return lift(Success(self));
  }
  @:from static public inline function fromFailure<P,R>(self:ParseFailure<P>):ParseResult<P,R>{
    return failure(self);
  }
  @:noUsing static public function failure<P,R>(self:ParseFailure<P>):ParseResult<P,R>{
    return lift(Failure(self));
  }
  public inline function pos(){
    return rest;
  }
  public var rest(get,never) : Input<P>;
  private inline function get_rest(){
    return this.fold(
      (s)   -> s.rest,
      (f)   -> f.rest
    );
  }
  public inline function fold<Ri>(succ:ParseSuccess<P,R> -> Ri,fail:ParseFailure<P> -> Ri):Ri{
    return switch(this){
      case Success(_succ)                 : succ(_succ);
      case Failure(_fail)                 : fail(_fail);
    }
  }
  public inline function map<Ri>(fn:R->Ri):ParseResult<P,Ri>{
    return lift(fold(
      (s) -> success(s.map(fn)),
      failure
    ));
  }
  public inline function map_o<Ri>(fn:R->Option<Ri>):ParseResult<P,Ri>{
    return lift(fold(
      (s) -> success(s.map_o(fn)),
      failure
    ));
  }
  /**
    If you run a parser with a subset of the input, remember to hook up the rest of the original input using this.
  **/
  public function tack<Q>(success:Input<Q>,failure:Input<Q>):ParseResult<Q,R>{
    return lift(fold(
      (ok) -> Success(ParseSuccess.make(success,ok.with)),
      (no) -> Failure(ParseFailure.make(failure,no.with))
    ));
  }
  public function elide():ParseResult<P,Dynamic>{
    return this;
  }
  public function toRes():Res<Option<R>,ParseErrorInfo>{
    return fold(
      ok -> __.accept(ok.with),
      no -> no.toRes()
    );
  }
  public function toResI():Res<Couple<Option<R>,Input<P>>,ParseErrorInfo>{
    return fold(
      ok -> __.accept(__.couple(ok.with,ok.rest)),
      no -> no.toRes()
    );
  }
  public function value():Option<R> {
    return fold(
      (s) -> s.with,
      (_) -> None
    );
  }
  public function error():Option<ParseFailure<P>>{
    return fold(
      (_) -> None,
      (e) -> Some(e)
    );
  }
  public inline function ok(){
    return fold(
      _ -> true,
      _ -> false
    );
  }
  public function prj():ParseResultDef<P,R> return this;
  private var self(get,never):ParseResult<P,R>;
  private function get_self():ParseResult<P,R> return lift(this);
}
class ParseResultLift{
  static public function toString<I,O>(self:ParseResult<I,O>):String{
    return self.fold(
      (success)             -> 'OK: '    + Std.string(success.with),
      (failure)             -> 'FAIL: '  + Std.string(failure.with)
    );
  }
  static public function mkLR<I,T>(seed: ParseResult<I,Dynamic>, rule: Parser<I,T>, head: Option<Head>) : LR return {
    seed: seed,
    rule: rule.elide(),
    head: head
  }
}