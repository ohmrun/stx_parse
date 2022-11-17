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
    final arr   = [];
    var out : Option<ParseResult<I,Array<O>>>     = None;
    var ipt     = inputI;

    function step():Void{
      final res = delegation.apply(ipt);
      #if debug
      __.log().trace('$delegation');
      __.log().trace('${res.error}');
      __.log().trace('$arr');
      #end
      switch(res.is_ok()){
        case true : 
          #if debug __.log().trace('${res.value}'); #end 
          switch(res.value){
            case Some(x) : arr.push(x); null;
            default : 
          }
          ipt = res.asset;
        case false : 
          if(res.is_fatal()){
            out = Some(inputI.erration('failed many ${delegation}',true).concat(res.error).failure(inputI));
          }else{
            #if debug __.log().trace(_ -> _.thunk( () -> arr)); #end
            out = Some(ipt.ok(arr)); 
          }
      }
    }
    while(!out.is_defined()){
      step();
    }
    return out.defv(inputI.no('FAIL'));
  }
  override public function toString(){
    return 'Many($delegation)';
  }
}