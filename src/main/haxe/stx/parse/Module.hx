package stx.parse;

class Module extends Clazz{
	public function eof<I,O>():Parser<I,O>{
    return new Parser(Parser.Anon(ParserLift.eof));
	}
	public function any<I>():Parser<I,I>{
		return Parse.anything();
	}
	public function greedy<I,O>(prs:Parser<I,O>):Parser<I,Array<O>>{
		return prs.many().and_(eof());
	}
}
