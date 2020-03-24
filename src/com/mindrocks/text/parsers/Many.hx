package com.mindrocks.text.parsers;

class Many<I,O> extends Base<I,stx.core.pack.Array<O>,Parser<I,O>>{
  public function new(delegation:Parser<I,O>,?id:Pos){
    __.that(id).exists().errata( e -> e.fault().of(UndefinedParserInConstructor(this))).crunch(delegation);
    super(delegation,id);
    this.tag = switch (delegation.tag){
      case Some(v)  : Some('($v)*');
      default       : None;
    }
  }
  override public function check(){
    __.that(id).exists().errata( e -> e.fault().of(UndefinedParseDelegate())).crunch(delegation);
  }
  override function do_parse(input:Input<I>):ParseResult<I,Array<O>>{
    var arr     = [];
    var n_input = input;

    while (true) {
      var res : ParseResult<I,O> = delegation.parse(n_input);
      switch (res) {
        case Success(m, r): 
          arr.push(m); 
          n_input = r;
        case Failure(_, _, true):
            return res.elide();
        default :
          break;
      }
    }
    //trace(arr);
    return Success(arr, n_input);
  }

}