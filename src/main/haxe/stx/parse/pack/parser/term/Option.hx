package stx.parse.pack.parser.term;

import stx.ext.alias.StdOption;

class OptionP<I,T> extends Base<I,StdOption<T>,Parser<I,T>>{
  public function new(delegation:Parser<I,T>,?id){
    super(delegation,id);
  }
  override function applyII(input:Input<I>,cont:Terminal<ParseResult<I,StdOption<T>>,Noise>):Work{
    return delegation.then(Some)
      .or(Succeed.pure(Option.unit()).asParser())
      .applyII(input,cont);
  }
}