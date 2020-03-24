

package com.mindrocks.text;

@:forward(memo,tag)abstract Input<I>(InputT<I>) from InputT<I>{
  static public function pure<T>(en:Enumerable<Dynamic,T>):Input<T>{
    return {
      content : en,
      memo    : Memo.unit()
    };
  }
  inline public function drop(len : Int) : Input<I> {
    return {
      content : this.content.drop(len),
      memo    : this.memo
    };
  }
  inline public function take(?len):I{
    return this.content.take(len);
  }
  inline public function tail():Input<I>{
    return drop(1);
  }
  inline public function matchedBy(e:I->Bool) : Bool {
    return this.content.match(e);
  }
  inline public function head() : I {
    return this.content.head();
  }

  inline public function position<I>(r : Input<I>) : Int return
    this.content.index;

  public function textAround(?before : Int = 10, ?after : Int = 10) : { text : String, indicator : String } {

    var offset        = Std.int(Math.max(0, this.content.index - before));
    var text          = this.content.take(before + after);
    var indicPadding  = Std.int(Math.min(this.content.index, before));
    var indicator     = StringTools.lpad("^", "_", indicPadding+1);

    return {
      text        : text,
      indicator   : indicator
    };
  }
  public inline function setRecursionHead(head : Head) {
    this.memo.recursionHeads.set(this.content.index + "", head);
  }
  public inline function removeRecursionHead() {
    this.memo.recursionHeads.remove(this.content.index + "");
  }
  public inline function getRecursionHead() : Option<Head> {
    var res = this.memo.recursionHeads.get(this.content.index + "");
    return res == null?None: Some(res);
  }
  public inline function getFromCache(genKey : Int -> String) : Option<MemoEntry> {
    var key = genKey(this.content.index);
    var res = this.memo.memoEntries.get(key);
    return res == null? None: Some(res);
  }
  inline public function updateCacheAndGet(genKey : Int -> String, entry : MemoEntry) {
    var key = genKey(this.content.index);
    this.memo.memoEntries.set(key, entry);
    return entry;
  }
  public function toString(){
    return 'at ${this.content.index}:#(${head()})';
  }
  public function isEnd(){
    return this.content.isEnd();
  }
  public var offset(get,never):Int;
  function get_offset(){
    return this.content.index;
  }
  private var content(get,never):Enumerable<Dynamic,I>;
  function get_content(){
    return this.content;
  }
}