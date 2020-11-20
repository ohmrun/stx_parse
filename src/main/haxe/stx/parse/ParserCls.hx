package stx.parse;

abstract class ParserCls<I,O> implements ParserApi<I,O> extends ArrowletCls<ParseInput<I>,ParseResult<I,O>,Noise>{
  public function new(?tag:Option<String>,?pos:Pos){
    super();
    this.tag    = __.option(tag).flatten().def(name);
    this.pos    = pos;
  }
  public var tag                            : Option<String>;
  public var pos(default,null)              : Pos;
  
  public var uid(default,null)              : Int;
  
  inline public function name(){
    return this.identifier().split(".").last().defv('ParserCls');
  }
  // public function asParser():Parser<I,O>{
  //   return #if debug Parser.Debug(Parser.lift(this)) #else new Parser(this) #end;
  // }
  public inline function asParser():Parser<I,O>{
    return new Parser(this);
  }
  public inline function toInternal():Internal<ParseInput<I>,ParseResult<I,O>,Noise>{
    return this;
  }
  override public function toString(){
    return name();
  }
}