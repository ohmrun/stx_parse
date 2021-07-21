package stx.parse.parser.term;

class Postfix<I,Oi,Oii> extends stx.arw.arrowlet.term.Then<ParseInput<I>,ParseResult<I,Oi>,ParseResult<I,Oii>,Noise> implements ParserApi<I,Oii>{
  public function new(lhs:Parser<I,Oi>,rhs:Fletcher<ParseResult<I,Oi>,ParseResult<I,Oii>,Noise>,?tag:Option<String>,?id:Pos){
    super(@:privateAccess lhs.toInternal(),@:privateAccess rhs.toInternal());
    this.tag = __.option(tag).flatten().defv(None);
    this.id  = id;
  }
  public var tag                            : Option<String>;
  
  //public var uid(default,null)              : Int;
  
  inline public function name(){
    return this.identifier();
  }
  public inline function asParser():Parser<I,Oii>{
    return new Parser(this);
  }
  public inline function toInternal():Internal<ParseInput<I>,ParseResult<I,Oii>,Noise>{
    return this;
  }
}