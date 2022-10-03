package stx.parse.parser.term;
class Or<P,R> extends ParserCls<P,R>{
  var lhs : Parser<P,R>;
  var rhs : Parser<P,R>;

  public function new(lhs,rhs,?pos:Pos){
    super(pos);
    this.lhs = lhs;
    this.rhs = rhs;
  }
  inline function apply(input:ParseInput<P>):ParseResult<P,R>{
    #if debug __.log().trace(_ -> _.thunk( () -> '$this')); #end 
    final result = lhs.apply(input);
    #if debug
    __.log().trace(_ -> _.pure('result $result at ${result.asset.position()} $lhs = ${result.is_ok()}'));
    #end
    //TODO notify upstream of fail structure
    return switch(result.is_ok()){
      case true   : result;
      case false  : 
        __.log().trace(_ -> _.pure('try $rhs'));
        rhs.apply(input);
    }
  }
  override public function toString(){
    return '$lhs | $rhs';
  }
}       
