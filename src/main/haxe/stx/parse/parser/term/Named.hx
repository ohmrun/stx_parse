package stx.parse.parser.term;

class Named<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,name:String){
    super(delegation,delegation.pos);
    this.tag = __.option(name);
  }
  inline public function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    return this.delegation.apply(ipt);
  }
  override public function toString(){
    return tag.defv('named');
  }
}