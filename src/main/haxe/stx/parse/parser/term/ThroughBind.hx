package stx.parse.parser.term;

abstract class ThroughBind<P,Ri,Rii> extends ParserCls<P,Rii>{
  var delegate      : Parser<P,Ri>;

  public function new(delegate,?pos:Pos){
    super(pos);
    this.delegate       = delegate; 
  }
  abstract function through_bind(input:Input<P>,result:ParseResult<P,Ri>):Parser<P,Rii>;

  @:privateAccess override inline function defer(input:Input<P>,cont:Terminal<ParseResult<P,Rii>,Noise>):Work{
    var later : FutureTrigger<Work> = Future.trigger();
    var inner = cont.inner(
      (outcome:Outcome<ParseResult<P,Ri>,Defect<Noise>>) -> 
        later.trigger(
          outcome.fold(
            ok -> through_bind(input,ok).toInternal().defer(input,cont),
            no -> Work.Unit()
          )
        )
    );
    return this.delegate.defer(input,inner).seq(later);
  }
  override inline function apply(input:Input<P>):ParseResult<P,Rii>{
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
}