chpl_fnCallSocket.send(funcNum);
// handle args
var funcRetVal: funcRetType = chpl_fnCallSocket.recv(funcRetType);
return funcRetVal;
