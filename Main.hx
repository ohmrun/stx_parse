using stx.Parse;

// import stx.parse.parser.term.AndThen;
// import stx.parse.parser.term.Anon;
// import stx.parse.parser.term.Base;
// import stx.parse.parser.term.Commit;
// import stx.parse.parser.term.Delegate;
// import stx.parse.parser.term.Direct;
// import stx.parse.parser.term.RefuseTransformer;
// import stx.parse.parser.term.Failed;
// import stx.parse.parser.term.Head;
// import stx.parse.parser.term.Identifier;
// import stx.parse.parser.term.Inspect;
// import stx.parse.parser.term.LAnon;
// import stx.parse.parser.term.Many;
// import stx.parse.parser.term.Memoise;
// import stx.parse.parser.term.OneMany;
// import stx.parse.parser.term.Option;
// import stx.parse.parser.term.Or;
// import stx.parse.parser.term.Ors;
// import stx.parse.parser.term.Pure;
// import stx.parse.parser.term.Regex;
// import stx.parse.parser.term.RepSep;
// import stx.parse.parser.term.Rep1Sep;
// import stx.parse.parser.term.Succeed;
// import stx.parse.parser.term.Then;
// import stx.parse.parser.term.With;

class Main{
  static public function main(){
    trace("before");
    stx.parse.Test.main();    
    trace("later");
  }
}