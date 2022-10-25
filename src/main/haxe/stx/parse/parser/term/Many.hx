package stx.parse.parser.term;

class Many<I,O> extends Base<I,Array<O>,Parser<I,O>>{
  public function new(delegation:Parser<I,O>,?id:Pos){
    #if test
    __.assert(id).exists(delegation);
    #end
    super(delegation,id);
    this.tag = switch (delegation.tag){
      case Some(v)  : Some('($v)*');
      default       : None;
    }
  }
  override public function check(){
    #if debug
    __.that(pos).exists().errata( e -> e.fault().of(E_Parse_UndefinedParseDelegate)).crunch(delegation);
    #end
  }
  public function apply(inputI:ParseInput<I>):ParseResult<I,Array<O>>{
    function rec(inputII:ParseInput<I>,arr:Array<O>){
      final res = delegation.apply(inputII);
      #if debug
      __.log().trace('$delegation');
      __.log().trace('${res.error}');
      __.log().trace('$arr');
      #end
      return switch(res.is_ok()){
        case true : 
          #if debug __.log().trace('${res.value}'); #end 
          switch(res.value){
            case Some(x) : arr.push(x); null;
            default : 
          }
          return rec(res.asset,arr);
        case false : 
          if(res.is_fatal()){
            inputI.erration('failed many ${delegation}',true).concat(res.error).failure(inputI);
          }else{
            #if debug __.log().trace(_ -> _.thunk( () -> arr)); #end
            inputII.ok(arr); 
          }
      }
    }
    return rec(inputI,[]);
  }
  override public function toString(){
    return 'Many($delegation)';
  }
}