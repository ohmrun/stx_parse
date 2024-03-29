package stx.parse;

import stx.parse.Parsers.*;

class Module extends Clazz{	
	public function greedy<I,O>(prs:Parser<I,O>):Parser<I,Cluster<O>>{
		return prs.many().and_(Eof());
	}
	public inline function alts<I,O>(arr:Cluster<Parser<I,O>>){
    return arr.lfold1((next,memo:Parser<I,O>) -> Or(memo,next).asParser()).defv(
			Parsers.Failed('not one alternative specified').asParser()
		);
	}
	public inline function when<I>(fn:I->Bool):Parser<I,I>{
		return When(fn);
	}
	public inline function inspect(?prefix,?postfix,?pos:Pos){
		return Inspect(prefix,postfix,pos);
	}
	public function parsers(){
		return new stx.parse.module.Parsers();
	}
}
