package com.mindrocks.text.parsers;

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
      var res = p.parse(ipt);
      switch (res) {
        case Success(_, _)        : return res;
        case Failure(_, _, false) :
        case Failure(_,_,_)       :return res;
      };
      pIndex = pIndex+1;
    }
    return failed("none match".errorAt(ipt).newStack(), ipt, false);
  }

}