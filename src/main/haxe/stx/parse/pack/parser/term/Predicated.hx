package stx.parse.pack.parser.term;

class Predicated<I,O> extends Base<I,O,Parser<I,O>>{
  var predicate : O -> Bool;
  public function new(delegation:Parser<I,O>,predicate:O->Bool,?id:Pos){
    super(delegation,id);
    this.predicate = predicate;
    super(
      new AndThen(delegation,(o:O) -> this.predicate(o) ? Parser.Succeed(o) : Parser.Failed("predicate failed") ).asParser()
      ,id
    );
  }
  override public function defer(ipt:Input<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return this.delegation.defer(ipt,cont);
  }
  override public function apply(i:Input<I>):ParseResult<I,O>{
    return throw IncorrectCallingConvention;
  }
}