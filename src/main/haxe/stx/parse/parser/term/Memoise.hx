package stx.parse.parser.term;

class Memoise<I,O> extends Base<I,O,Parser<I,O>>{ 
  public function new(delegation:Parser<I,O>,?pos:Pos){
    super(delegation,pos);
    this.uid = new UID();
  }
  function genKey(pos : Int) {  
    return this.uid+"@"+pos;
  }
  @:privateAccess override inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    //__.log().debug('memoise');
    var res =  Fletcher.Then(
      delegation.recall(genKey, ipt),
      Fletcher.Anon(
        (memo:Option<MemoEntry>,cont:Terminal<ParseResult<I,O>,Noise>) -> switch(memo){
          case None :
            var base = ipt.fail(ParseError.FAIL,false,pos).mkLR(delegation, None);

            ipt.memo.lrStack  = ipt.memo.lrStack.cons(base);
            ipt.updateCacheAndGet(genKey, MemoLR(base));

            __.assert().exists(delegation);

            return Fletcher.Then(
              delegation,
              Fletcher.Anon(
                (res:ParseResult<I,O>,cont:Terminal<ParseResult<I,O>,Noise>) -> {
                  ipt.memo.lrStack = ipt.memo.lrStack.tail();
                  return switch (base.head) {
                    case None:
                      ipt.updateCacheAndGet(genKey, MemoParsed(res));
                      cont.value(res).serve();
                    case Some(_):
                      base.seed = res;
                      cont.receive(delegation.lrAnswer(genKey, ipt, base).receive(Noise));
                  }
                }
              )
            )(ipt,cont);

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
    );
    return cont.receive(res.receive(Noise));
  }
}