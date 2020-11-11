package stx.parse;

class Module extends Clazz{	
	public function greedy<I,O>(prs:Parser<I,O>):Parser<I,Array<O>>{
		return prs.many().and_(Parse.eof());
	}
	public inline function reg(str:String):Parser<String,String>{
		return Parser.Regex(str).asParser();
	}
	public inline function id(str:String):Parser<String,String>{
		return Parser.Identifier(str);
	}
	public inline function alts<I,O>(arr:Array<Parser<I,O>>){
    return arr.lfold1((next,memo:Parser<I,O>) -> new Or(memo,next).asParser());
  }
}
