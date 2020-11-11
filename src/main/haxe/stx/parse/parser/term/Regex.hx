package stx.parse.parser.term;

import hre.*;
/**
  The Input pulls from the offset to the end of the string, so I suggest leading the regex with "^".
**/
class Regex extends Sync<String,String>{
  var stamp : String;
  public function new(stamp,?id:Pos){
    super(id);
    this.stamp = stamp;
    this.tag   = Some('Regex($stamp)');
  }
  override inline function apply(ipt:Input<String>){
    var ereg        = new RegExp(stamp,"g");
    var is_matched  = ipt.matchedBy(ereg.test);
    __.log().debug('stamp="$stamp" is_matched="$is_matched" ');
    return if (is_matched) {
      var match         = new RegExp(stamp,"g").parsify(ipt);//TODO
      var length        = match.groups[0].length;
      ipt.drop(length).ok(ipt.take(length));
    }else{
      ipt.fail('$stamp not matched to |||${ipt.take()}|||',false,pos);
    }
  }
}