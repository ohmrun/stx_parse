package stx.parse.parser.term;

abstract class FlatMap<P,Ri,Rii> extends ThroughBind<P,Ri,Rii>{
  public function new(delegate,?pos:Pos){
    super(delegate,pos);
  }
  abstract function flat_map(rI:Ri):Parser<P,Rii>;
  override function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>{
    return result.fold(
      (ok:ParseSuccess<P,Ri>) -> ok.with.map(flat_map).defv(Parser.Stamp(ok.rest.fail('FAIL'))),
      (no)                    -> Parser.Stamp(__.failure(no))
    );
  }
}