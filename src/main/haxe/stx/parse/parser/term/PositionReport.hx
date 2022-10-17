package stx.parse.parser.term;

using StringTools;

class PositionReport<O> extends SyncBase<String,O,Noise>{
  final cursor : Int;
  final error  : String;

  public function new(cursor:Int,?error:String,?pos){
    super(pos);
    this.cursor = cursor;
    this.error  = error;
  }
  inline public function apply(ipt:ParseInput<String>):ParseResult<String,O>{
    var count   : Int = 0;
    var line    : Int = 1;
    var column  : Int = 0;
    var i             = ipt;
    var result        = ipt.no('default error');
    while(true){
      if(count == cursor){
        result =  ipt.no(E_Parse_ParseFailed(this.error,{ line : line, column : column}),true);
        break;
      }else if(@:privateAccess i.content.match((x:String) -> x.startsWith('\n'))){
        line    = line + 1;
        column  = 0;
        count   = count + 1;
        i       = i.tail();
      }else if(@:privateAccess i.content.match((x:String) -> x.startsWith('\r\n'))){
        line    = line + 1;
        column  = 0;
        count   = count + 2;
        i       = i.tail().tail();
      }else{
        count   = count + 1;
        column  = column + 1;
        i       = i.tail();
      }
    }
    return result; 
  }
}