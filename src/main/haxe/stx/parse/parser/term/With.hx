package stx.parse.parser.term;

using stx.parse.parser.term.With;

function log(wildcard:Wildcard){
  return stx.Log.ZERO.tag("stx.parse.With");
}

abstract class With<I,T,U,V> extends Base<I,V,Couple<Parser<I,T>,Parser<I,U>>>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?pos:Pos){
    __.assert().exists(l);
    __.assert().exists(r);
    //__.log().debug('${l} ${r}');
    //__.log().debug('${l.tag} ${r.tag}');
    super(__.couple(l,r),pos);
  }
  abstract public function transform(lhs:Null<T>,rhs:Null<U>):Option<V>;
  override function check(){
    __.that().exists().crunch(delegation);
  }
  override inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,V>,Noise>){  
    __.log()('\nlhs:${delegation.fst()}\nrhs:${delegation.snd()}\ninput:$input');
    var fst_res : Terminal<ParseResult<I,T>,Noise> = null;
    var snd_res : Terminal<ParseResult<I,U>,Noise> = null;
    return delegation.fst().toFletcher()(
      input,
      fst_res = cont.joint(
        (outcome:Outcome<ParseResult<I,T>,Defect<Noise>>) -> {
          //__.assert().exists(outcome);
          return fst_res.issue(outcome).serve().seq(
            outcome.fold(
              result -> {
                //__.assert().exists(result);
                __.log()('\n\tlhs: ${result.rest.index} ${result.value()} ${this.delegation.fst()}');
                return result.fold(
                  (ok) -> delegation.snd().toFletcher().receive(ok.rest).apply(
                      (outcomeI:Outcome<ParseResult<I,U>,Defect<Noise>>) -> {
                        return outcomeI.fold(
                          (result) -> {
                            __.log()('\n\t\trhs: ${result.rest.index} ${result.value()} ${this.delegation.snd()}');
                            return result.fold(
                              (okI) -> {
                                var result = transform(ok.with.defv(null),okI.with.defv(null));
                                return cont.value(
                                  result.map(z -> okI.rest.ok(z)).defv(okI.rest.nil())
                                ).serve();
                              },
                                (no)  -> cont.value(no.toParseResult()).serve()
                              );
                            },
                            error -> cont.error(error).serve()
                          );
                      }
                  ),  
                  (no) -> cont.value(no.toParseResult()).serve()
                );
              },
              error  -> cont.error(error).serve()          
            )
          );
        }
      )
    );
  }
  // private function mod(lhs:Outcome<ParseResult<I,T>,Defect<Noise>>,rhs:Outcome<ParseResult<I,T>,Defect<Noise>>){
  //   return lhs.
  // }
  inline public function apply(input:ParseInput<I>):ParseResult<I,V>{
    return throw "SDFSDGF";
    // return delegation.fst().apply(input).fold(
    //   (ok) -> delegation.snd().apply(ok.rest).fold(
    //     (okI) -> transform(ok.with.defv(null),okI.with.defv(null)).map( z -> okI.rest.ok(z)).def(okI.rest.nil),
    //     (no)  -> no.tack(input).toParseResult()
    //   ),
    //   (no)  -> no.tack(input).toParseResult()
    // );
  }
  override public function toString(){
    return '${delegation.toString()}';
  }
}
