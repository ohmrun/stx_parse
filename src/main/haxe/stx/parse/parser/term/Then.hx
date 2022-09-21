package stx.parse.parser.term;

abstract class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  
  public function new(delegation:Parser<I,T>,?pos:Pos){
    super(delegation,pos);
    this.tag        = delegation.tag;
  }
  abstract function transform(t:T):U;

  override public function check(){
    __.that(pos).exists().errata(e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,U>,Noise>){
    __.log().trace('$delegation then');
    return cont.receive(delegation.toFletcher().forward(input).map(
      (res:ParseResult<I,T>) -> res.is_ok().if_else(
        ()          -> {
          __.log().trace('then');
          final result = res.map(transform);
          __.log().trace('thened ${result.toRes()}');
          return result;
        },
        ()          -> res.fails()
      )
    ));
  }
  override public function toString(){
    return '$delegation&';
  }
}