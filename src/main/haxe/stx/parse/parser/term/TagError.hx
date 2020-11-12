package stx.parse.parser.term;

class TagError<P,R> extends ErrorTransformer<P,R>{
  public function new(delegate:Parser<P,R>,name:String,?pos:Pos){
    super(delegate,(err:ParseError) -> err.map(info -> info.tag(name)),pos);
  }
}