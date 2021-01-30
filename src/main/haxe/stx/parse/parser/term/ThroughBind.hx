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
    return this.delegate.defer(input,cont.joint(
      (outcome:Outcome<ParseResult<P,Ri>,Defect<Noise>>) -> 
          outcome.fold(
            ok -> {
                      after = through_bind(input,ok);
              return  after.toInternal().defer(ok.rest,cont);
            },
            no -> Work.ZERO
          )
    ));
  }
  inline function apply(input:ParseInput<P>):ParseResult<P,Rii>{
    var result = delegate.apply(input);
    var next   = through_bind(input,result);
    return next.apply(result.rest);
  }
  override function get_convention(){
    return this.delegate.convention;
  }
  override public function toString(){
    var n = __.option(after).map(_ -> _.toString()).defv("?");
    return '$delegate => $n';
  }

}