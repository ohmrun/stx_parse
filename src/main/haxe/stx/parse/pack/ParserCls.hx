package stx.parse.pack;

abstract class ParserCls<I,O> implements ParserApi<I,O> extends ArrowletCls<Input<I>,ParseResult<I,O>,Noise>{
  public function new(?tag:Option<String>,?pos:Pos){
    super();
    this.tag  = __.option(tag).flatten().def(name);
    this.pos  = pos;
  }
  public var tag                            : Option<String>;
  public var pos(default,null)              : Pos;
  
  public var uid(default,null)              : Int;
  
  inline public function name(){
    return this.identifier();
  }
  public function asParser():Parser<I,O>{
    return new Parser(this);
  }
  public function toInternal():Internal<Input<I>,ParseResult<I,O>,Noise>{
    return this;
  }
  override public function toString(){
    return name();
  }
}