package com.mindrocks.text;

typedef MemoT = {
  memoEntries     : StdMap<String,MemoEntry>,
  recursionHeads  : StdMap<String,Head>, // key: position (string rep)
  lrStack         : List<LR>
}