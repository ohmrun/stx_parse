package stx.parse.parser.term;

class Memoise<I,O> extends Base<I,O,Parser<I,O>>{ 
  public final uid                          : Int;
  public function new(delegation:Parser<I,O>,?pos:Pos){
    super(delegation,pos);
    this.uid = new UID();
  }
  function genKey(pos : Int) {  
    return this.uid+"@"+pos;
  }
  @:privateAccess inline function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    #if debug __.log().debug('memoise'); #end
    final memo = delegation.recall(genKey, ipt);
    #if debug __.log().debug(_ -> _.thunk(() -> 'memoise:recalled ${memo.is_defined()}')); #end
    
    return switch(memo){
      case None :
        final base          = ipt.erration(ParseRefuse.FAIL,false).failure(ipt).mkLR(delegation, None);
        ipt.memo.lrStack    = ipt.memo.lrStack.cons(base);
        ipt.updateCacheAndGet(genKey, MemoLR(base));

        #if debug __.assert().exists(delegation); #end

        final res = delegation.apply(ipt);
        #if debug __.log().debug("memoise:delegate"); #end
        __.log().trace('$res');
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
    };
  }
}