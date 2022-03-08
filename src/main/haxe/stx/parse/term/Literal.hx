package stx.parse.term;

import stx.parse.Parsers.*;

@:note("neko throws without explicit typing of input.content.data")
@:access(stx.parse) class Literal extends stx.parse.parser.term.SyncBase<String,String,Parser<String,String>>{
  
  public function apply(input:ParseInput<String>):ParseResult<String,String>{
    var all  : String = input.content.data;
    var data : String = all.substr(input.offset);
    var code = StringTools.fastCodeAt;
    var has  = Range;
    var q    = 34;
    var fst  = code(data,0);
    if(fst == 39){
      q = 39;
    }
    var ok   = q == fst;
    var idx  = 1;
     
    if(ok){
      while(true){
        __.log().trace(data);
        switch(code(data,idx)){
          case 92 :  
            if(code(data,idx+1) == q){
              idx+=2;
            }else{
              idx+=1;
            }
          case x if (x == q) : 
            idx+=1;
            break;
          default : 
            idx++;
        }
      }
    }
    var out : String = input.take(idx);
        out = out.substr(1,out.length-2);
    return idx > 1 ? input.drop(idx).ok(out) : input.fail('Literal');
  }
}