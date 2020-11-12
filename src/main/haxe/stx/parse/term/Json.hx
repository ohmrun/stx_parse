package stx.parse.term;

import stx.parse.parser.term.LAnon;

enum JsonSum<T>{
  JsObject(record : Array<Couple<String,JsonSum<T>>>);
  JsArray(array : Array<JsonSum<T>>);
  JsData(x : T);
}

class Json{
  public function new(){}
  
  static  var l_acc_p         = spaced("{".id());
  static  var r_acc_p         = spaced("}".id());
  static  var l_brkt_p        = spaced("[".id());
  static  var r_brkt_p        = spaced("]".id());
  
  static var nada             = spaced('null'.id());
  static var comma_p          = spaced(",".id());

  static function spaced<I,T>(p : Parser<String,T>) 
      return Parse.whitespace.many()._and(p).tagged('spaced: (${p.tag.defv('')})');

  //static var ident_p          = spaced(Parse.literal);
  //Parse.valid.or('-'.id().one_many().token())
  static var lit_content_p    = '"'.id().not()._and(Parse.anything()).many().token().tagged("lit_content");
  static var ident_p          = spaced('"'.id())._and(lit_content_p).and_('"'.id());

  static var integer                               
    = spaced(Parse.range(48, 57).predicated().one_many().token());

  static var data_p : Parser<String,JsonSum<String>>       
    = ident_p.or(integer).or(spaced(Parse.truth)).or(nada).then(JsData).tagged("data_p");
    
  function value_p():Parser<String,JsonSum<String>> 
    return [parser(), data_p, array_p()].ors(); 

  function array_p():Parser<String,JsonSum<String>> 
    return l_brkt_p._and(value_p.defer().repsep(comma_p)).and_(r_brkt_p).then(JsArray);

  function entry_p() 
    return ident_p.and_(spaced(':'.id())).and(value_p());

  function entries_p() 
    return entry_p().repsep(comma_p).commit();

  function parser():Parser<String,JsonSum<String>>{
    return new LAnon(
      () -> 
        l_acc_p
        ._and(entries_p())
        .and_(r_acc_p)
        .then(JsObject)
        .asParser()
    ).asParser().tagged('json').memo();
  }
  function parse(ipt:ParseInput<String>):ParseResult<String,JsonSum<String>>{
    return parser().and_(Parse.eof()).parse(ipt);
  }
}