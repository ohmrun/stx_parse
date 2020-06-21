package stx.parse.pack.parser.term;

class Delegate<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,?id){
    super(delegation,id);
    this.tag = delegation.tag;
  }
  override function check(){
    __.assert(id).exists(delegation);
  }
  override function do_parse(ipt){
    return this.delegation.parse(ipt);
  }
}