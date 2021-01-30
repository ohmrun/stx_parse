package stx.parse.parser.term;

class Identifier extends Sync<String,String>{
  var stamp : String;
  public function new(stamp,?id:Pos){
    super(id);
    this.stamp = stamp;
  }
  inline function apply(ipt:ParseInput<String>){
    //__.log().info(ipt);
    var len     = stamp.length;
    var head    = ipt.head();
    var offset  = ipt.offset;
    var string  = ipt.take(len);

    //trace('len=$len offset=$offset head:"$head" stamp:"$stamp" string:"$string"');
    return if(string == stamp) {
      var next = ipt.drop(stamp.length);
      //trace(next);
      next.ok(stamp);
    }else{
      ipt.fail('"Identifier expected *** $stamp *** instead found: *** $string ***',false,pos);
    }
  }
  override public function toString(){
    return '"$stamp"';
  }
}