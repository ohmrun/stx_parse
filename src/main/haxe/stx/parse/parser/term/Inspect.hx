package stx.parse.parser.term;

class Inspect<I,O> extends Base<I,O,Parser<I,O>>{
  private dynamic function prefix(input:ParseInput<I>){
    if(input.tag!=null){
      __.log()('${input.tag} "${input.head()}"',pos);
    }
  }
  private dynamic function postfix(result:ParseResult<I,O>){
    __.log()(result.toString(),pos);
  }
  public function new(delegation,?prefix:ParseInput<I> -> Void,?postfix:ParseResult<I,O> -> Void,?id:Pos){
    super(delegation,id);
    if(__.that().exists().ok()(prefix)){
      this.prefix   = prefix;
    }
    if(__.that().exists().ok()(postfix)){
      this.postfix   = postfix;
    }
  }
  override inline function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    this.prefix(input);
    var out = this.delegation.provide(input).convert(
      (res:ParseResult<I,O>) -> {
        this.postfix(res);
        return res;
      }
    );
    return out.prepare(cont);
  }
  override inline function apply(input:ParseInput<I>):ParseResult<I,O>{
    this.prefix(input);
    var result = this.delegation.apply(input);
    this.postfix(result);
    return result;
  }
  override public function get_convention(){
    return this.delegation.convention;
  }
}