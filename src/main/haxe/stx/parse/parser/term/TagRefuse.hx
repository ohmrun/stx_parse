package stx.parse.parser.term;

class TagRefuse<P,R> extends RefuseTransformer<P,R>{
  public function new(delegate:Parser<P,R>,name:String,?pos:Pos){
    super(
      delegate
      ,(err:Refuse<ParseFailure>) -> err.errate(info -> info.tag(name))
      ,pos
    );
  }
}