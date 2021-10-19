package stx.parse.parser.term;

class TagError<P,R> extends ErrorTransformer<P,R>{
  public function new(delegate:Parser<P,R>,name:String,?pos:Pos){
    super(delegate,(err:Defect<ParseError>) -> err.map(info -> info.tag(name)),pos);
  }
}