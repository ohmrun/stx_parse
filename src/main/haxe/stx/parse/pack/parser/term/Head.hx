package stx.parse.pack.parser.term;

class Head<I,O> extends Sync<I,O>{
  var delegate : I -> Option<Couple<O,Option<I>>>;
  public function new(delegate,?id:Pos){
    super(id);
    this.delegate = delegate;
  }
  override inline public function apply(ipt:Input<I>){
    var head = ipt.head();
    var next = head.flat_map(delegate);
    
    return next.fold(
      ok -> ok.decouple(
        (o:O,i) -> i.fold(
          i   -> ipt.prepend(i),
          ()  -> ipt
        ).ok(o)
      ),
      () -> ipt.fail('no match')
    );
  }
}