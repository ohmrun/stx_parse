package stx.parse.pack;

import stx.parse.pack.parser.term.Memoise;

typedef LRDef = {
  public var seed: ParseResult<Dynamic,Dynamic>;
  public var rule: Parser<Dynamic,Dynamic>;
  public var head: Option<Head>;
}
@:forward abstract LR(LRDef) from LRDef{
  static public var _(default,never) = LRLift;
  public function pos() : Input<Dynamic> return this.seed.pos();
}
class LRLift{
  static public function lrAnswer<I,T>(p: Parser<I,T>, genKey : Int -> String, input: Input<I>, growable: LR): ParseResult<I,T> {
    return switch (growable.head) {
      case None: throw __.fault().of(E_NoRecursionHead);
      case Some(head):
        if (head.getHead() != p) /*not head rule, so not growing*/{
          cast(growable.seed);
        } else {
          input.updateCacheAndGet(genKey, MemoParsed(growable.seed));
          growable.seed.fold(
            (_) -> grow(p, genKey, input, head), /*growing*/
            (_) -> cast(growable.seed)
          );
        }
    }
  }
  static public function recall<I,T>(p : Parser<I,T>, genKey : Int -> String, input : Input<I>) : Option<MemoEntry> {
    var cached = input.getFromCache(genKey);
    return switch (input.getRecursionHead()) {
      case None: cached;
      case Some(head):
        if (cached == None && !(head.involvedSet.cons(head.headParser).has(p.elide()))) {
          Some(
            MemoParsed(
              ParseFailure.at_with(input,'dummy')
            )
          );
        }
        if (head.evalSet.has(p)) {
          head.evalSet = head.evalSet
            .filter(function (x:Parser<Dynamic,Dynamic>) return x != p);

          var memo = MemoParsed(p.parse(input));
          input.updateCacheAndGet(genKey, memo); // beware; it won't update lrStack !!! Check that !!!
          cached = Some(memo);
        }
        return cached;
    }
  }
  static public function setupLR<I>(p: Parser<I,Dynamic>, input: Input<I>, recDetect: LR) {
    if (recDetect.head == None)
      recDetect.head = Some(p.mkHead());

    var stack = input.memo.lrStack;
    var h     = recDetect.head.fudge(); // valid (see above)
    while (stack.head() != null && stack.head().rule != p) {
      var head = stack.head();
      head.head = recDetect.head;
      h.involvedSet = h.involvedSet.cons(head.rule);
      stack = stack.tail();
    }
  }
  static function grow<I,T>(p: Parser<I,T>, genKey : Int -> String, rest: Input<I>, head: Head): ParseResult<I,T> {
    //store the head into the recursionHeads
    rest.setRecursionHead(head);
    var oldRes =
      switch (rest.getFromCache(genKey).fudge()) {
        case MemoParsed(ans): ans;
        default : throw "impossible match";
      };

    //resetting the evalSet of the head of the recursion at each beginning of growth

    head.evalSet = head.involvedSet;
    if( p == null){
       throw('undefined parse delegate'); 
    }
    var res = p.parse(rest);
    switch (res) {
      case Success(_) :
        if (oldRes.pos().offset < res.pos().offset ) {
          rest.updateCacheAndGet(genKey, MemoParsed(res));
          return grow(p, genKey, rest, head);
        } else {
          //we're done with growing, we can remove data from recursion head
          rest.removeRecursionHead();
          switch (rest.getFromCache(genKey).fudge()) {
            case MemoParsed(ans): return cast(ans);
            default: throw "impossible match";
          }
        }
      case Failure(_.is_fatal() => isError):
        if (isError) { // the error must be propagated  and not discarded by the grower!

          rest.updateCacheAndGet(genKey, MemoParsed(res));
          rest.removeRecursionHead();
          return res;

        } else {
          rest.removeRecursionHead();
          return cast(oldRes);
        }

    }
  }

  /**
   * Lift a parser to a packrat parser (memo is derived from scala's library)
   */
  public static function memo<I,T>(p : Parser<I,T>) : Parser<I,T>{
    return new Memoise(p).asParser();
  };
}