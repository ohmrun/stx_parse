package stx.parse.pack;

typedef ParseResultDef<P,R> = Outcome<ParseSuccess<P,R>,ParseFailure<P>>;

@:forward abstract ParseResult<P,R>(ParseResultDef<P,R>) from ParseResultDef<P,R> to ParseResultDef<P,R>{
  public function new(self) this = self;
  static public function lift<P,R>(self:ParseResultDef<P,R>):ParseResult<P,R> return new ParseResult(self);
  
  @:from static public inline function fromSuccess<P,R>(self:ParseSuccess<P,R>):ParseResult<P,R>{
    return success(self);
  }
  @:noUsing static public function success<P,R>(self:ParseSuccess<P,R>):ParseResult<P,R>{
    return Success(self);
  }
  @:from static public inline function fromFailure<P,R>(self:ParseFailure<P>):ParseResult<P,R>{
    return failure(self);
  }
  @:noUsing static public function failure<P,R>(self:ParseFailure<P>):ParseResult<P,R>{
    return Failure(self);
  }
  public inline function pos(){
    return rest;
  }
  public var rest(get,never) : Input<P>;
  private function get_rest(){
    return this.fold(
      (s)   -> s.rest,
      (f)   -> f.rest
    );
  }
  public function fold<Ri>(succ:ParseSuccess<P,R> -> Ri,fail:ParseFailure<P> -> Ri):Ri{
    return switch(this){
      case Success(_succ)                 : succ(_succ);
      case Failure(_fail)                 : fail(_fail);
    }
  }
  public function s_fold<Ri>(succ:ParseSuccess<P,R> -> ParseResult<P,R> -> Ri,fail:ParseFailure<P> -> ParseResult<P,R> -> Ri):Ri{
    return switch(this){
      case Success(_succ)                 : succ(_succ,self);
      case Failure(_fail)                 : fail(_fail,self);
    }
  }
  public function map<Ri>(fn:R->Ri):ParseResult<P,Ri>{
    return lift(fold(
      (s) -> success(s.map(fn)),
      failure
    ));
  }

  public function elide():ParseResult<P,Dynamic>{
    return this;
  }
  public function toString(){
    return fold(
      (success)             -> __.show(success.with),
      (failure)             -> __.show(failure.with)
    );
  }
  public function value():Option<R> {
    return fold(
      (s) -> __.option(s.with),
      (_) -> None
    );
  }
  public function error():Option<ParseFailure<P>>{
    return fold(
      (_) -> None,
      (e) -> Some(e)
    );
  }
  public function prj():ParseResultDef<P,R> return this;
  private var self(get,never):ParseResult<P,R>;
  private function get_self():ParseResult<P,R> return lift(this);
}
class ParseResultLift{
  static public function mkLR<I,T>(seed: ParseResult<I,Dynamic>, rule: Parser<I,T>, head: Option<Head>) : LR return {
    seed: seed,
    rule: rule.elide(),
    head: head
  }
}