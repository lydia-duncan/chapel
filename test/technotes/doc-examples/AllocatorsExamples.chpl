//
// THIS TEST CASE IS AUTO-INCLUDED IN THE DOCUMENTATION
//


/* START_EXAMPLE_0 */
extern {
  #include "chpl-mem.h"
  static int64_t* mymalloc(void) {
    int64_t *ret = (int64_t*) chpl_malloc(1024);
    ret[0] = 5;
    return ret;
  }
  static void myfree(int64_t *x) {
    chpl_free(x);
  }
}

var x = mymalloc();

writeln(x.deref());

myfree(x);
/* STOP_EXAMPLE_0 */
