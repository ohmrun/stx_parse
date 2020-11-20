package stx.parse.core;

import haxe.ds.IntMap;

abstract Lung(IntMap<Array<String>>){
  @:noUsing static public function unit():Lung{
    return new Lung();
  }
  @:noUsing static public function lift(self:IntMap<Array<String>>){
    return new Lung(self);
  }
  public function new(?self){
    this = __.option(self).def(() -> new IntMap());
  }
  public function get(i:Int):Array<String>{
    return __.option(
      this.get(i)
    ).def(
      () -> {
        var o         = [];
        this.set(i,o);
        return o;
      }
    );
  }
  public function push(i:Int,str:String){
    var next = copy();
        next.get(i).push(str);
    return next;
  }
  public function copy():Lung{
    var next = new IntMap();
    for(key => val in this){
      next.set(key,val.copy());
    }
    return lift(next);
  }
}