/* This test record asserts that any record passed to
   auto copy/ init copy /assign has been initialized.
 */
use CTypes;
config const debug = false;

record R {
  var x: int = 0;
  var canary: int = 42;
}


proc ref R.setup(x:int, allow_zero:bool=false) {
  if !allow_zero then assert(x != 0);
  this.x = x;

  if canary != 42 {
    writeln("setup with uninitialized record!");
    assert(canary == 42);
  }

}

proc ref R.destroy() { }

proc ref R.increment() {
  assert(x != 0);

  if canary != 42 {
    writeln("increment with uninitialized record!");
    assert(canary == 42);
  }

  x += 1;
}


proc R.deinit() {
  if debug then writeln("In record destructor");

  if canary != 42 {
    writeln("record destruction with uninitialized record!");
    assert(canary == 42);
  }
}

proc R.verify() {
  extern proc printf(fmt:c_ptrConst(c_char), arg:c_ptr(int), arg2:c_ptr(int));

  if canary != 42 {
    writeln("R.verify failed - got canary=", canary, " but expected 42");
    assert(false);
  }
}

proc R.init=(const ref arg: R) {
  if arg.canary != 42 {
    writeln("init= with uninitialized record!");
    assert(arg.canary == 42);
  }

  init this;
  // allow copies of a default-initialized record.
  this.setup(x = arg.x, true);

  if debug {
    writeln("leaving init=");
  }
}

operator R.=(ref lhs: R, rhs: R) {
  // both LHS and RHS should be initialized.
  if lhs.canary != 42 {
    writeln("= with uninitialized lhs!");
    assert(lhs.canary == 42);
  }
  if rhs.canary != 42 {
    writeln("= with uninitialized rhs!");
    assert(rhs.canary == 42);
  }

  lhs.setup(x = rhs.x, true);

  if debug {
    writeln("leaving assign");
  }
}

proc verify() {
}

