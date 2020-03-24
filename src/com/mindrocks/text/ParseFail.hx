package com.mindrocks.text;

import com.mindrocks.text.ParseResult;

abstract ParseFail(ParseResult<Dynamic,Dynamic>) to ParseResult<Dynamic,Dynamic>{
  static public var FAIL = 'FAIL';
  function new(self){
    this = self;
  }
  @:noUsing static public function at<I,T>(ipt:Input<I>):ParseFail{
    return new ParseFail(FAIL.errorAt(ipt).newStack().toParseResult(ipt,false));
  }
}