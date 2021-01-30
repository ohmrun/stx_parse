package stx.parse.parser.term;
class Or<P,R> extends ParserCls<P,R>{
  var lhs : Parser<P,R>;
  var rhs : Parser<P,R>;

  public function new(lhs,rhs,?pos:Pos){
    super(pos);
    this.lhs = lhs;
    this.rhs = rhs;
  }
  inline function defer(input:ParseInput<P>,cont:Terminal<ParseResult<P,R>,Noise>):Work{
    return lhs.defer(
      input,
      cont.joint(
        (outcome:Reaction<ParseResult<P,R>>) -> outcome.fold(
          (result)  -> {
            return result.fold(
              ok -> cont.value(ok.toParseResult()).serve(),
              no -> rhs.defer(input,cont)
            );
          },
          (error)   -> cont.error(error).serve()
        )
      )
    );
  }
  inline public function apply(input:ParseInput<P>):ParseResult<P,R>{
    var fst = lhs.apply(input);
    return fst.ok().if_else(
      () -> fst,
      () -> rhs.apply(input)
    );
  }
  override public function toString(){
    return '$lhs | $rhs';
  }
}       
