package stx.parse.parser.term;

class Closed<I,O> extends Base<I,O,Provide<ParseResult<I,O>>>{
  inline public function defer(input:ParseInput<I>,cont:Terminal<ParseResult<I,O>,Noise>):Work{
    return cont.receive(this.delegation.forward(Noise));
  }
}