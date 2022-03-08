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
    __.log().trace(_ -> _.thunk( () -> '$this'));
    return cont.receive(
      lhs.toFletcher().forward(input).flat_fold(
        (result)  -> {
          __.log().trace(_ -> _.pure('result $lhs = ${result.is_ok()}'));
          return result.is_ok().if_else(
            () -> cont.value(result),
            () -> {
              __.log().trace(_ -> _.pure('try $rhs'));
              return rhs.toFletcher().forward(input);
            }
          );
        },
        (error)   -> cont.error(error)
      )
    );
  }
  override public function toString(){
    return '$lhs | $rhs';
  }
}       
