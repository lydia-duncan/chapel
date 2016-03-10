// Copy of test/types/type_variables/bradc/test_point_of_instantiation2-blc.chpl
module M1 {
  use M2;
  proc foo() {
    writeln("foo");
    bar(1); // This should access M2's goo, because M1's goo is private to M1
  }
  private proc goo() {
    writeln("M1's goo");
  }
  proc main() {
    foo();
    baz();
  }
}

module M2 {
  proc goo() {
    writeln("M2's goo");
  }
  proc bar(param p: int) {
    writeln("bar");
    goo();
  }
  proc baz() {
    bar(1); // I think this should access M2's goo
    bar(2);
    goo();
  }
}
