package stx.parse.pack.parser.term;

class Or<I,O> extends Base<I,O,Couple<Parser<I,O>,Parser<I,O>>>{
  public function new(fst,snd,?id){
    super(
      __.couple(fst,snd),
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
  override function doApplyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return Arrowlet.Then(
      delegation.fst(),
      Arrowlet.Anon(
        (res:ParseResult<I,O>,cont:Terminal<ParseResult<I,O>,Noise>) -> 
          res.fold(
            (ok) -> cont.value(ParseResult.success(ok)).serve(),
            (no) -> no.is_fatal() ? cont.value(no.tack(ipt)).serve() : delegation.snd().applyII(ipt,cont) 
          )         
      )
    ).applyII(ipt,cont);
  }
}