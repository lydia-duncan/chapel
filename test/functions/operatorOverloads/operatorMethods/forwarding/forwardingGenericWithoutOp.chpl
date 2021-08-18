record Container {
  forwarding var x: OtherType;
}

record OtherType {
  var y;
}
operator (OtherType(int)).+(lhs: OtherType(int), rhs: OtherType(int)) {
  return new OtherType(lhs.y + rhs.y);
}

proc main() {
  var a: Container = new Container(new OtherType(3.2));
  var b: Container = new Container(new OtherType(2.931));
  var c = a + b; // Expect this to fail, there isn't a real overload
  writeln(c.type: string);
  writeln(c);
}
