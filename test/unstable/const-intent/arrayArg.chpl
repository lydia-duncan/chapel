var dom = {0..3};
var arr: [dom] int;

proc takesArray(const arg) {
  writeln(arg);

  // should trigger the warning, this is changing the array's domain
  dom = {0..4};
  writeln(arg);
}

proc main() {
  takesArray(arr);
}
