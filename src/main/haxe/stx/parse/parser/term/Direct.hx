package stx.parse.parser.term;

abstract class Direct<I,O> extends Base<I,O,Noise>{
  public function new(?tag:Option<String>,?pos:Pos){
    super(tag,pos);
  }
} 