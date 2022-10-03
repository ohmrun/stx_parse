package stx.parse.parser.term;

abstract class SyncBase<I,O,T> extends Base<I,O,T>{

  public function new(?delegation:T,?tag:Option<String>,?pos:Pos){
    super(tag,pos);
    this.delegation = delegation;
  }
}