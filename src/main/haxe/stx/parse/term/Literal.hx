package stx.parse.term;

@:note("neko throws without explicit typing of ipt.content.data")
@:access(stx.parse) class Literal extends stx.parse.pack.parser.term.Base<String,String,Parser<String,String>>{
  override function do_parse(ipt:Input<String>):ParseResult<String,String>{
    //trace('"${ipt.content.data}" ${ipt.offset}');
    var all  : String = ipt.content.data;
    var data : String = all.substr(ipt.offset);
    var code = StringTools.fastCodeAt;
    var has  = Parse.range;
    var q    = 34;
    var ok   = code(data,0) == 34;
    var idx  = 1;

    if(ok){
      while(true){
        switch(code(data,idx)){
          case 92 :  
            if(code(data,idx+1) == 34){
              idx+=2;
            }else{
              idx+=1;
            }
          case 34 : 
            idx+=1;
            break;
          default : 
            idx++;
        }
      }
    }
    var out = ipt.take(idx);
        out = out.substr(1,out.length-2);
    return idx > 1 ? ipt.drop(idx).ok(out) : ipt.fail('not matched');
  }
}