package stx.parse.term;

import stx.parse.Parsers.*;

enum SimpleTokenSum{
  Token(arr:Cluster<String>);
  NotToken(str:String);
}
@:forward abstract SimpleTokenParser(Parser<String,Cluster<SimpleTokenSum>>){
  public function new(){
    this = p_parse; 
  }
  static public var p_path  = Rep1Sep(Parse.valid.one_many().tokenize(),Identifier('.'));
  static public var p_token = Identifier('$')._and(Identifier('{'))._and(p_path).and_(Identifier('}'));

  static public var p_parse = 
    Identifier('$').lookahead().not()._and(Something()).one_many().tokenize().then(NotToken).or(p_token.then(Token)).many().and_(Eof());
}