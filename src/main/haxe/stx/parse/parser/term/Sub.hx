package stx.parse.parser.term;

class Sub<I,O,Oi,Oii> extends Base<I,Oii,Parser<I,O>>{
  public function new(delegation, transform,?tag,?pos:Pos){
    super(delegation,tag,pos);
    this.transform = transform;
  }
  public final transform : Option<O>->Couple<ParseInput<Oi>,Parser<Oi,Oii>>;

  public function apply(input:ParseInput<I>):ParseResult<I,Oii>{
    final res 		= delegation.apply(input);
    return switch(res.is_ok()){
      case true : 
        final out 		= transform (res.value);
        final reader 	= out.fst();
        final parser 	= out.snd(); 
        final resII 	= parser.apply(reader);
        final inner 	= switch(resII.is_ok()){
          case true : 
            switch(resII.value){
              case Some(ok) : res.asset.ok(ok);
              case None  		: res.asset.nil();
            }
          case false : 
            ParseResult.make(input,None,resII.error);
        }
        inner;
      case false : res.fails();
    }
  }

}