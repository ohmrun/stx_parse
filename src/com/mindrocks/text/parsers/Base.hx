package com.mindrocks.text.parsers;

class Base<I,O,T> implements Interface<I,O>{
  public var id                 : Pos;
  public var uid(default,null)  : Int;
  public var tag                : Option<String>;

  private var delegation        : T;
  public function new(?delegation,?id:Pos){
    this.delegation = delegation;
    this.id         = id;
    this.tag        = Some(name());
  }
  function check(){
  
  }
  final inline public function parse(ipt:Input<I>):ParseResult<I,O>{
    switch(this.tag){
      case Some(v)  : ipt.tag = v;
      case null     :   
      default       : 
    }
    #if test
      check();
    #end
    return do_parse(ipt);
    // return try{on
      
    // }catch(e:Dynamic){
    //   Failure('exception: $e'.errorAt(ipt).newStack(), ipt, true);
    // }
    
  }
  private function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return "default implementation".errorAt(ipt).newStack().toParseResult(ipt,true);
  }
  public inline function asParser():Parser<I,O>{
    return Parser.lift(this);
  }
  inline function succeed(x:O,xs:Input<I>):ParseResult<I,O>{
    return Success(x,xs);
  }
  inline function failed(stack,xs,isError):ParseResult<I,O>{
    return Failure(stack,xs,isError);
  }
  public function report(error,xs,?isError=false):ParseResult<I,O>{
    return Failure(
      error.next(__.fault(this.id).of(NamedParseFailure(this.tag.def(name)))),
      xs,
      isError
    );
  }
  inline public function name(){
    return Type.getClassName(Type.getClass(this)).split(".").pop();
  }
}