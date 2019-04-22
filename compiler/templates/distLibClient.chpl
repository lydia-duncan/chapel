use ZMQ;

extern proc chpl_nodeName(): c_string;

var chpl_serverContext: Context;
var chpl_serverSocket = chpl_serverContext.socket(ZMQ.PULL);
chpl_serverSocket.bind("tcp://*:*");
var chpl_serverEndpoint = chpl_serverSocket.getLastEndpoint();
var chpl_endpointSplit = chpl_serverEndpoint.split(":");
var chpl_hostname = chpl_nodeName();

var chpl_fullConnection = chpl_endpointSplit[1] + "://" + chpl_hostname: string + ":";
chpl_fullConnection += chpl_endpointSplit[3];

use Spawn;
// TODO: leave space in here for config consts/vars?
// TODO: replace nl's 1 with an arg that gets threaded through
var chpl_server = spawn(["./chpl_distLibServerMain", "--chpl_clientNode=" + chpl_fullConnection, "-nl 1"]);

var chpl_fnCallNode = chpl_serverSocket.recv(string);

var chpl_fnCallContext: Context;
var chpl_fnCallSocket = chpl_fnCallContext.socket(ZMQ.REQ);
chpl_fnCallSocket.connect(chpl_fnCallNode);

proc deinit() {
  chpl_server.wait();
  writeln("program ended");
}
// TODO: clean up function to clean up chpl_server and end interaction
