override public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{

  var arr     = [];
  return  Fletcher._.then(
    delegation,
    Fletcher.Anon(
      function rec(i:ParseResult<I,O>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
        return (i).fold(
          (ok) -> {
            for (v in ok.with){
              arr.push(v);
            }
            return Fletcher.Then(delegation,Fletcher.Anon(rec)).toInternal().defer(ok.rest,cont);
          },
          (no) -> cont.value(no.is_fatal() ? no.toParseResult() : no.rest.ok(arr)).serve()
        );
      }
    )
  ).toInternal().defer(input,cont);
}