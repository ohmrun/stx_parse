using stx.Parse;

class Main{
  static public function main(){
    trace("before");
    Test.main();    
    trace("later");
  }
}