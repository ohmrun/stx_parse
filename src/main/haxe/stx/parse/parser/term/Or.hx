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
    __.log().trace('$this');
    return cont.receive(
      lhs.toFletcher().forward(input).flat_fold(
        (result)  -> result.is_ok().if_else(
          () -> cont.value(result),
          () -> rhs.toFletcher().forward(input)
        ),
        (error)   -> cont.error(error)
      )
    );
  }
  override public function toString(){
    return '$lhs | $rhs';
  }
}       
