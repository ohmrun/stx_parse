package stx.parse.parser.term;

class Many<I,O> extends Base<I,Array<O>,Parser<I,O>>{
  public function new(delegation:Parser<I,O>,?id:Pos){
    #if test
    __.assert(id).exists(delegation);
    #end
    super(delegation,id);
    this.tag = switch (delegation.tag){
      case Some(v)  : Some('($v)*');
      default       : None;
    }
  }
  override public function check(){
    __.that(pos).exists().errata( e -> e.fault().of(E_UndefinedParseDelegate())).crunch(delegation);
  }
  public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>):Work{
    function rec(input:ParseInput<I>,cont:Terminal<ParseResult<I,Array<O>>,Noise>,arr:Array<O>){
      __.log().trace(_ -> _.thunk(() -> arr));
      return cont.receive(delegation.toFletcher().forward(input).flat_fold(
        res  -> {
          __.log().trace('$delegation');
          __.log().trace('${res.error}');
          __.log().trace('$arr');
            return res.is_ok().if_else(
            () -> {
              __.log().trace('${res.value}');
              res.value.fold(
                v   -> { arr.push(v); null; },
                ()  -> {}
              );
              return Fletcher.lift(Fletcher.Anon(rec.bind(_,_,arr))).forward(res.asset);
            },
            () -> cont.value(
              if(res.is_fatal()){
                input.erration('failed many ${delegation}',true).concat(res.error).failure(input);
              }else{
                __.log().trace(_ -> _.thunk( () -> arr));
                input.ok(arr); 
              }
            )
          );
        },
        no   -> cont.error(no)
      ));
    }
    return cont.receive(Fletcher.lift(Fletcher.Anon(rec.bind(_,_,[]))).forward(input));
  }
  override public function toString(){
    return 'Many($delegation)';
  }
}