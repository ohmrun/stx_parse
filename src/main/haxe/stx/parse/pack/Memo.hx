package stx.parse.pack;


enum MemoEntry {
  MemoParsed(ans : ParseResult<Dynamic,Dynamic>);
  MemoLR(lr : LR);
}

typedef MemoKey = String;

typedef MemoDef = {
  symbols         : haxe.ds.ObjectMap<ParserApi<Dynamic,Dynamic>,Dynamic>,
  memoEntries     : StdMap<String,MemoEntry>,
  recursionHeads  : StdMap<String,Head>, // key: position (string rep)
  lrStack         : LinkedList<LR>
}

@:forward abstract Memo(MemoDef) from MemoDef{
  static public function unit():Memo{
    return {
      symbols           : new haxe.ds.ObjectMap(),
      memoEntries       : new StdMap<String,MemoEntry>(),
      recursionHeads    : new StdMap<String,Head>(),
      lrStack           : LinkedList.unit()
    }
  }
  inline public function get(key : MemoKey) : Option<MemoEntry> {
    var value = this.memoEntries.get(key);
    if (value == null) {
      return None;
    } else {
      return Some(value);
    }
  }
}