package stx.parse;

interface ParserApi<I,O> extends ArrowletApi<ParseInput<I>,ParseResult<I,O>,Noise>{
  public var tag                            : Option<String>;
  public var pos(default,null)              : Pos;
  
  public var uid(default,null)              : Int;
  
  public function identifier():String;
  public function asParser():Parser<I,O>;

  public function toInternal():Internal<ParseInput<I>,ParseResult<I,O>,Noise>;
}