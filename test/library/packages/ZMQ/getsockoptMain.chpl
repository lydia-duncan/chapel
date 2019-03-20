use ZMQ;

var context: Context;
var socket = context.socket(ZMQ.REP);
socket.bind("tcp://*:*");
var x: string;
socket.getsockopt(ZMQ.LAST_ENDPOINT, x);

use Spawn;
var sub = spawn(["./getsockoptHelper", "--node=" + x]);

var val = socket.recv(int);
writeln("received: " + val);
writeln("sending: " + (val + 1));
socket.send(val + 1);

sub.wait();
writeln("program ended");
