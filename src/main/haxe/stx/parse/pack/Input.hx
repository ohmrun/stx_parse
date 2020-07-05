package stx.parse.pack;
 
typedef InputDef<I> = {
  content   : Enumerable<Dynamic,I>,
  memo      : Memo,
  ?tag      : String
}

@:forward(memo,tag)abstract Input<I>(InputDef<I>) from InputDef<I>{
  @:noUsing static public function lift<I>(self:InputDef<I>):Input<I>{
    return self;
  }
  @:noUsing static public function make<I>(content:Enumerable<Dynamic,I>,memo:Memo,?tag:String):Input<I>{
    return {
      content : content,
      memo    : memo,
      tag     : tag
    };
  }
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
  inline public function take<T>(?len):T{
    return this.content.take(len);
  }
  inline public function foldn<Z>(fn:I->Z->Z,n:Int,z:Z):Z{
    var memo = z;
    var self = lift(this);

    while(n > 0){
      var next = self.content.take(1);
      memo = fn(next,memo);
      self = self.drop(1);
      n--;
    }
    return memo;
  }

  inline public function tail():Input<I>{
    return drop(1);
  }
  inline public function matchedBy(e:I->Bool) : Bool {
    return this.content.match(e);
  }
  inline public function head() : Option<I> {
    return __.option(this.content.head());
  }

  inline public function position<I>(r : Input<I>) : Int return this.content.index;
  
  public function prepend(i:I):Input<I>{
    return make(this.content.prepend(i),this.memo,this.tag);
  }
  public inline function setRecursionHead(head : Head) {
    this.memo.recursionHeads.set(this.content.index + "", head);
  }
  public inline function removeRecursionHead() {
    this.memo.recursionHeads.remove(this.content.index + "");
  }
  public inline function getRecursionHead() : Option<Head> {
    var res = this.memo.recursionHeads.get(this.content.index + "");
    return res == null ? None: Some(res);
  }
  public inline function getFromCache(genKey : Int -> String) : Option<MemoEntry> {
    var key = genKey(this.content.index);
    var res = this.memo.memoEntries.get(key);
    return res == null ? None: Some(res);
  }
  inline public function updateCacheAndGet(genKey : Int -> String, entry : MemoEntry) {
    var key = genKey(this.content.index);
    this.memo.memoEntries.set(key, entry);
    return entry;
  }
  public function toString(){
    return 'at ${this.content.index}:#(${head()})';
  }
  public function is_end(){
    return this.content.is_end();
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