package stx.parse.pack.parser.term;

abstract class With<I,T,U,V> extends Base<I,V,Couple<Parser<I,T>,Parser<I,U>>>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?pos:Pos){
    __.assert().exists(l);
    __.assert().exists(r);
    __.log().debug('${l} ${r}');
    __.log().debug('${l.tag} ${r.tag}');
    super(__.couple(l,r),pos);
    this.tag = switch([l.tag,r.tag]){
      case [Some(l),Some(r)]  : Some('($l) ($r)');
      default                 : None;
    }
  }
  abstract public function transform(lhs:Null<T>,rhs:Null<U>):Option<V>;
  override function check(){
    __.that().exists().crunch(delegation);
  }
  override inline public function defer(input:Input<I>,cont:Terminal<ParseResult<I,V>,Noise>){  
    return delegation.fst().toInternal().defer(
      input,
      cont.joint(
        (outcome:Outcome<ParseResult<I,T>,Defect<Noise>>) -> outcome.fold(
          result -> result.fold(
            (ok) -> delegation.snd().toInternal().defer(
              ok.rest,
              cont.joint(
                (outcomeI:Outcome<ParseResult<I,U>,Defect<Noise>>) -> outcomeI.fold(
                  (result) -> result.fold(
                    (okI) -> cont.value(
                        transform(ok.with.defv(null),okI.with.defv(null))
                        .map(
                          (z) -> okI.rest.ok(z)
                        ).defv(okI.rest.nil())
                    ).serve(),
                    (no)  -> cont.value(
                        no.tack(input).toParseResult()
                    ).serve()
                  ),
                  error -> cont.error(error).serve()
                )
              )  
            ),
            (no) -> cont.value(no.toParseResult()).serve()
            ),
          error  -> cont.error(error).serve()
        )
      )
    );
  }
  // private function mod(lhs:Outcome<ParseResult<I,T>,Defect<Noise>>,rhs:Outcome<ParseResult<I,T>,Defect<Noise>>){
  //   return lhs.
  // }
  override inline public function apply(input:Input<I>):ParseResult<I,V>{
    return delegation.fst().apply(input).fold(
      (ok) -> delegation.snd().apply(ok.rest).fold(
        (okI) -> transform(ok.with.defv(null),okI.with.defv(null)).map( z -> okI.rest.ok(z)).def(okI.rest.nil),
        (no)  -> no.tack(input).toParseResult()
      ),
      (no)  -> no.tack(input).toParseResult()
    );
  }
  override public function get_convention(){
    return delegation.fst().convention || delegation.snd().convention;
  }
}