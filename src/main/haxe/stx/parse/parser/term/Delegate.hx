package stx.parse.parser.term;

class Delegate<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,?id:Pos){
    super(delegation,id);
    this.tag = __.option(delegation.tag).flat_map(_ -> _).defv(None);
  }
  override function check(){
    __.assert(id).exists(delegation);
  }
  override inline public function defer(ipt,cont):Work{
    return this.delegation.defer(ipt,cont);
  }
}