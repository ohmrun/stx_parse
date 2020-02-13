package com.mindrocks.text;

@:forward abstract Memo(MemoT) from MemoT{
  static public function unit():Memo{
    return {
      memoEntries       : new StdMap<String,MemoEntry>(),
      recursionHeads    : new StdMap<String,Head>(),
      lrStack           : List.unit()
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