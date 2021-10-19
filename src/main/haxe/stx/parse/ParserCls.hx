package stx.parse;

abstract class ParserCls<I,O> implements ParserApi<I,O> implements FletcherApi<ParseInput<I>,ParseResult<I,O>,Noise> extends Clazz{
  public function new(?tag:Option<String>,?pos:Pos){
    super();
    this.pos    = pos;
    this.tag    = __.option(tag).flatten().def(name);
  }
  public final pos                              : Pos;
  //public final uid                              : Int;
  
  public var tag                                : Option<String>;
 
  inline public function name(){
    return this.identifier().name;
  }
  public inline function asParser():Parser<I,O>{
    return new Parser(this);
  }
  public function toString(){
    return name();
  }
  public function toFletcher(){
    return Fletcher.lift(this.defer);
  }
  //abstract public function apply(p:ParseInput<I>):ParseResult<I,O>;
  abstract public function defer(p:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work;
  
}