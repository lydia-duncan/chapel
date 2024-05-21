use Random;
use List;
use Subprocess;
use OS.POSIX;

config param numIters: int = 10;
config param seed = 121242412;

proc main() {
  var program = "./foo";
  var args = new list((string, (int, int)));
  args.pushBack(("x", (/* low= */ 0, /* high= */ 30)));
  var result = randomOptimize(program, args);
  writeln("Best found was:");
  writeln(result);
}

proc randomOptimize(program: string,
                    optimizableArgs: list((string, (int, int)))) {
  var combosToCheck: [0..<numIters] Combo;

  // Determine the values to try for the arguments
  for i in combosToCheck.indices {
    combosToCheck[i] = new Combo(optimizableArgs);
  }

  // Run the program with all the possible argument values
  evaluate(program, combosToCheck);

  var bestVal = max(real);
  var bestIndex = -1;

  // Find the first run that gave the lowest value
  for i in combosToCheck.indices {
    ref p = combosToCheck[i];
    writeln("argument list: ", p.args);
    writeln("gave result: ", p.result);
    if p.result < bestVal {
      bestVal = p.result;
      bestIndex = i;
    }
  }

  // Return the argument settings that led to that lowest value
  var best: list((string, int));
  if bestIndex >= 0 {
    for arg in combosToCheck[bestIndex].args {
      best.pushBack(arg);
    }
  }

  return best;
}

proc evaluate(program: string, const ref combosToCheck: [] Combo) {
  forall combo in combosToCheck {
    var programCall = program;

    // Build the call we should make
    for arg in combo.args {
      programCall += " --" + arg(0): string + "=" + arg(1): string;
    }

    // TODO: do something to protect the test so it only runs with slurm and
    // does an allocation command
    var slurmCall = "srun -N 1";
    var jobID = string.createCopyingBuffer(getenv("SLURM_JOBID"));
    slurmCall += " --jobid %s ".format(jobID);
    slurmCall += programCall;

    var process = spawnshell(slurmCall, stdout=pipeStyle.pipe,
                             stderr=pipeStyle.pipe);
    while (process.running) {
      currentTask.yieldExecution();
      process.poll();
    }
    // Run the program
    process.communicate();
    try {
      combo.result = process.stdout.read(real(64));
    } catch e {
      writeln("run failed: ", e.message());
      combo.result = max(int);
    }
  }
}

private var rng = new randomStream(int, seed);

record Combo {
  var args: list((string, int));
  var result: real;

  proc init(args: list((string, (int, int)))) {
    this.args = new list((string, int));
    this.result = 0.0;

    // Based on the limits provided in the argument list, determine a value to
    // try for this particular run
    for (name, (low, high)) in args {
      var val = rng.next(low, high);
      this.args.pushBack((name, val));
    }
  }

  proc init() {
    this.args = new list((string, int));
    this.result = 0.0;
  }
}
