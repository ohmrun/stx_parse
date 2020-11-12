package stx.parse;

class Module extends Clazz{	
	public function greedy<I,O>(prs:Parser<I,O>):Parser<I,Array<O>>{
		return prs.many().and_(Parser.Eof());
	}
	public inline function reg(str:String):Parser<String,String>{
		return Parser.Regex(str).asParser();
	}
	public inline function id(str:String):Parser<String,String>{
		return Parser.Identifier(str);
	}
	public inline function alts<I,O>(arr:Array<Parser<I,O>>){
    return arr.lfold1((next,memo:Parser<I,O>) -> Parser.Or(memo,next).asParser());
	}
	public inline function when<I>(fn:I->Bool):Parser<I,I>{
		return Parser.When(fn);
	}
	public inline function inspect(prefix,postfix,?pos:Pos){
		return Parser.Inspect(prefix,postfix,pos);
	}
}
