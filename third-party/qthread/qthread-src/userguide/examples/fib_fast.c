#include <qthread/qthread.h>
#include <stdio.h>
#include <stdlib.h>

#define THRESHOLD 20

unsigned long fib_serial(unsigned long n) {
  int x, y;

  if (n < 2) return n;

  x = fib_serial(n - 1);
  y = fib_serial(n - 2);

  return (x + y);
}

static aligned_t fib(void *arg) {
  aligned_t x = 0, y = 0;
  unsigned long n = (unsigned long)(uintptr_t)arg;

  if (n < THRESHOLD) return (aligned_t)fib_serial(n);

  qthread_fork(fib, (void *)n - 1, &x);
  qthread_fork(fib, (void *)n - 2, &y);

  qthread_readFF(NULL, &x);
  qthread_readFF(NULL, &y);

  return (x + y);
}

int main(int argc, char *argv[]) {
  aligned_t return_value = 0;
  unsigned long n = 0;

  if (argc > 1) n = atol(argv[1]);

  qthread_initialize();

  qthread_fork(fib, (void *)n, &return_value);

  qthread_readFF(NULL, &return_value);

  printf("fib(%ld) = %ld\n", n, return_value);

  return 0;
}
