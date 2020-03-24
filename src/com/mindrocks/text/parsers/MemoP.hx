package com.mindrocks.text.parsers;

class MemoP<I,O> extends Delegate<I,O>{ 
  public function new(delegation:Parser<I,O>){
    super(delegation);
    this.uid = new UID();
  }
  function genKey(pos : Int) {  
    return this.id+"@"+pos;
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,O>{
    switch (delegation.recall(genKey, ipt)) {
      case None :
        var base = failed(ParseFail.FAIL.errorAt(ipt).newStack(), ipt, false).mkLR(delegation, None);

        ipt.memo.lrStack  = ipt.memo.lrStack.cons(base);
        ipt.updateCacheAndGet(genKey, MemoLR(base));

        __.that().exists().errata(e -> e.fault().of(UndefinedParseDelegate(ipt))).crunch(delegation);
        var res = delegation.parse(ipt);

        ipt.memo.lrStack = ipt.memo.lrStack.tail();

        return switch (base.head) {
          case None:
            ipt.updateCacheAndGet(genKey, MemoParsed(res));
            res;
          case Some(_):
            base.seed = res;
            delegation.lrAnswer(genKey, ipt, base);
        }
      case Some(mEntry):
        switch(mEntry) {
          case  MemoLR(recDetect):
            LRs.setupLR(delegation, ipt, recDetect);
            return cast(recDetect.seed);
          case  MemoParsed(ans):
            return cast(ans);
        }
    }
  }
}