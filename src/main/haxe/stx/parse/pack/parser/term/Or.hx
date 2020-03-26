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
  override function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return delegation.fst().parse(ipt).fold(
      ParseResult.success,
      (err)       -> err.is_fatal() ? ParseResult.failure(err) : delegation.snd().parse(ipt) 
    );
  }
}