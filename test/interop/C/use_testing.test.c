#include "lib/testing.h"

// Test of calling an exported Chapel library.
int main(int argc, char* argv[]) {
  // Initialize the Chapel runtime and standard modules
  chpl_library_init(argc, argv);
  chpl__init_chpl_testing_client(0, 0);

  // Call the function
  foo();

  // Shutdown the Chapel runtime and standard modules
  chpl_library_finalize();

  return 0;
}
