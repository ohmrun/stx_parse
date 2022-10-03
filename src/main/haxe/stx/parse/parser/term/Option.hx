package stx.parse.parser.term;

class Option<P,R> extends Base<P,StdOption<R>,Parser<P,R>>{

  public function new(delegation:Parser<P,R>,?pos:Pos){
    super(delegation,pos);
  }
  function apply(input:ParseInput<P>):ParseResult<P,StdOption<R>>{
    final result = delegation.apply(input);
    return switch(result.has_error()){
      case true  :  
        switch(result.is_fatal()){
          case true   : result.map(Some);
          case false  : input.ok(None);
        }
      case false :
        result.map(Some); 
    } 
  }
  override public function toString(){
    return '$delegation?';
  }
}