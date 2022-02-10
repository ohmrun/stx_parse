package stx.parse.term;

import stx.parse.Parsers.*;

enum JsonSum<T>{
  JsObject(record : Cluster<Couple<String,JsonSum<T>>>);
  JsArray(array : Cluster<JsonSum<T>>);
  JsData(x : T);
}

class Json{
  public function new(){}
  
  static  var l_acc_p         = spaced(Identifier("{"));
  static  var r_acc_p         = spaced(Identifier("}"));
  static  var l_brkt_p        = spaced(Identifier("["));
  static  var r_brkt_p        = spaced(Identifier("]"));
  
  static var nada             = spaced(Identifier('null'));
  static var comma_p          = spaced(Identifier(","));

  static function spaced<I,T>(p : Parser<String,T>) 
      return Parse.whitespace.many()._and(p).tagged('spaced: (${p.tag.defv('')})');

  //static var ident_p          = spaced(Parse.literal);
  //Parse.valid.or('-'.id().one_many().token())
  static var lit_content_p    = Identifier('"').not()._and(Something()).many().tokenize().tagged("lit_content");
  static var ident_p          = spaced(Identifier('"'))._and(lit_content_p).and_(Identifier('"'));

  static var integer                               
    = spaced(Range(48, 57).one_many().tokenize());

  static var data_p : Parser<String,JsonSum<String>>       
    = ident_p.or(integer).or(spaced(Parse.boolean)).or(nada).then(JsData).tagged("data_p");
    
  function value_p():Parser<String,JsonSum<String>> 
    return [parser(), data_p, array_p()].ors(); 

  function array_p():Parser<String,JsonSum<String>> 
    return l_brkt_p._and(value_p.defer().repsep(comma_p)).and_(r_brkt_p).then(JsArray);

  function entry_p() 
    return ident_p.and_(spaced(Identifier(':'))).and(value_p());

  function entries_p() 
    return entry_p().repsep(comma_p).commit();

  public function parser():Parser<String,JsonSum<String>>{
    return LAnon(
      () -> 
        l_acc_p
        ._and(entries_p())
        .and_(r_acc_p)
        .then(JsObject)
        .asParser()
    ).asParser().tagged('json').memo();
  }
  function main(ipt:ParseInput<String>){
    return parser().and_(Parsers.Eof());
  }
}