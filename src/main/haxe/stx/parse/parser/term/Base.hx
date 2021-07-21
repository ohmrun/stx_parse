package stx.parse.parser.term;

abstract class Base<I,O,T> extends ParserCls<I,O>{

  public var delegation(default,null)        : T;

  public function new(?delegation:T,?tag:Option<String>,?pos:Pos){
    super(pos);
    this.delegation = delegation;
  }
  function check(){}
  abstract public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work;
  
  override public function toString(){
    //var id_s = Position.fromPos(pos).toStringClassMethodLine();
    return '${name()}';
  }
}