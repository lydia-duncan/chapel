use Time;

// Test single read on initialization.

var s: single int;

begin {
  var t = s.readFF();
  writeln( "B.");
}

sleep( 3);
write( "First we have A, followed by ");
sleep( 2);
s.writeEF(1);
