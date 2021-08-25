// Tests when forwarding a type that defines an operator to use (but the type
// being forwarded also forwards another type)
record Container {
  forwarding var x: OtherType;
}

record OtherType {
  forwarding var y: OtherOtherType;
}
operator OtherType.+(lhs: OtherType, rhs: OtherType) {
  return new OtherType(new OtherOtherType(lhs.y.z + rhs.y.z));
}

operator OtherType.<(lhs: OtherType, rhs: OtherType) {
  return lhs.y.z < rhs.y.z;
}

record OtherOtherType {
  var z: int;

  proc foo() {
    writeln("whatev");
  }
}

proc main() {
  var a: Container = new Container(new OtherType(new OtherOtherType(3)));
  var b: Container = new Container(new OtherType(new OtherOtherType(2)));
  var c = a + b;
  writeln(c.type: string); // Expect this to be OtherType unless opted-in
  writeln(c); // Expect this to have had the contents of the two fields added
  writeln(a < b); // Expect this to be false (because 3 > 2)
}
