package stx.parse.pack.parser.term;

class With<I,T,U,V> extends Base<I,V,Couple<Parser<I,T>,Parser<I,U>>>{
  var transform  : T -> U -> V;
  public function new(l:Parser<I,T>,r:Parser<I,U>,transform,?id){
    var lhs = __.that(id).exists().applyI(l);
    var rhs = __.that(id).exists().applyI(r);
    lhs.merge(rhs).crunch();
    super(__.couple(l,r),id);
    this.transform  = transform;
    this.tag = switch([l.tag,r.tag]){
      case [Some(l),Some(r)]  : Some('($l) ($r)');
      default                 : None;
    }
  }
  override function check(){
    __.that().exists().crunch(delegation);
  }
  override public function doApplyII(input:Input<I>,cont:Terminal<ParseResult<I,V>,Noise>){  
    return Process.lift(Arrowlet.Then(
      delegation.fst(),
      Arrowlet.Anon(
        (res:ParseResult<I,T>,cont:Terminal<ParseResult<I,Couple<T,U>>,Noise>) -> res.fold(
          (ok) -> delegation.snd().forward(ok.rest).process(
            (resI:ParseResult<I,U>) -> resI.fold(
              okI -> ok.with.zip(okI.with).map(okI.rest.ok).defv(input.fail('With')),
              no  -> ParseResult.failure(no)
            )
          ).prepare(cont),
          no -> cont.value(ParseResult.failure(no)).serve()
        )
      )
    )).process(
      Process.fromFun1R((res:ParseResult<I,Couple<T,U>>) -> res.map(__.decouple(transform)))
    ).forward(input).prepare(cont);
  }
}