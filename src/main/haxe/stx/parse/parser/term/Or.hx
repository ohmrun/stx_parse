package stx.parse.parser.term;
class Or<P,R> extends ThroughBind<P,R,R>{
  var rhs : Parser<P,R>;

  public function new(lhs,rhs,?pos:Pos){
    super(lhs,pos);
    this.rhs = rhs;
    this.tag = switch([lhs.tag,rhs.tag]){
      case [Some(l),Some(r)]  : Some('$l || $r');
      default                 : None;
    }
  }
  override function through_bind(input:ParseInput<P>,result:ParseResult<P,R>):Parser<P,R>{
    return result.fold(
      ok -> Parser.Stamp(result),
      no -> rhs
    );
  }
}      