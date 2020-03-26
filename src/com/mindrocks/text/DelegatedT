package com.mindrocks.text;

enum DelegatedT<I,O>{
  DUnknown;
  DDirect(name:String,?meta:Dynamic);
  DUnit(p:Parser<I,O>);
  DArray(p:Parser<I,Array<O>>);
  DOrs(arr:Array<Parser<I,O>>);
  DConj(tp:Couple<Parser<I,O>,Parser<I,O>>);
  DDisj<U>(tp:Couple<Parser<I,O>,Parser<I,U>>);
}