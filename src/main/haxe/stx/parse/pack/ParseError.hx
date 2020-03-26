package stx.parse.pack;

typedef ParseErrorInfoDef = {
  public var idx(default,null)    : Int;
  public var msg(default,null)    : String;
  public var fatal(default,null)  : Bool;
}
@:forward abstract ParseErrorInfo(ParseErrorInfoDef) from ParseErrorInfoDef{
  public function new(self) this = self;

  @:noUsing static public function make(idx,msg,fatal):ParseErrorInfo{
    return new ParseErrorInfo({
      idx   : idx,
      msg   : msg,
      fatal : fatal
    });
  }
  public function tag(name):ParseErrorInfo{
    return make(this.idx,name,this.fatal);
  }
}
@:forward abstract ParseError(Err<ParseErrorInfo>) from Err<ParseErrorInfo> to Err<ParseErrorInfo>{
  @:noUsing static public function at_with(input:Input<Dynamic>,msg,?fatal=false,?pos:Pos):ParseError{
    return new Err(Some(ERR_OF(ParseErrorInfo.make(input.offset,msg,fatal))),null,pos);
  }
  static public var FAIL(default,never) = 'FAIL';
  
  public inline function is_fatal():Bool{
    return this.head().map( _ -> _.fatal).defv(false);
  }
  public inline function is_parse_fail():Bool{
    return this.head().map( _ -> _.msg == FAIL ).defv(false);
  }
  public function toString(){
    return Std.string(this.data);
  }
  public function toParseResultWithInput<P,R>(ipt:Input<P>):ParseResult<P,R>{
    return ParseResult.fromFailure(ParseFailure.make(ipt,this));
  }
}