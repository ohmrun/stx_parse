package stx.parse.parser.term;

abstract class ThroughBind<P,Ri,Rii> extends ParserCls<P,Rii>{
  var delegate      : Parser<P,Ri>;
  var after         : Parser<P,Rii>;

  public function new(delegate,?pos:Pos){
    super(pos);
    this.delegate       = delegate; 
  }
  abstract function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>;

  @:privateAccess override inline function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,Rii>,Noise>):Work{
    return this.delegate.defer(input,cont.joint(
      (outcome:Outcome<ParseResult<P,Ri>,Defect<Noise>>) -> 
          outcome.fold(
            ok -> {
                      after = through_bind(input,ok);
              return  after.toInternal().defer(input,cont);
            },
            no -> Work.ZERO
          )
    ));
  }
  override inline function apply(input:ParseInput<P>):ParseResult<P,Rii>{
    return this.convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> {
        var next = through_bind(input,delegate.apply(input));
        return next.convention.fold(
          ()  -> throw E_Arw_IncorrectCallingConvention,
          ()  -> next.apply(input) 
        );
      }
    );
  }
  override function get_convention(){
    return this.delegate.convention;
  }
  override public function toString(){
    var n = __.option(after).map(_ -> _.toString()).defv("?");
    return '${name()}($delegate => $n)';
  }

}