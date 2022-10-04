package stx.parse.parser.term;

class Head<I,O> extends Sync<I,O>{
  var delegate : I -> Option<Couple<O,Option<I>>>;
  public function new(delegate,?id:Pos){
    super(id);
    this.delegate = delegate;
  }
inline public function apply(ipt:ParseInput<I>){
    var head = ipt.head();    
    return head.fold(
      (ok:I) -> delegate(ok).fold(
          (ok:Couple<O,Option<I>>) -> ok.decouple(
            (o:O,i:Option<I>) -> i.fold(
              i   -> ipt.prepend(i),
              ()  -> ipt
            ).ok(o)
          ),
          () ->  ipt.no('no head')
        ),
      (e) -> e.toParseResult_with(ipt),
      ()  -> ipt.no('no head')
    );
  }
}
