package stx.parse.parser.term;

/**
  The ParseInput pulls from the offset to the end of the string, so I suggest leading the regex with "^".
**/
class Regex extends Sync<String,String>{
  var stamp : String;
  public function new(stamp,?id:Pos){
    super(id);
    this.stamp = stamp;
    this.tag   = Some('Regex($stamp)');
  }
  public inline function apply(ipt:ParseInput<String>){
    var reg         = new EReg(stamp,"g");
    //var ereg        = new RegExp(stamp,"g");
    var is_matched  = ipt.matchedBy(reg.match);
    __.log().debug('stamp="$stamp" matching: ${ipt.take(100)} is_matched="$is_matched" ');
    return if (is_matched) {
      var match         = reg.matched(0);
      //new RegExp(stamp,"g").parsify(ipt);//TODO
      var length        = match.length;
      final next = ipt.drop(length);
      final data = ipt.take(length);
      @:privateAccess __.log().debug('length ${match.length} data $data index: ${next.content.index}');
      next.ok(data);
    }else{
      ipt.erration('$stamp not matched to |||${ipt.take()}|||',false).failure(ipt);
    }
  }
  override public function toString(){
    return '~/$stamp/';
  }
}