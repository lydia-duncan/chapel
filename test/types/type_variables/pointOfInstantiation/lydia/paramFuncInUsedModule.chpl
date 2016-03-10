// Mod of test/types/type_variables/bradc/test_point_of_instantiation2-blc.chpl
module M1 {
  use M2;
  proc foo() {
    writeln("foo");
    bar(1); // I am okay with this accessing M1's goo, but was surprised it
    // didn't access M2's goo instead.
  }
  proc goo() {
    writeln("M1's goo");
  }
  proc main() {
    foo();
    baz();
    bar(2); // Accesses M2's goo (I guess that's consistent?)
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

