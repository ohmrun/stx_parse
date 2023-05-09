package stx.parse.parser.term;

abstract class Sync<P,R> extends SyncBase<P,R,Nada>{
  public function new(?tag:Option<String>,?id:Pos){
    super(Nada,tag,id);
  }
}