package stx.parse.parser.term;

class Identifier extends Sync<String,String>{
  var stamp : String;
  public function new(stamp,?id:Pos){
    super(id);
    this.stamp = stamp;
  }
  inline public function apply(ipt:ParseInput<String>){
    var len     = stamp.length;
    var head    = ipt.head();
    var offset  = ipt.offset;
    var string  = ipt.take(len);

    #if debug
    __.log().trace('len=$len offset=$offset head:"$head" stamp:"$stamp" string:"$string"');
    #end
    return if(string == stamp) {
      var next = ipt.drop(stamp.length);
      //trace(next);
      next.ok(stamp);
    }else{
      ipt.erration('"Identifier expected *** $stamp *** instead found: *** $string ***',false).failure(ipt);
    }
  }
  override public function toString(){
    return '"$stamp"';
  }
}