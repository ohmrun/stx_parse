package stx.parse.parser.term;

class Rep1Sep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  private inline function actual():Parser<I,Array<O>>{
    return delegation.and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:O,r:Array<O>) -> r.cons(l)
      )
    ).asParser();
  }
  override inline public function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>){
    return actual().defer(ipt,cont);
  }
  override inline public function apply(ipt:Input<I>):ParseResult<I,Array<O>>{
    return actual().apply(ipt);
  }
}