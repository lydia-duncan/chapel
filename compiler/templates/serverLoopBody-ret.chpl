when fooFuncNum {
  // handle args
  var chpl_ret = chpl_funcCall(chpl_myargs);
  fnCallSocket.send(chpl_ret);
}
