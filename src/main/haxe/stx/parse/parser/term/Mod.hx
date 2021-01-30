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
  public function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,R>,Noise>):Work{
    return delegate.toInternal().defer(input,cont.joint(
      (outcome:Outcome<ParseResult<P,R>,Defect<Noise>>) -> outcome.fold(
        result -> cont.value(bound(input,result)).serve(),
        error  -> cont.error(error).serve()
      )
    ));
  }
}