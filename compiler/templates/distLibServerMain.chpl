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
  var endpointSplit = fnCallEndpoint.split(":");
  var hostname = chpl_nodeName();
  var fullConnection = endpointSplit[1] + "://" + hostname: string + ":";
  fullConnection += endpointSplit[3];

  clientSocket.send(fullConnection);

  while (true) {
    var fooFuncNum = fnCallSocket.recv(int);
    select fooFuncNum {
        // end of cases

        otherwise {
          writeln("wrong function number");
          break;
        }
      }
  }
}
