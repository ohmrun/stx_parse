package stx.parse.parser.term;


//TODO Broken
class Ors<I,T> extends Base<I,T,Array<Parser<I,T>>>{
  public function new(delegation,?id:Pos){
    super(delegation,id);
  }
  override function check(){
    for(delegate in delegation){
      __.assert().exists(delegate);
    }
  }
  public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
    var idx = 1;
    return Fletcher.Then(
      delegation[0],
      Fletcher.Anon(
        function rec(res:ParseResult<I,T>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
          return res.is_ok().if_else(
            () -> cont.receive(cont.value(res)),
            () -> res.is_fatal().if_else(
              () -> cont.receive(cont.value(res)),
              () -> 
                if(idx < delegation.length){
                  var n = idx;
                  idx   = idx + 1;
                  var d = delegation[n];
                  __.log().trace('${res.asset.index} $d');
                  Fletcher.Then(d,Fletcher.Anon(rec))(input,cont);//TODO can a failure consume?
                }else{
                  var opts = delegation.map(_ -> _.tag);
                  cont.receive(cont.value(res.asset.fail('Ors $opts',false)));
                }
            )
          );
        }
      )
    )(input,cont);
  }
}