package stx.parse.parser.term;

class TaggedAnon<P,R> extends Anon<P,R>{
  public function new(method,tag,?id:Pos){
    super(method,id);
    this.tag = Some(tag);
  }
}