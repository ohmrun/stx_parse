package stx.parse.parser.term;

class Position<Ri> extends ThroughBind<String,Ri,Ri>{
  public function new(delegate,?pos){
    super(delegate,pos);
  }
  function through_bind(input:ParseInput<String>,result:ParseResult<String,Ri>):Parser<String,Ri>{
    final result = new PositionReport(@:privateAccess result.asset.content.index,'error').asParser().apply(input.copy(@:privateAccess input.content.zero()));
    return new Stamp(result).asParser();
  }
} 