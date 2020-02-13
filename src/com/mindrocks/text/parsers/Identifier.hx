package com.mindrocks.text.parsers;

class Identifier extends Direct<String,String>{
  var stamp : String;
  public function new(stamp,?id){
    super(id);
    this.stamp = stamp;
    this.tag   = Some('Id($stamp)');
  }
  override function do_parse(ipt:Input<String>){
    var len     = stamp.length;
    var head    = ipt.head();
    var offset  = ipt.offset;
    var string  = ipt.take(len);

    //trace('len=$len offset=$offset head:"$head" stamp:"$stamp" string:"$string"');
    return if(string == stamp) {
      var next = ipt.drop(stamp.length);
      //trace(next);
      stamp.yes(next);
    }else{
      failed(
        '"$stamp" expected instead found: "$string"'.errorAt(ipt).newStack()
        , ipt
        , false
      );
    }
  }
}