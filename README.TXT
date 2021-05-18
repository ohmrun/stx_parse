Left Recursive Parser Combinator Library.

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