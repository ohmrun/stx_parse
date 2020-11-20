package stx.parse;
 
@:structInit
class ParseInputCls<I>{
  static public inline function make<I>(content,memo,tag,cursor:Array<String>,tree:Lung):ParseInputCls<I>{
    return new ParseInputCls(content,memo,tag,cursor,tree);
  }
  public var content(default,null):Enumerable<Dynamic,I>;
  public var memo(default,null):Memo;
  public var cursor(default,null):Array<String>;
  public var tree(default,null):Lung;
  
  public var tag(default,null):String;

  public function toString(){
    return 'path: $cursor at ${this.content.index}:#(${head()})';
  }
  inline public function head() : Option<I> {
    return __.option(this.content.head());
  }
  public function copy(?content,?memo,?tag,?cursor,?tree):ParseInputCls<I>{
    return make(
      __.option(content).defv(this.content),
      __.option(memo).defv(this.memo),
      __.option(tag).defv(this.tag),
      __.option(cursor).defv(this.cursor),
      __.option(tree).defv(this.tree)
    );
  }
  private function new(content,memo,tag,cursor:Array<String>,tree){
    this.content  = content;
    this.memo     = memo;
    this.tag      = tag;
    this.cursor   = __.option(cursor).defv([]);
    this.tree     = __.option(tree).def(Lung.unit);
  }
  public function inside(index:Int,name:String){
    return this.copy(
      null,null,null,null,this.tree.push(index,name)
    );
  }
  public function push(tag:String){
    return copy(null,null,null,cursor.snoc(tag));
  }
  public function pop(){
    return copy(null,null,null,cursor.ltaken(cursor.length-1));
  }
}

@:forward(memo,tag,head,inside,push,pop)abstract ParseInput<I>(ParseInputCls<I>) from ParseInputCls<I>{
  @:noUsing static public function lift<I>(self:ParseInputCls<I>):ParseInput<I>{
    return self;
  }
  @:noUsing static public function make<I>(content:Enumerable<Dynamic,I>,memo:Memo,?tag:String,?cursor,?tree):ParseInput<I>{
    return ParseInputCls.make(content,memo,tag,cursor,tree);
  }
  static public function pure<T>(en:Enumerable<Dynamic,T>):ParseInput<T>{
    return make(en,Memo.unit());
  }
  inline public function drop(len : Int) : ParseInput<I> {
    return this.copy(this.content.drop(len));
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

  inline public function tail():ParseInput<I>{
    return drop(1);
  }
  inline public function matchedBy(e:I->Bool) : Bool {
    return this.content.match(e);
  }

  inline public function position<I>(r : ParseInput<I>) : Int return this.content.index;
  
  public function prepend(i:I):ParseInput<I>{
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
  public var index(get,never):Int;
  function get_index(){
    return this.content.index;
  }
  public function prj(){
    return this;
  }
}