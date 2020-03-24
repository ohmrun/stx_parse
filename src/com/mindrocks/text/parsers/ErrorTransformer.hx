package com.mindrocks.text.parsers;

class ErrorTransformer<I,O> extends Delegate<I,O>{
  var transformer : ParserFailure -> ParserFailure;
  public function new(delegation,transformer,?id){
    super(delegation,id);
    this.transformer = transformer;
  }
  override function do_parse(ipt){
    return switch(delegation.parse(ipt)) {
      case Failure(err, input, isError): 
        Failure(
          err.map(transformer)
          , input
          , isError);
      case r: 
        r;
    }
  }
}