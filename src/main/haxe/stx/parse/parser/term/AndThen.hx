package stx.parse.parser.term;

class AndThen<P,Ri,Rii> extends ThroughBind<P,Ri,Rii>{
  var flat_map  : Ri->Parser<P,Rii>;

  public function new(delegation,flat_map,?pos:Pos){
    super(delegation,pos);
    this.flat_map  = flat_map;
  }
  //TODO what about the nil() case
  function through_bind(input:ParseInput<P>,result:ParseResult<P,Ri>):Parser<P,Rii>{
    return result.is_ok().if_else(
      ()  -> result.value.map(flat_map).defv(Parser.Stamp(result.asset.nil())),
      ()  -> Parser.Stamp(result.fails())
    );
  }
}