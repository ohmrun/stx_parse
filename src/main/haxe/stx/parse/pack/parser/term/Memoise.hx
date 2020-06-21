package stx.parse.pack.parser.term;

class Memoise<I,O> extends Delegate<I,O>{ 
  public function new(delegation:Parser<I,O>,?pos){
    super(delegation,pos);
    this.uid = new UID();
  }
  function genKey(pos : Int) {  
    return this.id+"@"+pos;
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,O>{
    switch (delegation.recall(genKey, ipt)) {
      case None :
        var base = ipt.fail(ParseError.FAIL,false,id).mkLR(delegation, None);

        ipt.memo.lrStack  = ipt.memo.lrStack.cons(base);
        ipt.updateCacheAndGet(genKey, MemoLR(base));

        __.that().exists().errata(e -> e.fault().of(E_UndefinedParseDelegate(ipt))).crunch(delegation);
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
            LR._.setupLR(delegation, ipt, recDetect);
            return cast(recDetect.seed);
          case  MemoParsed(ans):
            return cast(ans);
        }
    }
  }
}