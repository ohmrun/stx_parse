package stx.parse.parser.term;

class Named<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,name:String){
    super(delegation,delegation.pos);
    this.tag = __.option(name);
  }
  override inline public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.defer(ipt,cont);
  }
  override public function toString(){
    return tag.defv('named');
  }
}