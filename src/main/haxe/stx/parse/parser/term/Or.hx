package stx.parse.parser.term;
class Or<P,R> extends ParserCls<P,R>{
  var lhs : Parser<P,R>;
  var rhs : Parser<P,R>;

  public function new(lhs,rhs,?pos:Pos){
    super(pos);
    this.lhs = lhs;
    this.rhs = rhs;
    #if debug
    __.assert().exists(lhs);
      __.log().trace('${lhs}');
    __.assert().exists(rhs);
    #end
  }
  public inline function apply(input:ParseInput<P>):ParseResult<P,R>{
    #if debug __.log().trace(_ -> _.thunk( () -> '$this')); #end 
    __.assert().exists(input);
    __.assert().exists(lhs);
    final result = lhs.apply(input);
    #if debug
    __.log().trace(_ -> _.pure('result $result at ${result.asset.position()} $lhs = ${result.is_ok()}'));
    #end
    //TODO notify upstream of fail structure
    return switch(result.is_ok()){
      case true   : result;
      case false  : 
        #if debug
        __.log().trace(_ -> _.pure('try $rhs'));
        #end
        __.assert().exists(rhs);
        rhs.apply(input);
    }
  }
  override public function toString(){
    return '$lhs | $rhs';
  }
}       
