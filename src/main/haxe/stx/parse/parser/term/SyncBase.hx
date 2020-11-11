package stx.parse.parser.term;

abstract class SyncBase<I,O,T> extends Base<I,O,T>{

  public function new(?delegation:T,?pos:Pos){
    super(pos);
    this.delegation = delegation;
    this.tag        = Some(name());
  }
  public override inline function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    this.result = apply(ipt);
    this.status = Secured;

    return cont.lense(this).serve();
  }
}