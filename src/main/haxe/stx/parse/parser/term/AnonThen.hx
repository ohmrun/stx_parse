package stx.parse.parser.term;

class AnonThen<P,Ri,Rii> extends Then<P,Ri,Rii>{
  public function new(delegation,__transform,?pos:Pos){
    super(delegation,pos);
    this.__transform = __transform;
  }
  dynamic function __transform(p:Ri):Rii{
    return null;
  }
inline function transform(p:Ri):Rii{
    return __transform(p);
  }
}