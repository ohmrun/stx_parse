package stx.parse.parser.term;

abstract class Sync<P,R> extends Direct<P,R>{
  public function new(?id:Pos){
    super(id);
  }
}