package stx.parse.pack.parser.term;

class Inspect<I,O> extends Delegate<I,O>{
  var prefix  : Input<I> -> Void;
  var postfix : ParseResult<I,O> -> Void;
  public function new(delegation,prefix:Input<I> -> Void,postfix:ParseResult<I,O> -> Void,?id){
    this.prefix   = prefix;
    this.postfix  = postfix;
    super(delegation,id);
  }
  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    this.prefix(input);
    var out = this.delegation.forward(input).process(
      (res:ParseResult<I,O>) -> {
        this.postfix(res);
        return res;
      }
    );
    return out.prepare(cont);
  }
}