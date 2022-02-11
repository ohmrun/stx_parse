package stx.parse.parser.term;

using stx.parse.parser.term.With;

abstract class With<I,T,U,V> extends Base<I,V,Couple<Parser<I,T>,Parser<I,U>>>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?pos:Pos){
    #if debug
    __.assert().exists(l);
    __.assert().exists(r);
    #end
    //__.log().debug(_ -> _.thunk(() -> '${l} ${r}'));
    //__.log().debug(_ -> _.thunk(() -> '${l.tag} ${r.tag}'));
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
        __.log().trace(_ -> _.thunk(
          () -> {
            final parser = delegation.fst().toString();
            final result = () -> res.toString();
            return 'lh parser: $parser result: $result';
          }
        ));
        return res.is_ok().if_else(
          () -> delegation.snd().toFletcher().forward(res.asset).map(
            resI -> {
              __.log().trace(_ -> _.thunk(
                () -> {
                  final parser = delegation.snd().toString();
                  final result = resI.toString();
                  return 'rh parser: $parser result: $result';
                }
              ));
              return resI.is_ok().if_else(
                () -> resI.is_fatal().if_else(
                  () -> resI.fails(),
                  () -> {
                    final result = transform(res.value.defv(null),resI.value.defv(null));
                    __.log().trace(_ -> _.thunk(() -> {
                      var parsers = '${delegation.tup()}';
                      return 'parsers: $parsers, result: $result';
                    }));
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
