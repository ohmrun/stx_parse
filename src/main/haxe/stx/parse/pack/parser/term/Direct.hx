package stx.parse.pack.parser.term;

abstract class Direct<I,O> extends Base<I,O,Noise>{
  public function new(?pos:Pos){
    super(Noise,pos);
  }
} 