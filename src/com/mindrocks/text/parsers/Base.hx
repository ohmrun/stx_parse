package com.mindrocks.text.parsers;

class Base<I,O,T> implements Interface<I,O>{
  public var id                 : Pos;
  public var uid(default,null)  : Int;
  public var tag                : Option<String>;

  private var delegation        : T;
  public function new(?delegation,?id:PosInfos){
    this.delegation = delegation;
    this.id         = id;
    this.tag        = Some(name());
  }
  public function report(){

  }
  function check(){
  
  }
  final public function parse(ipt:Input<I>):ParseResult<I,O>{
    switch(this.tag){
      case Some(v)  : ipt.tag = v;
      case null     :   
      default       : 
    }
    check();
    return do_parse(ipt);
    // return try{on
      
    // }catch(e:Dynamic){
    //   Failure('exception: $e'.errorAt(ipt).newStack(), ipt, true);
    // }
    
  }
  private function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return "default implementation".errorAt(ipt).newStack().toParseResult(ipt,true);
  }
  public function asParser():Parser<I,O>{
    return Parser.lift(this);
  }
  function succeed(x:O,xs:Input<I>):ParseResult<I,O>{
    return Success(x,xs);
  }
  function failed(stack,xs,isError):ParseResult<I,O>{
    return Failure(stack,xs,isError);
  }
  function name(){
    return Type.getClassName(Type.getClass(this)).split(".").pop();
  }
}