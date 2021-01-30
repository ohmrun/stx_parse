package stx.parse.parser.term;

class RepSep<I,O,S> extends Base<I,Array<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = Parser.Materialize(sep);
  }
  private inline function actual(){
    return delegation.and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:O,r:Array<O>) -> switch([l,r]){
          case [l,r]        : r.cons(l);
        }
      )
    ).asParser();
  }
  override public inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    return actual().defer(ipt,cont);
  }
  override public inline function apply(ipt:ParseInput<I>):ParseResult<I,Array<O>>{
    return actual().apply(ipt);
  }
} 
