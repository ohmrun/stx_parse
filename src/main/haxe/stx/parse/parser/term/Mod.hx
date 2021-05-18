package stx.parse.parser.term;

abstract class Mod<P,R> extends ParserCls<P,R>{
  public function new(delegate:Parser<P,R>,?tag:Option<String>,?pos:Pos){
    super(tag,pos);
    this.delegate = delegate;
  }
  var delegate  : Parser<P,R>;
  abstract function bound(input:ParseInput<P>,result:ParseResult<P,R>): ParseResult<P,R>;

  public function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,R>,Noise>):Work{
    return cont.receive(delegate.toFletcher().receive(input).map(
      (result) -> bound(input,result)
    ));
  }
}