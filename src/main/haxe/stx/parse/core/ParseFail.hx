package stx.parse.core;

abstract ParseFail(ParseResult<Dynamic,Dynamic>) to ParseResult<Dynamic,Dynamic>{
  static public var(default,never) FAIL = 'FAIL';

  private function new(self){
    this = self;
  }
  @:noUsing static public function at<I,T>(ipt:Input<I>,?pos:Pos):ParseFail{
    return new ParseFail(ipt.fail(FAIL,pos));
  }
}