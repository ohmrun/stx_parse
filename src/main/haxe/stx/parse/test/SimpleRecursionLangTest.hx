package stx.parse.test;

class SimpleRecursionLangTest extends utest.Test{
  public function test_one(async:utest.Async){
    var reader = '1+2'.reader();
    Lang.p_expr.provide(reader).environment(
      (x) -> {
        //trace(x);
        async.done();
      }
    ).crunch();
  }
  public function test_recur(){
    var t   = "1+2+3x4x9x10";
    var t0  = haxe.Timer.stamp();
    var o   = Lang.p_expr.provide(t.reader()).fudge();
    trace(haxe.Timer.stamp() - t0);
    //trace(o);
    isTrue(true);
    //Some(Mult(Num(3),Mult(Num(4),Mult(Num(9),Num(10)))))
  }
}

private class Lang{
  static public var p_int     = "[0-9]+".regexParser().then((x) -> Num(Std.parseInt(x)));
  //static public var p_int     = Parser.Range(48,57).then((x) -> Num(Std.parseInt(x)));
  static public var p_star_id = "x".identifier();
  static public var p_plus_id = "+".identifier();

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