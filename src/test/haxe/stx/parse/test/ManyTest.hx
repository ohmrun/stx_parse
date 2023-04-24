package stx.parse.test;

class ManyTest extends TestCase{
  // function cons(input:ParseInput<String>){
  //   return new stx.parse.parser.term.Many.ManyTask(
  //     Parser.Something(),
  //     input,
  //     @:privateAccess new Terminal()
  //   );
  // }
  // public function test_1(){
  //   var reader = 'a'.reader();
  //   var parser = cons(reader);
  //   trace(parser);
  //   trace('pursue');
  //   parser.pursue();
  //   trace(parser);
  //   trace('pursue');
  //   parser.pursue();
  //   trace(parser);
  //   trace('pursue');
  //   parser.pursue();
  //   trace(parser);
  //   trace('pursue');
  //   parser.pursue();
  //   trace(parser);
  //   trace('pursue');
  //   parser.pursue();
  //   trace(parser);
  //   trace('pursue');
  //   parser.pursue();
  //   parser.pursue();
  //   parser.pursue();
  //   parser.pursue();
  //   parser.pursue();
  //   trace(parser);
  //   trace(@:privateAccess parser.accum);
  // }
	public function test_eof_ok(){
		var input 	= 'aa'.reader();
		var parser 	= SParse.id('a').many().and_(Parsers.Eof());
		var result  = parser.apply(input);
		for(x in result.value){
      same(['a','a'].imm(),x);
    }
		//is_true(result.is_ok());
  }
  public function test_success_none(){
		var input 	= ''.reader();
		var parser 	= SParse.id('a').many().and_(Parsers.Eof());
		var result  = parser.apply(input);
		same(None,result.value);
  }
  public function test_failure_fatal(){
    var input 	= ''.reader();
		var parser 	= Parsers.Anon((ipt) -> ipt.no("noes",true),Some("FATAL")).many();
		var result  = parser.apply(input);
    var error   = result.error.toIterable().toIter().map_filter(x -> x.data.flat_map(y -> y.external()));
    for(e in error){
      alike(E_Parse_ParseFailed(null),e.msg);
    }
  }
}