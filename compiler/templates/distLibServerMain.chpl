config const chpl_clientNode: string;

proc main() {
  use ZMQ;

  extern proc chpl_nodeName(): c_string;

  var clientContext: Context;
  var clientSocket = clientContext.socket(ZMQ.PUSH);
  clientSocket.connect(chpl_clientNode);

  var fnCallContext: Context;
  var fnCallSocket = fnCallContext.socket(ZMQ.REP);
  fnCallSocket.bind("tcp://*:*");
  var fnCallEndpoint = fnCallSocket.getLastEndpoint();
  writeln(fnCallEndpoint); // TODO: remove once working
  var endpointSplit = fnCallEndpoint.split(":");
  var hostname = chpl_nodeName();
  var fullConnection = endpointSplit[1] + "://" + hostname: string + ":";
  fullConnection += endpointSplit[3];
  writeln(fullConnection); // TODO: remove once working

  clientSocket.send(fullConnection);

  // TODO: replace this with a while loop once it works
  var val = fnCallSocket.recv(int);
  writeln("received val: " + val);
  writeln("sending val: " + val);
  fnCallSocket.send(val + 1);
}
