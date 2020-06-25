package stx.parse.pack.parser.term;

class Base<I,O,T> extends ParserApi<I,O>{

  private var delegation        : T;

  public function new(?delegation,?id:Pos){
    super(id);
    this.delegation = delegation;
    this.id         = id;
    this.tag        = Some(name());
  }
  function check(){
  
  }
  override public function applyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>){
    switch(this.tag){
      case Some(v)  : ipt.tag = v;
      case null     : 
      default       : 
    }
    #if test
      check();
    #end
    return doApplyII(ipt,cont);
  }
  override private function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.value(ParseFailure.at_with(ipt,"default implementation",true)).serve();
  }
  public inline function asParser():Parser<I,O>{
    return Parser.lift(this);
  }
  public function toString(){
    var id_s = Position.fromPos(id).toStringClassMethodLine();
    return '${name()} $tag $id_s';
  }
}