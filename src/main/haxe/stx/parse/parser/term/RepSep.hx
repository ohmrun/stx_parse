package stx.parse.parser.term;


class RepSep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  private inline function actual(){
    return delegation.option().and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:Option<O>,r:Array<O>) -> switch([l,r]){
          case [Some(l),r] : r.cons(l);
          case [None,_]    : [];
        }
      )
    ).asParser();
  }
  override public inline function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    return actual().defer(ipt,cont);
  }
  override public inline function apply(ipt:Input<I>):ParseResult<I,Array<O>>{
    return actual().apply(ipt);
  }
}