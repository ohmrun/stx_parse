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
  @:privateAccess inline function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    __.log().debug('memoise');
    var res =  Fletcher.Then(
      delegation.recall(genKey, ipt),
      Fletcher.Anon(
        (memo:Option<MemoEntry>,cont:Terminal<ParseResult<I,O>,Noise>) -> {
          __.log().debug(_ -> _.thunk(() -> 'memoise:recalled ${memo.is_defined()}'));
          return switch(memo){
            case None :
              var base = ipt.fail(ParseError.FAIL,false).mkLR(delegation, None);

              ipt.memo.lrStack  = ipt.memo.lrStack.cons(base);
              ipt.updateCacheAndGet(genKey, MemoLR(base));

              #if debug
              __.assert().exists(delegation);
              #end

              return Fletcher.Then(
                delegation,
                Fletcher.Anon(
                  (res:ParseResult<I,O>,cont:Terminal<ParseResult<I,O>,Noise>) -> {
                    __.log().debug("memoise:delegate");
                    ipt.memo.lrStack = ipt.memo.lrStack.tail();
                    return switch (base.head) {
                      case None:
                        ipt.updateCacheAndGet(genKey, MemoParsed(res));
                        cont.receive(cont.value(res));
                      case Some(_):
                        base.seed = res;
                        cont.receive(delegation.lrAnswer(genKey, ipt, base).forward(Noise));
                    }
                  }
                )
              ).defer(ipt,cont);

          case Some(mEntry):
            switch(mEntry) {
              case  MemoLR(recDetect):
                LR._.setupLR(delegation, ipt, recDetect);
                return cont.receive(cont.value(cast(recDetect.seed)));
              case  MemoParsed(ans):
                return cont.receive(cont.value(cast(ans)));
            }
          };
        }
      )
    );
    return cont.receive(res.forward(Noise));
  }
}