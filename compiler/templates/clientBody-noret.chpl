chpl_fnCallSocket.send(funcNum);
// handle args
// receive dummy value.  Drop it on the floor
var funcRetVal: int = chpl_fnCallSocket.recv(int);
