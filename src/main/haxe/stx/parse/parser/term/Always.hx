package stx.parse.parser.term;

class Always<I> extends Sync<I,I>{
  public function apply(input:ParseInput<I>):ParseResult<I,I>{
    #if debug __.log().debug('${input.head()}'); #end
    return switch(input.head()){
      case Val(i) : 
        #if debug __.log().trace('$i'); #end
        input.nil();
      case End(e):
        e.toParseResult_with(input,false);
      case Tap:
        #if debug trace("nil"); #end
        input.nil();
    }
  }
}