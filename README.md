# stx_parse
## Left Recursive Parser Combinator Library.

## Usage

```haxe
  using stx.Parse;
  public function do_something(){
    //-------------------Normalized classes--combinators
    final parser       = Parsers.Something().many().and(Parsers.Eof());
    final parse_result = parser.apply(string.reader());//ParseResult
    final upshot       = parse_result.toUpshot();//To integrate into rest of program via stx.Fail
  }
```

String parsers are located at `stx.parse.parsers.StringParsers`
```haxe
  import stx.parse.parsers.StringParsers.*;//import to local namespace
  import stx.parse.parsers.StringParsers as SP;//named
  final ps = __.parse().parsers().string();//Wildcard access
```
```haxe
  /**
   * A parser maps an Input `to a Result
   */
  public function apply(p:ParseInput<I>):ParseResult<I,O>;
```

21/04/2023
  Going to require 4.3.0 now because finally the regular expression libray is standardised across targets.
  Removed asynchronicity due to performance, you can always patch it in yourself, it just doesn't bode well to 
  add extra function calls at this level.

21/07/2021
  <s>Asynchronous</s> Left Recursive Pack Rat Parser
   
25/06/2020
  - Now supports incremental data, asyncronous Parsers
      `Process<ParseInput<I>,ParseInput<I>>` at the input stage or
      `Process<ParseResult<I,O>,ParseResult<I,O>> at the output
      
Forked from https://github.com/sledorze/parsex

More info here:
http://lambdabrella.blogspot.com/2012/01/packrat-parser-combinators-for-haxe.html

Original implementation derived from Scala's packrat parser library.

Special thanks goes to Marc Weber and Laurence Taylor for supporting the effort.
    
- optional:
  * monax if you want to use monad like syntax:
  https://github.com/sledorze/monax


Uses the Fletcher function type: `ParseInput<I> -> Terminal<ParseResult<O>> -> Work`.