package stx.parse.parser.term;

abstract class ThroughBind<P,Ri,Rii> extends ParserCls<P,Rii>{
  var delegate      : Parser<P,Ri>;
  var after         : Parser<P,Rii>;

  public function new(delegate,?pos:Pos){
    super(pos);
    this.delegate       = delegate; 
  }
  abstract function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>;

  @:privateAccess public inline function apply(input:ParseInput<P>):ParseResult<P,Rii>{
    final ok = this.delegate.apply(input);

    after = through_bind(input,ok);
    return after.apply(ok.asset);
    
  }
  override public function toString(){
    var n = __.option(after).map(_ -> _.toString()).defv("?");
    return '$delegate => $n';
  }

}