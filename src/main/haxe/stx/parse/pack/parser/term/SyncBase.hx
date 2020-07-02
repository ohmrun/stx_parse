package stx.parse.pack.parser.term;

class SyncBase<I,O,T> extends Base<I,O,T>{

  public function new(?delegation,?id:Pos){
    super(id);
    this.delegation = delegation;
    this.id         = id;
    this.tag        = Some(name());
  }
  override private function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.value(this.do_parse(ipt)).serve();
  }
  private function do_parse(ipt:Input<I>){
    return ParseFailure.at_with(ipt,"default implementation",true);
  }
}