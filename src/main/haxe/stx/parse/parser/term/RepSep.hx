package stx.parse.parser.term;

class RepSep<I,O,S> extends Base<I,Cluster<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = Parsers.Materialize(sep);
  }
  private inline function actual(){
    return delegation.and(
      sep._and(delegation).many()
    ).then(
      __.decouple(
        (l:O,r:Cluster<O>) -> switch([l,r]){
          case [l,r]        : r.cons(l);
        }
      )
    ).asParser();
  }
  public inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,Cluster<O>>,Noise>):Work{
    return actual().defer(ipt,cont);
  }
} 
