package stx.parse.parser.term;

class TagError<P,R> extends ErrorTransformer<P,R>{
  public function new(delegate:Parser<P,R>,name:String,?pos:Pos){
    super(
      delegate
      ,(err:Error<ParseError>) -> err.errate(info -> info.tag(name))
      ,pos
    );
  }
}