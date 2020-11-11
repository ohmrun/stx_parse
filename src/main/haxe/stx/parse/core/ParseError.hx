package stx.parse.core;

typedef ParseErrorInfoDef = {
  public var idx(default,null)              : Int;
  public var msg(default,null)              : String;
  public var fatal(default,null)            : Bool;
  @:optional public var label(default,null) : String;
}
@:forward abstract ParseErrorInfo(ParseErrorInfoDef) from ParseErrorInfoDef{
  public function new(self) this = self;

  @:noUsing static public function make(idx,msg,fatal,?label):ParseErrorInfo{
    return new ParseErrorInfo({
      idx   : idx,
      msg   : msg,
      fatal : fatal,
      label : label
    });
  }
  public function tag(name):ParseErrorInfo{
    return make(this.idx,name,this.fatal);
  }
}
@:forward abstract ParseError(Err<ParseErrorInfo>) from Err<ParseErrorInfo> to Err<ParseErrorInfo>{
  @:noUsing static public function at_with(input:Input<Dynamic>,msg,?fatal=false,?label:String,?pos:Pos):ParseError{
    return new Err(Some(ERR_OF(ParseErrorInfo.make(input.offset,msg,fatal,label))),null,pos);
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