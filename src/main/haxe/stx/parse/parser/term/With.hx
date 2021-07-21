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
  inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,V>,Noise>){  
    var a = delegation.fst().toFletcher().forward(input);
    var b = a.flat_fold(
      res -> res.ok().if_else(
        () -> delegation.snd().toFletcher().forward(res.rest).map(
          resI -> resI.ok().if_else(
            () -> resI.fold(
              success -> {
                final result = transform(res.with.defv(null),success.with.defv(null));
                return ParseResult.success(ParseSuccess.make(success.rest,result));
              },
              failure -> ParseResult.failure(failure)
            ),
            () -> input.fail('with ${delegation.fst()} failed')
          )
        ),
        () -> cont.value(input.fail('with ${delegation.snd()} failed'))
      ),
      err -> cont.error(err)
    );
    return cont.receive(b);
  }
  override public function toString(){
    return '${delegation.toString()}';
  }
}
