package stx.parse.parser.term;

abstract class Base<I,O,T> extends ParserCls<I,O>{

  private var delegation        : T;

  public function new(?delegation:T,?pos:Pos){
    super(pos);
    this.delegation = delegation;
    this.tag        = Some(name());
  }
  function check(){}
  override public function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.value(apply(ipt)).serve();
  }

  override public function toString(){
    //var id_s = Position.fromPos(pos).toStringClassMethodLine();
    return '$tag';
  }
}