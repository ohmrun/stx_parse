package stx.parse.term;

enum SimpleTokenSum{
  Token(arr:Array<String>);
  NotToken(str:String);
}
@:forward abstract SimpleTokenParser(Parser<String,Array<SimpleTokenSum>>){
  public function new(){
    this = p_parse; 
  }
  static public var p_path  = Parsers.rep1sep(Base.valid.oneMany().token(),'.'.id());
  static public var p_token = '$'.id()._and('{'.id())._and(p_path).and_('}'.id());

  static public var p_parse = 
    '$'.id().lookahead().not()._and(Base.anything()).oneMany().token().then(NotToken).or(p_token.then(Token)).many().and_(Parser.eof());
}
