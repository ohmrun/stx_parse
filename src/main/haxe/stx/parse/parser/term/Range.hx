package stx.parse.parser.term;

class Range extends Sync<String,String>{
  
  var min : Int;
  var max : Int;

  public function new(min,max,?pos:Pos){
    super(pos);
    this.min = min;
    this.max = max;
  }
  override inline public function apply(ipt:ParseInput<String>):ParseResult<String,String>{
    return switch(ipt.head()){
      case Some(s) : 
        var x = StringTools.fastCodeAt(s,0);
        var v = __.option(x);
        var l = v.map( x -> x >= min).defv(false);
        var r = v.map( x -> x <= max).defv(false);
        l && r ? ipt.tail().ok(s) : ipt.fail('range: $min -> $max');
      default : 
        ipt.fail('null head');
    }
  }
  override public function toString(){
    var l = String.fromCharCode(min);
    var r = String.fromCharCode(max);
    return 'Range($l...$r)';
  }
}