package stx.parse.parser.term;

class Until<P,R> extends Base<P,Cluster<R>,Parser<P,R>>{
  public function new(delegation:Parser<P,R>,?tag:Option<String>,?pos:Pos){
    super(delegation,tag,pos);
  }
  public function defer(ipt:ParseInput<P>,cont:Terminal<ParseResult<P,Cluster<R>>,Noise>):Work{
    final result = [];
    function rec(ipt:ParseInput<P>){
        return delegation.toFletcher().forward(ipt).flat_map(
          (res:ParseResult<P,R>) -> {
            return res.is_ok().if_else(
              () -> {
                for (v in res.value){
                  result.push(v);
                }
                return Receiver.defer(rec.bind(res.asset));
              },
              () -> (result.length == 0).if_else(
                () -> Receiver.issue(Success(res.asset.fail("Until coming up empty"))),
                () -> Receiver.issue(Success(res.asset.ok(Cluster.lift(result))))
              )
            );
          }
      );
    }
    return cont.receive(rec(ipt));
  }
}