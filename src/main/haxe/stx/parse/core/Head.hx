package stx.parse.core;

typedef HeadDef = {
  headParser        : Parser<Dynamic,Dynamic>,
  involvedSet       : LinkedList<Parser<Dynamic,Dynamic>>,
  evalSet           : LinkedList<Parser<Dynamic,Dynamic>>
}

@:forward abstract Head(HeadDef) from HeadDef{
  public function getHead<I,T>() : Parser < I, T > {
    return cast(this.headParser);
  }
}