package stx.parse.parser.term;

import hre.*;
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
  inline function apply(ipt:ParseInput<String>){
    var reg         = new EReg(stamp,"g");
    //var ereg        = new RegExp(stamp,"g");
    var is_matched  = ipt.matchedBy(reg.match);
    __.log().debug('stamp="$stamp" is_matched="$is_matched" ');
    return if (is_matched) {
      var match         = reg.matched(0);
      //new RegExp(stamp,"g").parsify(ipt);//TODO
      var length        = match.length;
      ipt.drop(length).ok(ipt.take(length));
    }else{
      ipt.erration('$stamp not matched to |||${ipt.take()}|||',false).failure(ipt);
    }
  }
  override public function toString(){
    return '~/$stamp/';
  }
}