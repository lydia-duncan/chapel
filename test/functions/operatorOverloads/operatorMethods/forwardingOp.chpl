record Container {
  forwarding var x: OtherType;
}

record OtherType {
  var y: int;
}
operator OtherType.+(lhs: OtherType, rhs: OtherType) {
  return new OtherType(lhs.y + rhs.y);
}

operator OtherType.<(lhs: OtherType, rhs: OtherType) {
  return lhs.y < rhs.y;
}

proc main() {
  var a: Container = new Container(new OtherType(3));
  var b: Container = new Container(new OtherType(2));
  var c = a + b;
  writeln(c.type: string); // Expect this to be OtherType unless opted-in
  writeln(c); // Expect this to have had the contents of the two fields added
  writeln(a < b); // Expect this to be false (because 3 > 2)
}
