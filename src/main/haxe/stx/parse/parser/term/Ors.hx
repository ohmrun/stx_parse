package stx.parse.parser.term;

class Ors<I,T> extends Base<I,T,Array<Parser<I,T>>>{
  public function new(delegation,?id:Pos){
    super(delegation,id);
  }
  override function check(){
    for(delegate in delegation){
      if(delegate == null){  throw('undefined parse delegate in $delegate'); }
    }
  }
  override function defer(input:Input<I>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
    var idx = 1;
    return Arrowlet.Then(
      delegation[0],
      Arrowlet.Anon(
        function rec(res:ParseResult<I,T>,cont:Terminal<ParseResult<I,T>,Noise>):Work{
          return res.fold(
            (ok) -> cont.value(ParseResult.success(ok)).serve(),
            (no) -> no.is_fatal().if_else(
              () -> cont.value(ParseResult.failure(no)).serve(),
              () -> 
                if(idx < delegation.length){
                  var n = idx;
                  idx   = idx + 1;
                  var d = delegation[n];
                  Arrowlet.Then(d,Arrowlet.Anon(rec)).toInternal().defer(input,cont);//TODO can a failure consume?
                }else{
                  var opts = delegation.map(_ -> _.tag);
                  cont.value(no.rest.fail('Ors $opts',false,pos)).serve();
                }
            )
          );
        }
      )
    ).toInternal().defer(input,cont);
  }
  override inline function apply(ipt:Input<I>):ParseResult<I,T>{
    return throw  E_Arw_IncorrectCallingConvention;
  }
}