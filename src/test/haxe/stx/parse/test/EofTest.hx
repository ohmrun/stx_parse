package stx.parse.test;

class EofTest extends TestCase{
  
  public function test_succeed(){
    final ipt     = "";
    final prs     = Parsers.Eof();
    final result  = prs.apply(ipt.reader());
    same(None,result.value);
  }
  
  public function test_failure(){
    final ipt = "x";
    final prs = Parsers.Eof();
    final out = prs.apply(ipt.reader());
    final err = out.error.toIterable().toIter().map_filter(e -> e.data.flat_map(x -> x.exterior())).head();
    for(e in err){
      same(E_Parse_NotEof,e.msg);
    }
  }
  public function test_consume_then_eof(){
    final ipt = "x";
    final prs = Parsers.Something()._and(Parsers.Eof());
    final out = prs.apply(ipt.reader()).toChunk();
    same(Tap,out);
  }
}