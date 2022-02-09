package stx.parse.parser.term;

class Rep1Sep<I,O,S> extends Base<I,Cluster<O>,Parser<I,O>>{
  var sep : Parser<I,S>;
  public function new(delegate,sep:Parser<I,S>,?pos){
    super(delegate,pos);
    this.sep = sep;
  }
  private inline function actual():Parser<I,Cluster<O>>{
    return delegation.and(
      sep._and(delegation.option()).many()
    ).then(
      __.decouple(
        (l:O,r:Cluster<Option<O>>) -> r.flat_map(opt -> opt.toArray()).cons(l)
      )
    ).asParser();
  }
  inline public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,Cluster<O>>,Noise>){
    return actual().defer(ipt,cont);
  }
  override public function toString(){
    return 'Rep1Sep($delegation,$sep)';
  } 
} 