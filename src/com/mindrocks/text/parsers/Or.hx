package com.mindrocks.text.parsers;

class Or<I,O> extends Base<I,O,Tuple2<Parser<I,O>,Parser<I,O>>>{
  public function new(fst,snd,?id){
    super(
      tuple2(fst,snd),
      id
    );
    this.tag = switch([fst.tag,snd.tag]){
      case [Some(l),Some(r)]  : Some('$l || $r');
      default                 : None;
    }
  }
  override public function check(){
    if(delegation == null){  throw('undefined parse delegate'); }
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return delegation.fst().parse(ipt).sfold(
      (res,_,_)     -> res,
      (res,_,_,er)  -> er? res : delegation.snd().parse(ipt) 
    );
  }
}