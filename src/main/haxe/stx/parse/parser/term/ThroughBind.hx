package stx.parse.parser.term;

abstract class ThroughBind<P,Ri,Rii> extends ParserCls<P,Rii>{
  var delegate      : Parser<P,Ri>;
  var after         : Parser<P,Rii>;

  public function new(delegate,?pos:Pos){
    super(pos);
    this.delegate       = delegate; 
  }
  abstract function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>;

  @:privateAccess inline function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,Rii>,Noise>):Work{
    return cont.receive(this.delegate.toFletcher().forward(input).flat_fold(
      ok -> {
                after = through_bind(input,ok);
        return  after.toFletcher().forward(ok.asset);
      },
      no -> cont.error(no)
    ));
  }
  override public function toString(){
    var n = __.option(after).map(_ -> _.toString()).defv("?");
    return '$delegate => $n';
  }

}