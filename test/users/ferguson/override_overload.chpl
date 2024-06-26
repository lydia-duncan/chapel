class BaseWriter {
  proc writeIt(x) {
    writeln("Generic Writer.writeIt called");
    //compilerError("Generic Writer.writeIt called");
  }
  proc write(x) {
    writeIt(x);
  }
}

class SubWriterOne : BaseWriter {
  override proc writeIt(x) {
    writeln("in SubWriterOne writing ", x);
  }
}

class SubWriterTwo : BaseWriter {
  override proc writeIt(x:int) {
    writeln("in SubWriterTwo writing int ", x);
  }
  override proc writeIt(x) {
    writeln("in SubWriterTwo writing ", x);
  }
}

var ownS1 = new owned SubWriterOne();
var s1 = ownS1.borrow();
var ownS2 = new owned SubWriterTwo();
var s2 = ownS2.borrow();

var s1w = s1:borrowed BaseWriter;
var s2w = s2:borrowed BaseWriter;

writeln("Calling from a type BaseWriter");
s1w.write(5);
s1w.write("baz");
s2w.write(7);
s2w.write("bar");
