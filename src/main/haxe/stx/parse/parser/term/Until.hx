package stx.parse.parser.term;

class Until<P,R> extends Base<P,Cluster<R>,Parser<P,R>>{
  public function new(delegation:Parser<P,R>,?tag:Option<String>,?pos:Pos){
    super(delegation,tag,pos);
  }
  public function apply(ipt:ParseInput<P>):ParseResult<P,Cluster<R>>{
    final result = [];
    function rec(ipt:ParseInput<P>){
      final res = delegation.apply(ipt);
      return switch(res.is_ok()){
        case true : 
          for (v in res.value){
            result.push(v);
          }
          rec(res.asset);
        case false : 
          switch(result.length == 0){
            case true  : res.asset.erration("Until coming up empty").failure(res.asset);
            case false : res.asset.ok(Cluster.lift(result));
          }
      }
    }
    return rec(ipt);
  }
}