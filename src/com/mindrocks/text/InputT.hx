package com.mindrocks.text;

typedef InputT<I> = {
  content   : Enumerable<Dynamic,I>,
  memo      : Memo,
  ?tag      : String
}