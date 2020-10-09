package stx.parse.pack.parser.term;

class AndL<I,T,U> extends Base<I,T,Couple<Parser<I,T>,Parser<I,U>>>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?id){
    var lhs = __.that(id).exists().applyI(l);
    var rhs = __.that(id).exists().applyI(r);
    lhs.merge(rhs).crunch();
    super(__.couple(l,r),id);
    this.tag = switch([l.tag,r.tag]){
      case [Some(l),Some(r)]  : Some('($l) ($r)');
      default                 : None;
    }
  }
  override function check(){
    __.that().exists().crunch(delegation);
  }
  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,T>,Noise>){
    //trace(delegation.fst());
    return Arrowlet.Then(
      delegation.fst().forward(input),
      Arrowlet.Anon(
        (res:ParseResult<I,T>,cont) -> res.fold(
          (matchI) -> {
            //trace(delegation.fst());
            //trace(matchI.rest.offset);
            return delegation.snd().forward(matchI.rest).convert(
              Arrowlet.Anon(
                (res:ParseResult<I,U>,cont:Terminal<ParseResult<I,Couple<Option<T>,Option<U>>>,Noise>) -> res.fold(
                  (matchII) -> cont.value(matchII.rest.ok(__.couple(matchI.with,matchII.with))).serve(),
                  (e)       -> cont.value(e.toParseResult()).serve()
                )
              )
            ).prepare(cont);
          },
         (no) -> cont.value(no.toParseResult()).serve()
        )
      )
    ).postfix(opt_tu -> opt_tu.map_o( tu -> tu.fst())).prepare(Noise,cont);
  }
  
}