package com.mindrocks.text.parsers;

class OneMany<I,O> extends Many<I,O>{

  override public function do_parse(ipt:Input<I>):ParseResult<I,Array<O>>{  
    __.that(delegation.id).exists().crunch(delegation);
    var x = delegation.parse(ipt);
    return switch(x){
      case Success(x,xs) : new Many(delegation).parse(xs).fold(
        (x0,xs0) -> Success([x].ds().concat(x0),xs0),
        (stack,rest,is_error) -> Success([x],xs)
      );
      case Failure(stack,rest,is_error) : Failure(stack.cons("oneMany failed".errorAt(rest)),rest,is_error);
    }
  }
} 