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
  inline public function apply(input:ParseInput<I>):ParseResult<I,V>{  
    var res = delegation.fst().apply(input);
    // __.log().trace(_ -> _.thunk(
    //   () -> {
    //     final parser = delegation.fst().toString();
    //     final result = () -> res.toString();
    //     return 'lh parser: $parser result: ${result()} ${res.is_ok()} $this';
    //   }
    // ));
    //#end
    return switch(res.is_ok()){
      case true: 
        __.assert().exists(delegation);
        __.assert().exists(delegation.snd());
        final resI = delegation.snd().apply(res.asset);
        #if debug
        __.log().trace(_ -> _.thunk(
          () -> {
            final parser = delegation.snd().toString();
            final result = resI.toString();
            return 'rh parser: $parser result: $result $this';
          }
        ));
        #end
        switch(resI.is_ok()){
          case true : 
            final result = transform(res.value.defv(null),resI.value.defv(null));
            #if debug
            __.log().trace(_ -> _.thunk(() -> {
              var parsers = '${delegation.tup()}';
              return 'parsers: $parsers, result: $result';
            }));
            #end
            switch(result){
              case Some(x)  : resI.asset.ok(x);
              case None     : resI.asset.nil();
            }
          case false : 
            switch(resI.is_fatal()){
              case true   : resI.fails(); 
              case false  : resI.error.concat(input.erration(E_Parse_ParseFailed('With lhs'))).failure(input);
            }
        }
      case false : 
        input.erration(E_Parse_ParseFailed('With')).concat(res.error).failure(input);
    }  
  }
  override public function toString(){
    return '${delegation.toString()}';
  }
}
