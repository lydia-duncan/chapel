// Test that forwarding cycle results in an error

class A {
  proc fun(i:int) {}
  var data: unmanaged B?;
  forwarding data!;
}
class B {
  var data: unmanaged A?;
  forwarding data!;
}

proc main() {
  var a = new unmanaged A();
  a.fun(1.1);
  delete a;
}
