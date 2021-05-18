package stx.parse.parser.term;

abstract class Base<I,O,T> extends ParserCls<I,O>{

  private var delegation        : T;

  public function new(?delegation:T,?tag:Option<String>,?pos:Pos){
    super(pos);
    this.delegation = delegation;
  }
  function check(){}
  public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.value(apply(ipt)).serve();
  }
  abstract public function apply(ipt:ParseInput<I>):ParseResult<I,O>;

  override public function toString(){
    //var id_s = Position.fromPos(pos).toStringClassMethodLine();
    return '${name()}';
  }
}