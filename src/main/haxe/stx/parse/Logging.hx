package stx.parse;

using stx.Nano;
using stx.Log;
using stx.Pkg;

class Logging{
  static public function log(wildcard:Wildcard):Log{
    return 
      #if stx.parse.switches.debug 
        stx.Log.pkg(__.pkg());
      #else
        stx.Log.void();
      #end
  }
}