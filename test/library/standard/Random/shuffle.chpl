use Random;

{
  var A = ['c', 'h', 'a', 'p', 'e', 'l'];

  shuffle(A, seed=10);

  writeln(A);
}


{
  var D = {2..8 by 2},
        A : [D] int;

  for i in D {
    A[i] = i;
  }

  shuffle(A, seed=10);

  writeln(A);
}

{
  var D = {2..9 by 2 align 1},
        A : [D] int;

  for i in D {
    A[i] = i;
  }

  shuffle(A, seed=10);

  writeln(A);
}

{
  var D = {2..8 by -2},
        A : [D] int;     // neg-stride

  for i in D {
    A[i] = i;
  }

  shuffle(A, seed=20);

  writeln(A);
}

{
  var D = {1..3, 0..6 by 2},
        A : [D] real;

  for (i, j) in D {
    A[i, j] = i + j / 10.0;
  }

  shuffle(A, seed=21);

  writeln(A);
}
