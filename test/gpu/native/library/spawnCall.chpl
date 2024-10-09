use Subprocess;

forall i in 1..10 {
  var process = spawnshell("echo " + i: string, stdout=pipeStyle.pipe,
                           stderr=pipeStyle.pipe);

  while process.running {
    currentTask.yieldExecution();
    process.poll();
  }

  process.communicate();

  try {
    var res: int = process.stdout.read(int);

    if (res == i) {
      writeln("successfully read it back");
    } else {
      writeln("uh oh, expected ", i, " but got ", res, " instead.");
    }
  } catch e {
    writeln("run failed: ", e.message());
  }
}
