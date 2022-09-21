package stx.yaml;

using stx.Test;
using stx.Parse;

class Test{
  static public function main(){
    __.test().run([

    ],[]);
  }
}
class YamlParserTest{

}
enum ScalarStyle{
  LiteralStyle;
  FoldedStyle;
}
enum YamlLExpr{
  HeadEnd;
  TailEnd;
  
  Alias(label:String);
  Anchor(label:String,rest:YamlLExpr);
  Mapping(data:Cluster<Couple<YamlLExpr,YamlLExpr>>);
  Sequence(data:Cluster<YamlLExpr>);
  Literal(data:Scalar,style:ScalarStyle);
}
enum YamlData{

}
enum Scalar{
  SNull;
  SNaN;
  SNegativeInfinity;
  SFloat(f:Float);
  SInt(i:Int);
  SBool(b:Bool);
  SString(s:String);
}
enum IntegerEncoding{
  Decimal;
  Octal;
  Hexidecimal;
}
enum FloatEncoding{
  Exponential;
  Fixed;
}
enum ScalarType{
  TInt;
  TFloat;
  TString;
  TTimestamp;
}
class YamlParser{
  function expr():Parser<String,YamlLExpr>{
    return null;
  }
  function allowable_gap(){
    return Parse.gap;
  }
  function block_sequence(){
    return "-".id().and_(allowable_gap);
  }
  function mapping(){
    return ":".id().and_(allowable_gap);
  }
  function head_end(){
    return '---'.id().then(_ -> HeadEnd);
  }
  function tail_end(){
    return '---'.id().then(_ -> TailEnd);
  }
  function anchor_label(){
    return null;
  }
  function anchor(){
    return '&'.id()._and(anchor_label()).and(expr()).then(
      __.decouple(Anchor)
    );
  }
  // function complex_mapping_key(){
  //   return '?'.id()._and()
  // }
  function flow_scalar(){

  }
  //multiline folded
  function flow_scalar_plain(){

  }
  function flow_scalar_escaped(){
    return '"'.id();
  }
  function flow_scalar_unescaped(){
    return "'".id();
  }
  function int_hexadecimal(){
    
  }
  function int_octal(){

  }
  function int_decimal(){

  }
  function int_canonical(){

  }
  function float_NaN(){
    return '.nan'.id().then(_ -> NaN);
  }
  function float_negative_infinity(){
    return '-.inf'.id().then(_ -> NegativeInfinity);
  } 
  function float_fixed(){

  }
  function float_exponential(){

  }
  function float_canonical(){

  }
  function timestamp_date(){

  }
  function timestamp_spaced(){

  }
  function timestamp_iso8601(){

  }
  function timestamp_canonical(){

  }
  function scalar_spec_type(){
    // /return "!!".id().
  }
  // [name        , hr, avg  ]
  // function p_flowstyle(){
  //   return Parse.brkt_l_square._and()
  // }
}
enum YamlToken{
  
}