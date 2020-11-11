package stx.parse.parser.term;

class Inspect<I,O> extends Base<I,O,Parser<I,O>>{
  var prefix  : Input<I> -> Void;
  var postfix : ParseResult<I,O> -> Void;
  public function new(delegation,prefix:Input<I> -> Void,postfix:ParseResult<I,O> -> Void,?id:Pos){
    this.prefix   = prefix;
    this.postfix  = postfix;
    super(delegation,id);
  }
  override inline function defer(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    this.prefix(input);
    var out = this.delegation.provide(input).convert(
      (res:ParseResult<I,O>) -> {
        this.postfix(res);
        return res;
      }
    );
    return out.prepare(cont);
  }
  override inline function apply(input:Input<I>):ParseResult<I,O>{
    this.prefix(input);
    var result = this.delegation.apply(input);
    this.postfix(result);
    return result;
  }
  override public function get_convention(){
    return this.delegation.convention;
  }
}