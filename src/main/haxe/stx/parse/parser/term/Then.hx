package stx.parse.parser.term;

abstract class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  
  public function new(delegation:Parser<I,T>,?pos:Pos){
    super(delegation,pos);
    this.tag        = delegation.tag;
  }
  abstract function transform(t:T):U;

  override public function check(){
    __.that(pos).exists().errata(e -> e.fault().of(E_Parse_UndefinedParseDelegate)).crunch(delegation);
  }
  inline public function apply(input:ParseInput<I>):ParseResult<I,U>{
    #if debug __.log().trace('$delegation then'); #end
    __.assert().exists(delegation);
    final res = delegation.apply(input);
    __.log().trace('$res');
    return switch(res.is_ok()){
      case true : 
        #if debug __.log().trace('then'); #end
        final result = res.map(transform);
        #if debug __.log().trace('thened ${result.toUpshot()}'); #end
        result;
      case false : res.fails();
    }
  }
  override public function toString(){
    return '$delegation&';
  }
}