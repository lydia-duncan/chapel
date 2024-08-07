//
// Test the time required to promote the op= operator by indexing into
// one array with another.
//

config const n = 1000000;
config const numIters = 1000;

config param printArrays = false;
config param printTiming = true;


var A: [1..n] real;

var B: [1..n] int;

forall i in 1..n with (ref B) do
  B[i] = i;


if printArrays then
  writeln("Before update, A is: ", A);

use Time;

const startTime = timeSinceEpoch().totalSeconds();

for i in 1..numIters do
  // A[B] += 1;
  forall b in B with (ref A) do A[b] += 1;

const stopTime = timeSinceEpoch().totalSeconds();
if printTiming then
  writeln("Time: ", stopTime-startTime);

if printArrays then
  writeln("A is: ", A);
