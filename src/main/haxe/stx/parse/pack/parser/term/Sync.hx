package stx.parse.pack.parser.term;

class Sync<P,R> extends Direct<P,R>{

  public function new(?id){
    super(id);
  }
  override function doApplyII(ipt:Input<P>,cont:Terminal<ParseResult<P,R>,Noise>){
    return cont.value(this.do_parse(ipt)).serve();
  }
  private function do_parse(input:Input<P>):ParseResult<P,R>{
    return input.fail('abstract method');
  }
}