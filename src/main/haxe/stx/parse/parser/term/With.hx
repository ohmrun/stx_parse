package stx.parse.parser.term;

using stx.parse.parser.term.With;

function log(wildcard:Wildcard){
  return stx.Log.ZERO.tag("stx/parse/parser/With");
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
      res -> {
        __.log().trace(_ -> _.pure(delegation.fst()));
        __.log().trace(_ -> _.pure(res));
        return res.is_ok().if_else(
          () -> delegation.snd().toFletcher().forward(res.asset).map(
            resI -> {
              __.log().trace(_ -> _.pure(delegation.snd()));
              __.log().trace(_ -> _.pure(resI.is_ok()));
              return resI.is_ok().if_else(
                () -> resI.error.is_fatal().if_else(
                  () -> resI.fails(),
                  () -> {
                    final result = transform(res.value.defv(null),resI.value.defv(null));
                    __.log().trace(_ -> _.pure(result));
                    return result.fold(
                      ok -> resI.asset.ok(ok),
                      () -> resI.asset.nil()
                    );
                  }
                ),
                () -> input.fail('with ${delegation.fst()} failed')
              );
            }
          ),
          () -> cont.value(input.fail('with ${delegation.snd()} failed'))
        );
      },
      err -> cont.error(err)
    );
    return cont.receive(b);
  }
  override public function toString(){
    return '${delegation.toString()}';
  }
}
