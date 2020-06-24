using stx.parse.Pack;

import stx.parse.pack.parser.term.AndThen;
import stx.parse.pack.parser.term.Anon;
import stx.parse.pack.parser.term.Base;
import stx.parse.pack.parser.term.Commit;
import stx.parse.pack.parser.term.Delegate;
import stx.parse.pack.parser.term.Direct;
import stx.parse.pack.parser.term.ErrorTransformer;
import stx.parse.pack.parser.term.Failed;
import stx.parse.pack.parser.term.Head;
import stx.parse.pack.parser.term.Identifier;
import stx.parse.pack.parser.term.Inspect;
import stx.parse.pack.parser.term.LAnon;
import stx.parse.pack.parser.term.Many;
import stx.parse.pack.parser.term.Memoise;
import stx.parse.pack.parser.term.OneMany;
import stx.parse.pack.parser.term.Option;
import stx.parse.pack.parser.term.Or;
import stx.parse.pack.parser.term.Ors;
import stx.parse.pack.parser.term.Pure;
import stx.parse.pack.parser.term.Regex;
import stx.parse.pack.parser.term.RepSep;
import stx.parse.pack.parser.term.Rep1Sep;
import stx.parse.pack.parser.term.Succeed;
import stx.parse.pack.parser.term.Then;
import stx.parse.pack.parser.term.With;

class Main{
  static public function main(){
    trace("before");
    stx.parse.Test.main();    
    trace("later");
  }
}