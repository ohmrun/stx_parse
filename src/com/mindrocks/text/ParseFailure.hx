package com.mindrocks.text;

enum ParseFailure{
  NoRecursionHead;
  UndefinedParserInConstructor(parent:Interface<Dynamic,Dynamic>);
  UndefinedParseDelegate(?ipt:Input<Dynamic>);
}