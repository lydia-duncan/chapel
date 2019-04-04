use ZMQ;

extern proc chpl_nodeName(): c_string;

var serverContext: Context;
var serverSocket = serverContext.socket(ZMQ.PULL);
serverSocket.bind("tcp://*:*");
var serverEndpoint = serverSocket.getLastEndpoint();
writeln(serverEndpoint); // TODO: remove once working
var endpointSplit = serverEndpoint.split(":");
var hostname = chpl_nodeName();

var fullConnection = endpointSplit[1] + "://" + hostname: string + ":";
fullConnection += endpointSplit[3];
writeln(fullConnection); // TODO: remove once working

use Spawn;
var server = spawn(["./distLibServerMain", "--clientNode=" + fullConnection, "-nl 1"]);

var fnCallNode = serverSocket.recv(string);
writeln("received node: " + fnCallNode); // TODO: remove once working

var fnCallContext: Context;
var fnCallSocket = fnCallContext.socket(ZMQ.REQ);
fnCallSocket.connect(fnCallNode);

// TODO: remove this once working, it will be replaced with exported wrappers
var val = 42;
fnCallSocket.send(val);
writeln("sent val: " + val);
val = fnCallSocket.recv(int);
writeln("received val: " + val);

server.wait();
writeln("program ended");
// TODO: clean up function to clean up server and clean
