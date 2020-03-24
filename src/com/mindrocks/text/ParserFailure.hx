package com.mindrocks.text;

enum ParserFailure{
  ParseFailed(msg:FailureMsg);
  NamedParseFailure(string:String);
  ErrorNamed(str:String,err:ParserFailure);
  NoRecursionHead;
  UndefinedParserInConstructor(parent:Interface<Dynamic,Dynamic>);
  UndefinedParseDelegate(?ipt:Input<Dynamic>);
}
