package stx.parse.pack.parser.term;

class OneMany<I,O> extends Many<I,O>{

  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    __.assert(delegation.id).exists(delegation);

    return Arrowlet.Then(
      delegation,
      Arrowlet.Anon(
        (res:ParseResult<I,O>,cont:Terminal<ParseResult<I,Array<O>>,Noise>) -> (res).fold(
          (ok:ParseSuccess<I,O>) -> Process.lift(new Many(delegation)).forward(ok.rest).process(
            ((nxt:ParseResult<I,Array<O>>) -> (nxt).fold(
                okI -> okI.rest.ok(ok.with.toArray().concat(okI.with.defv([]))),
                no  -> no.is_fatal() ? ParseResult.failure(no) : nxt.rest.ok(ok.with.toArray())
            ))
          ).prepare(cont),
          (no) -> cont.value(no.toParseResult()).serve()
        )
      )
    ).applyII(input,cont);
  }
} 