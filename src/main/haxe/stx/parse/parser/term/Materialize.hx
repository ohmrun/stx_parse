package stx.parse.parser.term;

class Materialize<I,O> extends Base<I,O,Parser<I,O>>{
  public function apply(ipt:ParseInput<I>):ParseResult<I,O>{
    final result = delegation.apply(ipt);
    return 
      if(result.is_defined()){
        result;
      }else{
        result.asset.erration('result of $delegation is not defined ').failure(result.asset);
      }
  }
}