package stx.parse.test;

class ManyTest extends utest.Test{
  function cons(input:ParseInput<String>){
    return new stx.parse.parser.term.Many.ManyTask(
      Parser.Something(),
      input,
      @:privateAccess new Terminal()
    );
  }
  public function test_1(){
    var reader = 'a'.reader();
    var parser = cons(reader);
    trace(parser);
    trace('pursue');
    parser.pursue();
    trace(parser);
    trace('pursue');
    parser.pursue();
    trace(parser);
    trace('pursue');
    parser.pursue();
    trace(parser);
    trace('pursue');
    parser.pursue();
    trace(parser);
    trace('pursue');
    parser.pursue();
    trace(parser);
    trace('pursue');
    parser.pursue();
    parser.pursue();
    parser.pursue();
    parser.pursue();
    parser.pursue();
    trace(parser);
    trace(@:privateAccess parser.accum);
  }
	public function test_eof_ok(){
		var input 	= 'aa'.reader();
		var parser 	= __.parse().id('a').many().and_(Parser.Eof());
		var result  = parser.provide(input).fudge();
		trace(result);
		isTrue(result.ok());
  }
}