package stx.parse.pack.parser.term;

class Base<I,O,T> implements ParserApi<I,O> extends Clazz{
  public var id                 : Pos;
  public var uid(default,null)  : Int;
  public var tag                : Option<String>;

  private var delegation        : T;

  public function new(?delegation,?id:Pos){
    super();
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
    var result    = do_parse(ipt);
    var value     = result.value();
    //trace('$tag $value');
    return result;
    // return try{on
      
    // }catch(e:Dynamic){
    //   Failure('exception: $e'.errorAt(ipt).newStack(), ipt, true);
    // }
    
  }
  private function do_parse(ipt:Input<I>):ParseResult<I,O>{
    return ParseFailure.at_with(ipt,"default implementation",true);
  }
  public inline function asParser():Parser<I,O>{
    return Parser.lift(this);
  }
  inline public function name(){
    return this.identifier();
  }
  public function toString(){
    var id_s = Position.fromPos(id).toStringClassMethodLine();
    return '${name()} $tag $id_s';
  }
}