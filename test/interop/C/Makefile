include lib/Makefile.testing

use_testing: use_testing.test.c lib/libtesting.a
	@$(CHPL_COMPILER) $(CHPL_CFLAGS) -o use_testing use_testing.test.c $(CHPL_LDFLAGS)
	@./use_testing
