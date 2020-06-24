package stx.parse.pack.parser.term;

class Ors<I,T> extends Base<I,T,Array<Parser<I,T>>>{
  public function new(delegation,?id){
    super(delegation,id);
  }
  override function check(){
    for(delegate in delegation){
      if(delegate == null){  throw('undefined parse delegate in $delegate'); }
    }
  }
  override function do_parse(ipt){
    var pIndex = 0;
    while (pIndex < delegation.length) {
      var p   = delegation[pIndex];
      if(p == null){
        //p = '${delegation.length} $pIndex'.fail(true);
      }
      //trace(p);
      var res = p.parse(ipt);
      //trace(res);
      switch (res) {
        case Success(_)                       : return res;
        case Failure(_.is_fatal() => false)   :
        case Failure(_)                       : return res;
      };
      pIndex = pIndex+1;
    }
    return ipt.fail("None Match",false,id);
  }
}