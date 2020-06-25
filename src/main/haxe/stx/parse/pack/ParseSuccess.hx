package stx.parse.pack;

typedef ParseSuccessDef<P,R> = RestWithDef<P,Option<R>>;

@:forward abstract ParseSuccess<P,R>(ParseSuccessDef<P,R>) from ParseSuccessDef<P,R> to ParseSuccessDef<P,R>{
  public function new(self) this = self;
  static public function lift<P,R>(self:ParseSuccessDef<P,R>):ParseSuccess<P,R> return new ParseSuccess(self);
  
  @:noUsing static public function make<P,R>(rest:Input<P>,match:Option<R>):ParseSuccess<P,R>{
    return lift(
      RestWith.make(
        rest,
        match
      )
    );
  }
  public function map<Ri>(fn:R->Ri):ParseSuccess<P,Ri>
    return make(
      this.rest,
      this.with.map(fn)
    );

  public function map_o<Ri>(fn:R->Option<Ri>):ParseSuccess<P,Ri>
    return make(
      this.rest,
      this.with.flat_map(fn)
    );
  public function then(rest:Input<P>):ParseSuccess<P,R>{
    return make(
      rest,
      this.with
    );
  }
  @:to public function toParseResult():ParseResult<P,R>{
    return Success(this);
  }

  public function prj():ParseSuccessDef<P,R> return this;
  private var self(get,never):ParseSuccess<P,R>;
  private function get_self():ParseSuccess<P,R> return lift(this);
}