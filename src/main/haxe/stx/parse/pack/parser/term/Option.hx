package stx.parse.pack.parser.term;

import stx.core.alias.StdOption;

class OptionP<I,T> extends Base<I,StdOption<T>,Parser<I,T>>{
  public function new(delegation:Parser<I,T>,?id){
    super(delegation,id);
  }
  override function do_parse(ipt:Input<I>):ParseResult<I,StdOption<T>>{
    __.that().exists().errata(
      e -> e.fault().of(E_UndefinedParseDelegate(ipt))
    ).crunch(delegation);
    return delegation
      .then(Some)
      .or(
        Succeed.pure(None)
      ).parse(ipt);
  }
}