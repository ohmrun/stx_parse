package stx.parse.parser.term;

class AndThen<P,Ri,Rii> extends ThroughBind<P,Ri,Rii>{
  var flat_map  : Ri->Parser<P,Rii>;

  public function new(delegation,flat_map,?pos:Pos){
    super(delegation,pos);
    this.flat_map  = flat_map;
  }
  function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>{
    return result.fold(
      (ok:ParseSuccess<P,Ri>) -> ok.with.map(flat_map).defv(Parser.Stamp(ok.rest.fail('FAIL'))),
      (no)                    -> Parser.Stamp(__.failure(no))
    );
  }
}