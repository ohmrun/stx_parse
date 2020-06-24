package stx.parse.pack.parser.term;

class TaggedAnon<P,R> extends Anon<P,R>{
  public function new(method,tag,?id){
    super(method,id);
    this.tag = Some(tag);
  }
}