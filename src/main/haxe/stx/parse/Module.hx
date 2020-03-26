package stx.parse;

class Module extends Clazz{
	
	public function greedy<I,O>(prs:Parser<I,O>):Parser<I,Array<O>>{
		return prs.many().and_(eof());
	}
}
