package stx.parse.parser.term;

class Inspect<I,O> extends Delegate<I,O>{
  private dynamic function prefix(input:ParseInput<I>){
    if(input.tag!=null){
     #if debug 
      __.log().trace('${input.tag} "${input.head()}"',pos);
     #end
    }
  }
  private dynamic function postfix(result:ParseResult<I,O>){
    __.log().trace(result.toString(),pos);
  }
  public function new(delegation,?prefix:ParseInput<I> -> Void,?postfix:ParseResult<I,O> -> Void,?id:Pos){
    super(delegation,id);
    if(__.assert().expect().exists().apply(prefix).is_ok()){
      this.prefix   = prefix;
    }
    if(__.assert().expect().exists().apply(postfix).is_ok()){
      this.postfix   = postfix;
    }
  }
  override inline function apply(input:ParseInput<I>):ParseResult<I,O>{
    this.prefix(input);
    var out = this.delegation.apply(input);
    this.postfix(out);
    return out;
  }
  override public function toString(){
    return '$delegation';
  }
}