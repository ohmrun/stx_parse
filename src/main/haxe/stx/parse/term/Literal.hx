package stx.parse.term;

@:access(com.mindrocks) class Literal extends com.mindrocks.text.parsers.Base<String,String,Parser<String,String>>{
  override function do_parse(ipt:Input<String>){
    var data : String = ipt.content.data.substr(ipt.offset);
    var code = StringTools.fastCodeAt;
    var has  = Base.range;
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
    return idx > 1 ? Success(out,ipt.drop(idx)) : 'not matched'.no(ipt);
  }
}