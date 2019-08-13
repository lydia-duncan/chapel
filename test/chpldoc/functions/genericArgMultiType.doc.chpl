/* This class has two generic fields */
class Foo {
  /* p is a param field */
  param p: int;
  /* t is a type field */
  type t = bool;
}

/* This function takes an argument of type Foo(2, bool) */
proc bar(x: Foo(2, bool)) {
}
