package stx.parse.test;

class SimpleRecursionLangTest extends TestCase{
  public function test_one(){
    var reader = '1+2'.reader();
    Lang.p_expr.provide(reader).environment(
      (x) -> {
        trace(x);
        __.log().debug(_ -> _.pure(x));
        same(
          x.value.defv(null),
          Plus(Num(1),Num(2))
        );
        //async.done();
      }
    ).crunch();
  }
  public function _test_recur(async:Async){
    var t   = "1+2+3x4x9x10";
    //var t0  = haxe.Timer.stamp();
    Lang.p_expr.provide(t.reader()).environment(
      (x) -> {
        __.log().debug(_ -> _.show(x.value));
        trace('done');
        async.done();
      }
    ).submit();
    //__.log().info(haxe.Timer.stamp() - t0);
    //__.log().info(o);
    
    //same(Plus(Num(1),Plus(Num(2),Mult(Num(3),Mult(Num(4),Mult(Num(9),Num(10)))))),o.value().defv(null));
  }
}

private class Lang{
  static public var p_int     = Parser.Regex("[0-9]+").then((x) -> Num(Std.parseInt(x)));
  //static public var p_int     = Parser.Range(48,57).then((x) -> Num(Std.parseInt(x)));
  static public var p_star_id = __.parse().id("x");
  static public var p_plus_id = __.parse().id("+");

  static public var p_expr :Parser<String,Expr> = {
    [
        p_mult.defer(),
        p_plus.defer(),
        p_int
    ].ors().memo();
  }
  static function p_mult(){
    return 
      p_expr
      .and_(p_star_id)
      .and(p_expr)
      .then((tp) -> Mult(tp.fst(),tp.snd()));
  }
  static function p_plus(){
    return 
      p_expr
      .and_(p_plus_id)
      .and(p_expr)
      .then((tp) -> Plus(tp.fst(),tp.snd()));
  }
}
enum Expr{
  Mult(l:Expr,r:Expr);
  Plus(l:Expr,r:Expr);
  Num(v:Int);
}