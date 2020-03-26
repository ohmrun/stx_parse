package stx.parse.pack.parser.term;

class OneMany<I,O> extends Many<I,O>{

  override public function do_parse(ipt:Input<I>):ParseResult<I,Array<O>>{  
    __.assert(delegation.id).exists(delegation);
    
    return delegation.parse(ipt).fold(
      (succ) -> new Many(delegation).parse(succ.rest).s_fold(
        (succI,_) -> ParseResult.success(succ.map(
          (res) -> [res].concat(succI.with)
        ).then(succI.rest)),
        (err,res) -> err.is_fatal().if_else(
          () -> ParseResult.failure(err),
          () -> ParseResult.success(succ.map((x) -> [x]))
        )
      ),
      ParseResult.failure
    );
  }
} 