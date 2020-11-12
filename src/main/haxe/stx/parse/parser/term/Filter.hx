package stx.parse.parser.term;

class Filter<I,O> extends Base<I,O,Parser<I,O>>{
  var predicate : O -> Bool;
  public function new(delegation:Parser<I,O>,predicate:O->Bool,?id:Pos){
    super(delegation,id);
    this.predicate = predicate;
    super(
      new AndThen(delegation,(o:O) -> this.predicate(o) ? Parser.Succeed(o) : Parser.Failed("predicate failed") ).asParser()
      ,id
    );
  }
  override public function defer(ipt:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.defer(ipt,cont);
  }
  override public function apply(i:ParseInput<I>):ParseResult<I,O>{
    return throw IncorrectCallingConvention;
  }
}