package stx.parse;

class Log{
  static public function log(wildcard:Wildcard){
    return stx.Log.unit().tag('stx.parse');
  }
}