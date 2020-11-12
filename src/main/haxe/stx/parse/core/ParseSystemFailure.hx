package stx.parse.core;

enum ParseSystemFailure{
  E_NoRecursionHead;
  E_UndefinedParserInConstructor(parent:ParserApi<Dynamic,Dynamic>);
  E_UndefinedParseDelegate(?ipt:ParseInput<Dynamic>);
}