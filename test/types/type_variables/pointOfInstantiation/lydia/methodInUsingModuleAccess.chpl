// Mod of test/types/type_variables/bradc/test_point_of_instantiation2-blc.chpl
// to access methods defined in using module.
module M1 {
  use M2;
  proc foo() {
    var c: C = new C(3);
    writeln("foo");
    bar(c); // Works
  }
  proc C.goo() {
    writeln("M1's C.goo");
  }

  proc main() {
    var c: C = new C(3);
    foo();
    baz(c);
  }
}

module M2 {
  class C {
    var a: int;

    proc someMethod() {
      writeln("In C.someMethod()");
    }
  }

  proc bar(c) {
    writeln("bar");
    c.goo();
  }

  proc baz(c1: C) {
    var c2: C = new C(3);

    bar(c1); // Works when called from M1
    bar(c2); // Works when called from M1
  }
}
