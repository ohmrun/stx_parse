package stx.parse;

import stx.parse.parsers.StringParsers;
using stx.Nano;
using stx.Test;
using stx.Log;
using stx.Parse;

class BetterErrorReporting extends stx.test.TestCase{
  static public function main(){
    __.test().run(
      [
        new BetterErrorReporting()
      ],[]
    );
  }
  public function test(){
    final string = "abbbbc";
    final parser = parser();
    final result = parser.apply(string.reader());
    trace(result);
  }
  private function parser(){
    return Parsers.Something().and(Parsers.OneMany(StringParsers.id("b"))).then(_ -> "0").and(StringParsers.id("r"));
  }
}