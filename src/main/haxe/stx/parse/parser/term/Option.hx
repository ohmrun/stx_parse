package stx.parse.parser.term;

import stx.ext.alias.StdOption;

class Option<I,T> extends Base<I,StdOption<T>,Parser<I,T>>{
  public function new(delegation:Parser<I,T>,?id:Pos){
    super(delegation,id);
  }
  override function defer(input:Input<I>,cont:Terminal<ParseResult<I,StdOption<T>>,Noise>):Work{
    return delegation.then(Some)
      .or(Succeed.pure(stx.Option.unit()).asParser())
      .defer(input,cont);
  }
  override public function apply(input:Input<I>):ParseResult<I,StdOption<T>>{
    return this.convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> delegation.apply(input).map(__.option)
    );
  }
  override public function get_convention(){
    return this.delegation.convention;
  }
}