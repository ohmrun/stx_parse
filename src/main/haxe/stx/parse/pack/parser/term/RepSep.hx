package stx.parse.pack.parser.term;


class RepSep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  override private function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>){
    return delegation.option().and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:Option<O>,r:Array<O>) -> switch([l,r]){
          case [Some(l),r] : r.cons(l);
          case [None,_]    : [];
        }
      )
    ).asParser().applyII(ipt,cont);
  }
}