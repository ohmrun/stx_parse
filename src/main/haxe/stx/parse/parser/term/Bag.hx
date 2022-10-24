package stx.parse.parser.term;

class Bag<I,O> extends Base<I,Array<O>,Array<Parser<I,O>>>{
  public function new(delegation,?id:Pos){
    super(delegation,id);
  }
  public function apply(input:ParseInput<I>):ParseResult<I,Array<O>>{
    final parsers = delegation;
    function rec(input:ParseInput<I>,arr:Array<O>){
      if(parsers.length == 0){
        return input.ok(arr);
      }else{
        var pr  = null;
        var res = null;
        for(p in delegation){
          res = p.apply(input);
          if (res.is_ok()){
            pr  = p;
            break;  
          }
        }
        return if(res.is_ok()){
          parsers.remove(pr);
          for(x in res.value){
            arr.push(x);
          }
          rec(res.asset,arr);
        }else{
          input.no('Bag failed');
        }
      }
    }
    return rec(input,[]);
  }
}