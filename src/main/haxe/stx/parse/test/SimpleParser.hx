package stx.parse.test;


class SimpleParser{
  static public function test(){
    trace('test');
    var a = new SimpleParser();
        //a.testIdentitifierSuccess();
        //a.testOption();
        //a.testRegex();
        a.testRecur();
  }
  public function new(){

  }
  static var test_id = "test".identifier(); 
  function testIdentitifierSuccess(){
    var b = "test";
    var c = test_id.parse(b.reader());
    shouldSucceed(c);
    trace(c);
  }
  function testOption(){
    var b = "tes";
    var c = test_id.option().parse(b.reader());
    shouldSucceed(c);
  }
  function testRegex(){
    var b = "aaaa";
    var c = "a+".regex().parse(b.reader());
    shouldSucceed(c);
  }
  function shouldSucceed(v:ParseResult<Dynamic,Dynamic>){
    
  }
  function testRecur(){
    var t = "1+2+3x4x9x10";
    trace(t);
    var o = p_expr.parse(t.reader());
    trace(o);
    shouldSucceed(o);
  }
  static var p_int = "[0-9]+".regexParser().then(
    (x) -> Num(Std.parseInt(x))
  );
  static var p_star_id = "x".identifier();
  static var p_plus_id = "+".identifier();

  static var p_expr :Parser<String,Expr> = {
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