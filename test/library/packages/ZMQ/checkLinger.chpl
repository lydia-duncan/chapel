use ZMQ;

var context: Context;
var socket = context.socket(ZMQ.REP);
socket.bind("tcp://*:*");
var x: c_int;
socket.getsockopt(ZMQ.LINGER, x);
socket.setsockopt(ZMQ.LINGER, x + 1);
var y: c_int;
socket.getsockopt(ZMQ.LINGER, y);

writeln(x + 1 == y);
