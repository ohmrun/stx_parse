package stx.parse.pack.parser.term;

class With<I,T,U,V> extends Base<I,V,Couple<Parser<I,T>,Parser<I,U>>>{
  var transform  : T -> U -> V;
  public function new(l:Parser<I,T>,r:Parser<I,U>,transform,?id){
    var lhs = __.that(id).exists().applyI(l);
    var rhs = __.that(id).exists().applyI(r);
    lhs.merge(rhs).crunch();
    super(__.couple(l,r),id);
    this.transform  = transform;
    this.tag = switch([l.tag,r.tag]){
      case [Some(l),Some(r)]  : Some('($l) ($r)');
      default                 : None;
    }
  }
  override function check(){
    __.that().exists().crunch(delegation);
  }
  override function do_parse(input:Input<I>){
    return delegation.fst().parse(input).fold(
      (matchI) -> delegation.snd().parse(matchI.rest).fold(
        (matchII) -> ParseResult.success(
          ParseSuccess.make(matchII.rest,transform(matchI.with, matchII.with))
        ),
        ParseResult.failure
      ),
      ParseResult.failure
    );
  }
  
}