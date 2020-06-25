package stx.parse.pack.parser.term;

class Memoise<I,O> extends Delegate<I,O>{ 
  public function new(delegation:Parser<I,O>,?pos){
    super(delegation,pos);
    this.uid = new UID();
  }
  function genKey(pos : Int) {  
    return this.id+"@"+pos;
  }
  override function applyII(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return Arrowlet.Then(
      delegation.recall(genKey, ipt),
      Arrowlet.Anon(
        (memo:Option<MemoEntry>,cont:Terminal<ParseResult<I,O>,Noise>) -> switch(memo){
          case None :
            var base = ipt.fail(ParseError.FAIL,false,id).mkLR(delegation, None);

            ipt.memo.lrStack  = ipt.memo.lrStack.cons(base);
            ipt.updateCacheAndGet(genKey, MemoLR(base));

            __.that().exists().errata(e -> e.fault().of(E_UndefinedParseDelegate(ipt))).crunch(delegation);

            return Arrowlet.Then(
              delegation,
              Arrowlet.Anon(
                (res:ParseResult<I,O>,cont:Terminal<ParseResult<I,O>,Noise>) -> {
                  ipt.memo.lrStack = ipt.memo.lrStack.tail();
                  return switch (base.head) {
                    case None:
                      ipt.updateCacheAndGet(genKey, MemoParsed(res));
                      cont.value(res).serve();
                    case Some(_):
                      base.seed = res;
                      delegation.lrAnswer(genKey, ipt, base).prepare(cont);
                  }
                }
              )
            ).applyII(ipt,cont);
        case Some(mEntry):
          switch(mEntry) {
            case  MemoLR(recDetect):
              LR._.setupLR(delegation, ipt, recDetect);
              return cont.value(cast(recDetect.seed)).serve();
            case  MemoParsed(ans):
              return cont.value(cast(ans)).serve();
          }
        }
      )
    ).prepare(Noise,cont);
  }
}