package stx.parse.parser.term;

using stx.parse.parser.term.OneMany;

class OneMany<P,R> extends With<P,R,Option<Array<R>>,Array<R>>{
  public function new(l:Parser<P,R>,?pos:Pos){
    super(l,Parsers.Many(l).option(),pos);
  }
  public function transform(lhs:Null<R>,rhs:Null<Option<Array<R>>>):stx.Option<Array<R>>{
    #if debug __.log().trace('$lhs $rhs'); #end
    return __.option(lhs).map(
      (oI:R) -> {
        var arr = [];
            arr.push(oI);
        for (a in __.option(rhs).flatten()){
          for (v in a){
            #if debug __.log().trace('$v'); #end
            arr.push(v);
          }
        }
        return arr;
      }
    ).or(
      () -> {
        return __.option(rhs).flat_map(x -> x);
      }
    );
  }
  override public function toString(){
    return 'OneMany($delegation)';
  }
} 