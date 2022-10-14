package stx.parse.parser.term;

abstract class FlatMap<P,Ri,Rii> extends ThroughBind<P,Ri,Rii>{
  public function new(delegate,?pos:Pos){
    super(delegate,pos);
  }
  abstract function flat_map(rI:Ri):Parser<P,Rii>;
  function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>{
    return result.has_error().if_else(
      () -> new Stamp(ParseResult.fromEquity(result.clear())).asParser(),
      () -> __.option(result.value).flat_map(x -> x).fold(
        ok -> flat_map(ok),
        () -> Parsers.Stamp(input.no('FAIL'))
      )
    );
  }
}