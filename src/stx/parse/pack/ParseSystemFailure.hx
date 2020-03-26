package stx.parse.pack;

enum ParseSystemFailure{
  E_NoRecursionHead;
  E_UndefinedParserInConstructor(parent:ParserApi<Dynamic,Dynamic>);
  E_UndefinedParseDelegate(?ipt:Input<Dynamic>);
}