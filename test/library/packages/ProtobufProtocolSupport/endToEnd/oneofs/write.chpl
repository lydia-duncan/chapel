use oneofs;
use IO;

var file = open("out", ioMode.cw);
var writingChannel = file.writer(locking=false);

var messageObj = new Foo();

messageObj.co = color.green;
messageObj.name = b"chapel";

messageObj.mfield.a = 67;
messageObj.ifield = 45;

messageObj.serialize(writingChannel);
