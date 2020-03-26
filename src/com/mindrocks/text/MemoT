package com.mindrocks.text;

typedef MemoT = {
  symbols         : haxe.ds.ObjectMap<Interface<Dynamic,Dynamic>,Dynamic>,
  memoEntries     : StdMap<String,MemoEntry>,
  recursionHeads  : StdMap<String,Head>, // key: position (string rep)
  lrStack         : LinkedList<LR>
}