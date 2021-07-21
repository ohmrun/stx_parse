package stx.parse;

interface ParserApi<I,O> extends FletcherApi<ParseInput<I>,ParseResult<I,O>,Noise>{
  public var tag                            : Option<String>;
  public final pos                          : Pos;
  //public final uid                          : Int;
  
  public function asParser():Parser<I,O>;
  public function toFletcher():Fletcher<ParseInput<I>,ParseResult<I,O>,Noise>;
  
  public function defer(p:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work;
    
  public function toString():String;
}