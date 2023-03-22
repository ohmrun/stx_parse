package stx.parse;

abstract class ParserCls<I,O> implements ParserApi<I,O> extends Clazz{
  public function new(?tag:Option<String>,?pos:Pos){
    super();
    this.pos    = pos;
    this.tag    = __.option(tag).flatten().defv(this.identifier().name);
  }
  public final pos                              : Pos;
  
  public var tag                                : Option<String>;
 
  abstract public function apply(p:ParseInput<I>):ParseResult<I,O>;
  
  public inline function asParser():Parser<I,O>{
    return new Parser(this);
  }
  public function toString(){
    return this.identifier().name;
  }
}