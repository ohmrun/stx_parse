package stx.parse.pack.parser.term;

import hre.*;
class Regex extends Sync<String,String>{
  var stamp : String;
  public function new(stamp,?id){
    super(id);
    this.stamp = stamp;
    this.tag   = Some('Regex($stamp)');
  }
  override function do_parse(ipt:Input<String>){
    var ereg        = new RegExp(stamp,"g");
    var is_matched  = ipt.matchedBy(ereg.test);
    //trace('stamp="$stamp" is_matched="$is_matched" ');
    return if (is_matched) {
      var match         = new RegExp(stamp,"g").parsify(ipt);//TODO
      var length        = match.groups[0].length;
      ipt.drop(length).ok(ipt.take(length));
    }else{
      ipt.fail('$stamp not matched to |||${ipt.take()}|||',false,id);
    }
  }
}