package stx.parse.pack.parser.term;

class Rep1Sep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  override public function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>){
    return delegation.and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:O,r:Array<O>) -> r.cons(l)
      )
    ).asParser().applyII(ipt,cont);
  }
}