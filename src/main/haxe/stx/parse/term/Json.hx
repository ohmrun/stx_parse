package stx.parse.term;

import stx.parse.Parsers.*;

enum JsonSum<T>{
  JsObject(record : Ensemble<JsonSum<T>>);
  JsArray(array   : Cluster<JsonSum<T>>);
  JsData(x : T);
}
class JsonSumLift{
  // static public function toStringWith(self:JsonSum<T>,with:{ show : T -> String, indent : String = '\t', level : Int = 0 } ){
  //   var indent_string = '';
  //   for( i in with.level ){
  //     indent_string = indent_string + with.indent;
  //   }
  //   final is =  indent_string;

  //   return switch(self){
  //     case JsObject(record):
  //       final arr = [];
  //       for(k => v in record){
  //         var isi = '${is}${level.indeng}';  
  //         arr.push('${isi}')
  //       }
  //     case JsArray(array):
  //     case JsData(x):
  //   }
  // }
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
    return l_brkt_p._and(value_p.defer().repsep(comma_p).option()).and_(r_brkt_p).then(
      (opt) -> opt.fold(
        ok -> JsArray(ok),
        () -> JsArray([].imm())
      )
    );

  function entry_p() 
    return ident_p.and_(spaced(Identifier(':'))).and(value_p());

  function entries_p() 
    return entry_p().repsep(comma_p).commit();

  public function parser():Parser<String,JsonSum<String>>{
    return LAnon(
      () -> 
        l_acc_p
        ._and(entries_p().option())
        .and_(r_acc_p)
        .then(
          opt -> JsObject(opt.map((arr:Cluster<Couple<String,JsonSum<String>>>
        ) -> Ensemble.fromClusterCouple(arr)).defv(Ensemble.unit())))
        .asParser()
    ).asParser().tagged('json').memo();
  }
  function main(ipt:ParseInput<String>){
    return parser().and_(Parsers.Eof());
  }
}