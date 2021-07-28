package stx.parse.parser.term;

using stx.parse.parser.term.OneMany;

class OneMany<P,R> extends With<P,R,Option<Array<R>>,Array<R>>{
  public function new(l:Parser<P,R>,?pos:Pos){
    super(l,Parser.Many(l).option(),pos);
  }
  public function transform(lhs:Null<R>,rhs:Null<Option<Array<R>>>):stx.Option<Array<R>>{
    return __.option(lhs).map(
      (oI:R) -> {
        var arr = [];
            arr.push(oI);
        for (a in __.option(rhs).flatten()){
          for (v in a){
            arr.push(v);
          }
        }
        return arr;
      }
    );
  }
  override public function toString(){
    return '$delegation+';
  }
} 