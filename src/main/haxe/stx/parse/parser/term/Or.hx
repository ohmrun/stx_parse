package stx.parse.parser.term;
class Or<P,R> extends ParserCls<P,R>{
  var lhs : Parser<P,R>;
  var rhs : Parser<P,R>;

  public function new(lhs,rhs,?pos:Pos){
    super(pos);
    this.lhs = lhs;
    this.rhs = rhs;
    #if debug
    __.assert().that().exists(lhs);
      __.log().trace('${lhs}');
    __.assert().that().exists(rhs);
    #end
  }
  public inline function apply(input:ParseInput<P>):ParseResult<P,R>{
    #if debug __.log().trace(_ -> _.thunk( () -> '$this')); #end 
    __.assert().that().exists(input);
    __.assert().that().exists(lhs);
    final result = lhs.apply(input);
    #if debug
    __.log().trace(_ -> _.pure('result $result at ${result.asset.position()} $lhs = ${result.is_ok()}'));
    #end
    //TODO notify upstream of fail structure
    return switch(result.is_ok()){
      case true   : result;
      case false  : 
        #if debug
        __.log().trace(_ -> _.pure('rhs: try $rhs'));
        #end
        __.assert().that().exists(rhs);
        final resI = rhs.apply(input);

        if(!resI.is_ok()){
          resI.with_errata(result.error);
        }
        #if debug
          __.log().trace(_ -> _.pure('result $resI at ${resI.asset.position()} $lhs = ${resI.is_ok()}'));
        #end
        resI;
    }
  }
  override public function toString(){
    return '$lhs | $rhs';
  }
}       
