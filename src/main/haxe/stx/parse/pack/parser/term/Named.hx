package stx.parse.pack.parser.term;

class Named<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,name:String){
    super(delegation,delegation.pos);
    this.tag = __.option(name);
  }
  override inline public function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.defer(ipt,cont);
  }
  override inline public function apply(ipt:Input<I>):ParseResult<I,O>{
    return this.delegation.apply(ipt);
  }
}