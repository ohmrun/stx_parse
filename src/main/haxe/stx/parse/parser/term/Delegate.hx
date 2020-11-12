package stx.parse.parser.term;

class Delegate<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,?pos:Pos){
    super(delegation,pos);
    this.tag = delegation.tag;
  }
  override function check(){
    __.assert(pos).exists(delegation);
  }
  override public function defer(ipt,cont):Work{
    return this.delegation.defer(ipt,cont);
  }
}