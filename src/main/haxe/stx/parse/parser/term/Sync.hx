package stx.parse.parser.term;

abstract class Sync<P,R> extends SyncBase<P,R,Noise>{
  public function new(?tag:Option<String>,?id:Pos){
    super(Noise,tag,id);
  }
}