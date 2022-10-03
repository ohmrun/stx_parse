package stx.parse.parser.term;

class Delegate<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,?pos:Pos){
    super(delegation,pos);
    this.tag = delegation.tag;
  }
  override function check(){
    __.assert(pos).exists(delegation);
  }
  public function apply(ipt){
    return this.delegation.apply(ipt);
  }
  override public function toString(){
    return '${this.identifier().name}(${delegation})';
  }
}