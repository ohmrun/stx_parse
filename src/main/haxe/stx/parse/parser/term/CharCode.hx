package stx.parse.parser.term;

class CharCode extends Sync<String,String>{
  final code : Int;
  public function new(code,?id){
    super(Some('code'),id);
    this.code = code;
  }
  public function apply(ipt:ParseInput<String>):ParseResult<String,String>{
    return ipt.head().fold(
      ok -> ok.charCodeAt(0) == code ? ipt.tail().ok(ok) : ipt.no('charcode not #$code'),
      e   -> ipt.erration('code failed').concat(e.toParseFailure_with(ipt,false)).failure(ipt),
      ()  -> ipt.no('code failed')
    );
  }
  override public function toString(){
    final v = String.fromCharCode(code);
    return "'" + v + "'";
  }
}
