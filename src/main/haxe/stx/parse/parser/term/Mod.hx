package stx.parse.parser.term;

abstract class Mod<P,R> extends ParserCls<P,R>{
  public function new(delegate:Parser<P,R>,?tag:Option<String>,?pos:Pos){
    super(tag,pos);
    this.delegate = delegate;
  }
  var delegate  : Parser<P,R>;
  abstract function bound(input:ParseInput<P>,result:ParseResult<P,R>): ParseResult<P,R>;

  public function apply(input:ParseInput<P>):ParseResult<P,R>{
    return bound(input,delegate.apply(input));
  }
}