package stx.parse.pack.parser.term;

class AndL<I,T,U> extends With<I,T,U,T>{
  public function new(l:Parser<I,T>,r:Parser<I,U>,?pos:Pos){
    super(l,r,pos);
    this.tag = switch([l.tag,r.tag]){
      case [Some(l),Some(r)]  : Some('($l) ($r)');
      default                 : None;
    }
  }
  override function check(){
    __.assert().exists(delegation);
  }
  override public inline function transform(lhs:Null<T>,rhs:Null<U>){
    return __.option(lhs);
  }
}