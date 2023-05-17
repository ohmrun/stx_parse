package stx.parse;

using stx.Nano;
using stx.Log;
using stx.Pkg;

class Logging{
  static public function log(wildcard:Wildcard):Log{
    return stx.Log.pkg(__.pkg());
      // #if (debug) 
        
      // #else
      //   stx.Log.empty();
      // #end
  }
}