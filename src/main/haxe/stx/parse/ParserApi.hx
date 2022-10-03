package stx.parse;

interface ParserApi<I,O>{
  public var tag                            : Option<String>;
  public final pos                          : Pos;
  //public final uid                          : Int;
  
  public function asParser():Parser<I,O>;
  public function apply(p:ParseInput<I>):ParseResult<I,O>;
    
  public function toString():String;
}