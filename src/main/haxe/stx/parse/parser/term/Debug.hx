package stx.parse.parser.term;

//Messes with references. how to fix?
class Debug<P,R> extends Delegate<P,R>{
  override public function defer(ipt:ParseInput<P>,cont:Terminal<ParseResult<P,R>,Noise>):Work{
    var base  = ipt.index;
    var key   = this.delegation.identifier().name;
        //__.log()('+ $key');
        ipt   = ipt.push(key);
        //__.log()('${ipt.prj().cursor}');
        
    return this.delegation.defer(ipt,
      cont.joint(
        (outcome:Reaction<ParseResult<P,R>>) -> {
          cont.issue(
            outcome.map(
              result -> result.mod(
                input -> {
                  //__.log()('${input.prj().cursor}');
                  //__.log()('- $key');
                  input = input.pop();
                  //__.log()('${input.prj().cursor}');
                  return input;
                }
              )
            )
          ).serve();
        }
      )
    );
  }
  override public function apply(input:ParseInput<P>):ParseResult<P,R>{
    var key   = this.delegation.identifier().name;
    //__.log()(key);
    input = input.push(key);
    
    var result = this.delegation.apply(input);
        result = result.mod(
          input -> input.pop()
        );
    return result;
  }
}