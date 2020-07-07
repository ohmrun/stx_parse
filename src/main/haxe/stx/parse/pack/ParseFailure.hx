package stx.parse.pack;

typedef ParseFailureDef<P> = RestWith<P,ParseError>;

@:forward abstract ParseFailure<P>(ParseFailureDef<P>) from ParseFailureDef<P> to ParseFailureDef<P>{
  public inline function new(self) this = self;
  static public inline function lift<P>(self:ParseFailureDef<P>):ParseFailure<P> return new ParseFailure(self);
  
  static public inline function make<P,R>(rest:Input<P>,stack:ParseError):ParseFailure<P>{
    return lift({
      rest : rest,
      with : stack
    });
  }
  static public function at_with<P>(input:Input<P>,msg:String,?fatal:Bool = false,?pos:Pos):ParseFailure<P>{
    return make(input,
      ParseError.at_with(input,msg,fatal,pos)
    );
  }
  public inline function next(err:ParseError):ParseFailure<P>{
    return make(this.rest,this.with.next(err));
  }
  public inline function is_fatal(){
    return this.with.is_fatal();
  }
  public inline function is_parse_fail(){
    return this.with.is_parse_fail();
  }
  public function tack(input:Input<P>):ParseFailure<P>{
    return make(input,this.with);
  }
  public function mod(fn:ParseError->ParseError):ParseFailure<P>{
    return make(this.rest,fn(this.with));
  }
  @:to public function toParseResult<R>():ParseResult<P,R>{
    return Failure(this);
  }
  public function prj():ParseFailureDef<P> return this;
  private var self(get,never):ParseFailure<P>;
  private function get_self():ParseFailure<P> return lift(this);
 
  public function toRes<T,E>(?pos:Pos):Res<T,ParseErrorInfo>{
    return __.failure(this.with);
  }
}
