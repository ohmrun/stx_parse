package stx.parse.parser.term;

using stx.parse.parser.term.OneMany;

function log(wildcard:Wildcard){
  return stx.parse.Log.log(wildcard).tag('stx.parse.OneMany');
}
class OneMany<P,R> extends With<P,R,Array<R>,Array<R>>{
  public function new(l:Parser<P,R>,?pos:Pos){
    super(l,Parser.Many(l),pos);
  }
  override public function transform(lhs:Null<R>,rhs:Null<Array<R>>):stx.Option<Array<R>>{
    return __.option(lhs).map(
      (oI:R) -> [oI].concat(__.option(rhs).defv([]))
    );
  }
} 