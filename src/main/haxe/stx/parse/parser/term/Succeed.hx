package stx.parse.parser.term;

class Succeed<P,R> extends SyncBase<P,R,R>{
  public function new(value:R,?pos:Pos){
    __.assert().exists(value);
    super(value,pos);
  }
  @:noUsing static inline public function pure<P,R>(r:R):Parser<P,R>{
    return new Succeed(r).asParser();
  }
  override inline function apply(ipt:ParseInput<P>):ParseResult<P,R>{
    return ipt.ok(this.delegation);
  }
}