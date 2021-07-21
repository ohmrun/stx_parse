package stx.parse.parser.term;

abstract class SyncBase<I,O,T> extends Base<I,O,T>{

  public function new(?delegation:T,?tag:Option<String>,?pos:Pos){
    super(tag,pos);
    this.delegation = delegation;
  }
  public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    final result = apply(ipt);
    return cont.receive(cont.value(result));
  }
  abstract public function apply(ipt:ParseInput<I>):ParseResult<I,O>;
}