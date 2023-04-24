package stx.parse.parser.term;

abstract class Base<I,O,T> extends ParserCls<I,O>{

  public var delegation(default,null)        : T;

  public function new(?delegation:T,?tag:Option<String>,?pos:Pos){
    super(tag,pos);
    this.delegation = delegation;
  }
  function check(){}
  
  override public function toString(){
    //var id_s = Position.fromPos(pos).toStringClassMethodLine();
    return '${this.identifier().name}';
  }
}