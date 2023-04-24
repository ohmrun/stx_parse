package stx.parse.test;

function id(s:String){
  return __.parse().parsers().string().id(s);
}
class PositionTest extends TestCase{
  public function test(){
    final data = 'abc \n1234\nmuddy water'.reader();
    final parser = 
      id('abc')
        .and_(SParse.whitespace)
        .and_(id('\n'))
        .and(id('1234'))
        .and_(id("\n"))
        .and(id('muddy'))
        .and(Parsers.Position(id('shoes')));

    final result = parser.apply(data);
    trace(result);
    // for(i in result.value){
    //   i.decouple((x,y) -> trace('$x $y'));
    // }
  }
}