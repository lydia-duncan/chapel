Release Changes List
====================

version 2.5
===========

released June 12, 2025

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* extended the standard `sort()` routine to support block-distributed arrays
* added a new package module supporting dynamic loading/calling of C functions
* improved debugging support through compiler, library, and VSCode features
* added a new 'edition' feature in support of experimental breaking changes
* added a new `reshape()` implementation that supports aliasing of arrays
* made several improvements to the `Python` module for Python interoperability
* added a draft technical note describing optimization of Chapel programs
* added new `CHPL_*MEM=mimalloc` and `CHPL_*PLATFORM=hpe-cray-xd` options
* added validation checks of `CHPL_*` values to make sure they are legal
* updated the compiler to support LLVM 20 when targeting CPUs
* improved the new 'dyno' front-end's ability to resolve and lower features
* made many other improvements in terms of bug fixes, errors, docs, etc.

New Language Features
---------------------
* added an 'edition' feature that enables opting in to breaking changes  
  (see https://chapel-lang.org/docs/2.5/technotes/editions.html)
* added a new, prototype `reshape()` implementation that aliases array data  
  (see https://chapel-lang.org/docs/2.5/language/spec/arrays.html#ChapelArray.reshape)

Language Feature Improvements
-----------------------------
* made `init()`/`postinit()` calls that `throw` deinit the object's fields  
  (see https://chapel-lang.org/docs/2.5/technotes/throwingInit.html#declaring-throwing-initializers)
* added support for `noinit` remote variable declarations  
  (e.g., `on someLocale var A: [1..10] real = noinit;`)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* removed support for `keyPart` methods that return an integral section

New Standard Library Features
-----------------------------
* extended the standard `sort()` routine to handle block-distributed arrays  
  (see https://chapel-lang.org/docs/2.5/modules/standard/Sort.html#Sort.sort)
* added `debugTrap` to the `Debugger` module to generate a HW debug exception  
  (see https://chapel-lang.org/docs/2.5/modules/standard/Debugger.html#Debugger.debugTrap)
* added a `disableDebugTrap` config to turn `debugTrap` into a no-op  
  (see https://chapel-lang.org/docs/2.5/modules/standard/Debugger.html#Debugger.disableDebugTraps)

New Package Module Features
---------------------------
* added a new `DynamicLoading` package module to load dynamic libraries  
  (see https://chapel-lang.org/docs/2.5/modules/packages/DynamicLoading.html)
* added support for anonymous Python modules to the `Python` interop module  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.Interpreter.createModule)
* added support for Python tuple types to the `Python` module  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.PyTuple)
* expanded `PyArray` support for multi-dimensional arrays  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.PyArray)
* added support for native Chapel iteration on Python objects  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.Value.these)
* added support for native Chapel operators on Python objects  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.+)
* added support for casting from various Python types to Chapel types  
  (see [https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.Value.:](https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.Value.:))
* added additional methods for Python `list` types to the `Python` module  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.PyList)
* added `.repr()` to get the debug string representation of a Python object  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.Value.repr)
* added `Python.[get|set|del]()` to interact with Python's global state  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#Python.Interpreter.get)
* added an `assertRegexMatch()` procedure to the `UnitTest` module  
  (see https://chapel-lang.org/docs/2.5/modules/packages/UnitTest.html#UnitTest.Test.assertRegexMatch)

Changes / Feature Improvements in Package Modules
-------------------------------------------------
* improved memory allocation in the `Image` module

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* removed the previously deprecated `.sort()` method on the `list` type
* removed the previously deprecated `.compare()` methods in the `Sort` module
* removed the previously deprecated `[Default|Reverse]Comparator` types

Compiler Flags
--------------
* added a new `--edition` flag to control the edition used by the compiler  
  (see https://chapel-lang.org/docs/2.5/usingchapel/man.html#man-edition)

Compiler Improvements
---------------------
* added support for directly naming library files on the `chpl` command-line  
  (see https://chapel-lang.org/docs/2.5/technotes/extern.html#expressing-dependencies)
* added support for LLVM 20
* fixed debug info generated by LLVM for module-scope variables and formals
* based the suffix used for `--library --dynamic` files on the target platform
* resolved warnings about unused `-c` flags when parsing `extern` blocks

Tool Improvements
-----------------
* improved support for debugging within VSCode  
  (see https://chapel-lang.org/docs/2.5/usingchapel/editor-support.html#debugging-in-vscode)
* added external library linking support to Chapel's CMake support  
  (see https://chapel-lang.org/docs/2.5/usingchapel/compiling.html#cmake)
* enabled displaying 'dyno' resolution errors in `chpl-language-server` (CLS)
* added support for editor-agnostic config files in CLS and `chplcheck`  
  (see https://chapel-lang.org/docs/2.5/tools/chplcheck/chplcheck.html#configuration-files  
   and https://chapel-lang.org/docs/2.5/tools/chpl-language-server/chpl-language-server.html#configuration-files)
* updated `chplcheck` to avoid linting `extern` functions prefixed with `chpl_`
* enabled Python `str` and `repr` methods on AST nodes in `chapel-py`
* added a script to generate arguments when compiling Python interop code  
  (see https://chapel-lang.org/docs/2.5/modules/packages/Python.html#compiling-chapel-code)

Documentation Improvements
--------------------------
* improved quickstart documentation to suggest binary releases  
  (see https://chapel-lang.org/docs/2.5/usingchapel/QUICKSTART.html)
* improved documentation for debugging programs with the LLVM backend  
  (see https://chapel-lang.org/docs/2.5/usingchapel/debugging.html#best-known-configuration-llvm-backend)
* made the co-locale documentation more searchable
* generally fixed typos, mistakes, and other small issues in the docs

Language Specification Improvements
-----------------------------------
* updated some tests and descriptions of `init=` to bring them up-to-date  
  (see https://chapel-lang.org/docs/2.5/language/spec/records.html#mixed-type-copy-initialization)

Documentation Improvements for Libraries
----------------------------------------
* made the `Sort` and `Image` module code examples testable

Technical Note Improvements
---------------------------
* added a draft technote describing how to optimize Chapel programs  
  (see https://chapel-lang.org/docs/2.5/technotes/optimization.html)

Configuration / Build Changes
-----------------------------
* added `mimalloc` as a new option for `CHPL_*_MEM`  
  (see https://chapel-lang.org/docs/2.5/usingchapel/chplenv.html#chpl-target-mem  
   and https://chapel-lang.org/docs/2.5/usingchapel/chplenv.html#chpl-host-mem)
* added `hpe-cray-xd` as a `CHPL_*_PLATFORM` option for HPE Cray XD systems  
  (see https://chapel-lang.org/docs/2.5/usingchapel/chplenv.html#chpl-host-platform  
   and https://chapel-lang.org/docs/2.5/usingchapel/chplenv.html#chpl-target-platform)
* default to `CHPL_LAUNCHER=slurm` when it's available and `CHPL_COMM!=none`  
  (see https://chapel-lang.org/docs/2.5/usingchapel/launcher.html#currently-supported-launchers)
* added errors for setting `CHPL_*` environment variables to invalid values
* added a build-time check to catch misconfigurations in the host environment
* fixed a bug preventing using the bundled LLVM with `cmake` major version > 3

Updates to Chapel's Release Formats
-----------------------------------
* updated the homebrew formula to use LLVM 20
* started installing CMake files into the appropriate `lib/` directories

Portability / Platform-specific Improvements
--------------------------------------------
* added warnings for failing to use a `PrgEnv` compiler when available
* added an error for trying to use a Cray XC with GASNet (no longer supported)
* improved detection of the PMI2 library for OFI OOB communication
* started emitting dSYM archives on MacOS platforms with the C backend
* fixed a portability issue building GASNet with GCC 15

Portability / Build Improvements for GPUs
-----------------------------------------
* improved the wording of error messages for unsupported ROCm versions

Error Messages / Semantic Checks
--------------------------------
* improved error messages for incorrect types with `minmax` reduce intents
* improved errors when storing reduce intent results into outer variable
* improved formatting of `chpldoc`-related links that appeared in errors
* started printing yield types for iterators and promoted expressions

Error Messages / Semantic Checks for Libraries
----------------------------------------------
* converted halts into thrown errors in the `Python` and `Image` modules
* added a warning when `gpuClock()` is called from a host processor
* improved errors for invalid inputs and too-large images in the `Image` module
* improved the error message for `numBits(bool)`

Runtime Library Improvements
----------------------------
* made minor improvements to memory and fencing behavior in `--cache-remote`

Third-Party Software Changes
----------------------------
* added a bundled version of `mimalloc` 2.1.7 as a memory allocator option  
  (see https://github.com/chapel-lang/chapel/blob/main/third-party/mimalloc/README)
* updated the bundled version of Qthreads to 1.22
* updated the bundled hwloc to version 2.11.2

Bug Fixes
---------
* fixed a bug caused by the `--auto-local-access` (ALA) optimization
* fixed an internal error for a reduce intent like `minmax(2*int) reduce sum`
* fixed a bug related to naming conflicts between system and user header files
* fixed a bug causing line number comments to be omitted in generated C code

Bug Fixes for Libraries
-----------------------
* fixed a segfault with the Python interpreter for `CHPL_COMM=gasnet`
* added logic to release the GIL after an exception is thrown in `Python`
* refactored the `Python` module GIL entry/exit code to be more robust

Bug Fixes for GPU Computing
---------------------------
* added missing checks for errors in reduction kernel wrappers

Bug Fixes for Build Issues
--------------------------
* made failures in `printchplenv` cause `./configure` to fail
* fixed a crash using `CHPL_GASNET_SEGMENT=everything` w/ an illegal substrate
* fixed error messages about incorrect memory allocators in `printchplenv`
* enforced a minimum Python version of 3.5 for `find-python.sh`
* removed extraneous Clang `--gcc-install-dir` arguments on macOS and FreeBSD
* ensured generated `pytest` files for `chpl-language-server` get cleaned up

Bug Fixes for the Runtime
-------------------------
* fixed stack traces printed with newer LLVM/clang versions

Developer-oriented changes: Process
-----------------------------------
* started publishing the `main` version of Chapel docs using GitHub actions

Developer-oriented changes: Module changes
------------------------------------------
* added support for cross-locale calls to dynamically loaded procedure pointers
* improved the portability of `breakpoint` in the `Debugger` module  

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* added a `docs-release` Makefile target for making docs snapshots for releases
* fixed problematic `const char*` declarations in slurm launcher code

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* expanded prototypical support for improved procedure pointer types
* added debugger printers for LLVM metadata
* renamed `gdbShouldBreakHere()` to `debuggerBreakHere()`

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* added an error message for variables declared without an initializer or type
* made significant improvements to the 'dyno' resolver's performance
* made numerous improvements to the 'dyno' resolver for types and calls:
  - added support for array indexing and slicing via internal module code
  - added support for nD rectangular and associative array literals via modules
  - added support for resolving domain / element type queries in array formals
  - enabled resolving calls to `new blockDist`
  - added support for `reduce=`
  - added support for labeled `break` and `continue` statements
  - enabled generic `sync` formal types
  - added support for `.bytes()` on various types
  - added basic support for nested types
  - added support for assignment between `extern` types
  - added call resolution for basic functions in `extern` blocks
  - implemented `&&=` and `||=` compound assignment operators
  - implemented compiler-generated `.borrow()` methods for class types
  - implemented field access promotion
  - enhanced constness analysis for field access and array indexing
  - enabled constness checks, split-init, and copy elision at module scope
  - fixed generated inits where a parent field's type is not generally visible
  - added support for `chpl__orderToEnum()` and `chpl__enumToOrder()`
  - added support de-tupled loop index variables including `_`
  - unified the handling of control flow across resolution, type inference, ...
  - significantly improved copy-elision correctness
* made numerous improvements when converting 'dyno' AST to production AST
  - implemented generation of `select` statements
  - implemented generation of `enum` and `c_ptr` types
  - implemented generation of variable argument indexing with `param` integrals
  - added support for generating many other language features as well

Developer-oriented changes: Testing System
------------------------------------------
* dramatically improved the performance of `start_test`
* improved how `start_test`/`sub_test` handle generated debug information
* removed erroneous `chplenv` warnings in `start_test` output
* added better handling of dSYM to `sub_clean`
* added checks for `paratest` to prevent using unsupported launchers
* improved `chpl_launchcmd` to handle co-locales with PBS


version 2.4
===========

released March 20, 2025

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* significantly improved the features and ergonomics of the `Python` module
* improved parallel iteration and zippering over standard `set` and `map` types
* added support for multi-dimensional array literals like `[11, 12; 21, 22]`
* added the ability to query the number of co-locales running on a node
* added support for building Chapel projects with CMake
* added custom settings, location-based rules, and docs to the linter
* improved the 'dyno' compiler front-end's ability to resolve types and values
* significantly revamped the Chapel website at https://chapel-lang.org/
* made many other improvements in terms of bug fixes, errors, docs, etc.

Updates to Chapel Prerequisites
-------------------------------
* raised the minimum version of Clang required to build Chapel to 11.0  
  (see https://chapel-lang.org/docs/2.4/usingchapel/prereqs.html)

New Language Features
---------------------
* added support for multi-dimensional array literals  
  (e.g., `[1.2, 3.4; 5.6, 7.8]` creates a 2x2 array value  
   see https://chapel-lang.org/docs/2.4/language/spec/arrays.html#rectangular-array-literals)
* added the ability to cast arrays to array types of the same size / shape  
  (e.g., `[1.2, 3.4, 5.6]: [1..6 by 2] real(32)` is now supported)
* added `locale.numColocales` to query the number of co-locales on a node  
  (see https://chapel-lang.org/docs/2.4/language/spec/locales.html#ChapelLocale.locale.numColocales)

Language Feature Improvements
-----------------------------
* added initial support for throwing `postinit()` procedures  
  (see https://chapel-lang.org/docs/2.4/technotes/throwingInit.html#declaring-throwing-initializers)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* removed support for the deprecated `lambda` keyword
* removed support for the deprecated `object` and `c_string` types
* removed the deprecated `chpl_task_yield()` procedure
* removed the deprecated `newSliceRule` config param

New Standard Library Features
-----------------------------
* added an optional `sep` argument to `[fileWriter.]write[ln]()` in `IO`  
  (see https://chapel-lang.org/docs/2.4/modules/standard/IO.html#IO.fileWriter.write  
   and https://chapel-lang.org/docs/2.4/modules/standard/IO.html#IO.write)
* added `timeDelta.total[Milli|Micro]seconds()` to the `Time` module  
  (see https://chapel-lang.org/docs/2.4/modules/standard/Time.html#Time.timeDelta.totalMilliseconds)
* added `heap.clear()` to the `Heap` module  
  (see https://chapel-lang.org/docs/2.4/modules/standard/Heap.html#Heap.heap.clear)
* added support for C's `wchar_t` type in `CTypes`, named `c_wchar_t`  
  (see https://chapel-lang.org/docs/2.4/modules/standard/CTypes.html#CTypes.c_wchar_t)

Changes / Feature Improvements in Standard Libraries
----------------------------------------------------
* improved iterators on `set`s to support zippering with other sets and types  
  (see https://chapel-lang.org/docs/2.4/modules/standard/Set.html#Set.set.these)
* added support for `forall` loops over `map.keys()` and `map.values()`  
  (see https://chapel-lang.org/docs/2.4/modules/standard/Map.html#Map.map.keys  
   and https://chapel-lang.org/docs/2.4/modules/standard/Map.html#Map.map.values)
* added a `fileReader.extractMatch()` overload that returns a value to `IO`  
  (see https://chapel-lang.org/docs/2.4/modules/standard/IO/FormattedIO.html#FormattedIO.fileReader.extractMatch)
* extended `CTypes.c_addrOf[Const]()` to accept domains and distributed arrays

New Package Module Features
---------------------------
* added support for importing Python code declared as a string  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.Interpreter.importModule)
* added support for loading Python code from a Python pickle  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.Interpreter.load)
* added the ability to pass Chapel arrays to Python without copying  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.Array)
* added the ability to use Python arrays from within Chapel without copying  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.PyArray)
* added support for using Python `list`, `dict`, and `set` types in Chapel  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.PyList,  
   https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.PyDict,  
   and https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.PySet)
* added an option to turn off `Python` module error handling for performance  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.checkExceptions)
* added a `victimPolicy` enum to `DistributedBag` and its `.remove()` method  
  (see https://chapel-lang.org/docs/2.4/modules/packages/DistributedBag.html#DistributedBag.victimPolicy  
   and https://chapel-lang.org/docs/2.4/modules/packages/DistributedBag.html#DistributedBag.DistributedBagImpl.remove)
 
Changes / Feature Improvements in Package Modules
-------------------------------------------------
* improved the `Python` module's API in several ways:
  - added a new `Value` superclass from which many other classes derive  
    (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.Value)
  - used the new `Value` class to simplify other Python objects' interfaces
  - removed the `ClassObject` class in favor of `Value`
  - added new method-based replacements for the previous object-based API  
    (e.g., `new Function(mod, 'foo')` can now be written `mod.get('foo')`)
  - allowed omitting the return type on certain Python operations  
    (e.g., `val.get(owned Value, "xyz")` can now be written `val.get("xyz")`)
* added a Python `Interpreter.flush()` method to flush standard streams  
  (see https://chapel-lang.org/docs/2.4/modules/packages/Python.html#Python.Interpreter.flush)
* improved the `Python` module's integration with Chapel's threading model
* improved the `Python` module's reference counting
* adjusted `CopyAggregation`'s flush methods to optionally free the buffers  
  (see https://chapel-lang.org/docs/2.4/modules/packages/CopyAggregation.html#CopyAggregation.DstAggregator.flush)
* added `ref` intents to `.flush()` in `CopyAggregation` to avoid warnings  
  (see https://chapel-lang.org/docs/2.4/modules/packages/CopyAggregation.html#CopyAggregation.DstAggregator.flush)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* deprecated the `HDFS` module  
  (see https://chapel-lang.org/docs/2.4/modules/packages/HDFS.html)
* removed deprecated `imag`->`complex` trig routines in the `Math` module
* removed methods on `map` that had previously been deprecated in `Map`
* removed deprecated features from the `Version` module
* removed deprecated `CTypes` capabilities, like `c_void_ptr`
* removed deprecated `CodepointSplittingError` from the `Errors` module
* removed deprecated routines from the `MemMove` module

Tool Improvements
-----------------
* added support for building Chapel projects with CMake  
  (see https://chapel-lang.org/docs/2.4/usingchapel/compiling.html#cmake)
* added support for creating linter rules with custom settings  
  (see https://chapel-lang.org/docs/2.4/tools/chplcheck/chplcheck.html#rule-specific-settings)
* added support for text-location-only-based linter rules  
  (see https://chapel-lang.org/docs/2.4/tools/chplcheck/chplcheck.html#location-rules)
* added a new 'LineLength' linter rule  
  (see https://chapel-lang.org/docs/2.4/tools/chplcheck/chplcheck.html#linelength)
* allowed a single `chapel-py` build to be used with many Python versions
* `chplvis` now relies on a system install of `fltk` rather than bundling it  
  (see https://chapel-lang.org/docs/2.4/tools/chplvis/chplvis.html#setup)

Documentation Improvements
--------------------------
* updated URLs in the documentation to reflect the new website's organization
* refreshed the list of actively tested GPU configurations  
  (see https://chapel-lang.org/docs/2.4/technotes/gpu.html#tested-configurations)
* added a section to the GPU tech note about halting from GPU kernels  
  (see https://chapel-lang.org/docs/2.4/technotes/gpu.html#gpu-based-halting)
* added missing documentation for Slurm launcher flags and environment vars  
  (see https://chapel-lang.org/docs/2.4/usingchapel/launcher.html#using-slurm)
* added documentation clarifying uses of GASNet with InfiniBand and Omni-Path  
  (see https://chapel-lang.org/docs/2.4/platforms/infiniband.html#selecting-a-spawner  
   and https://chapel-lang.org/docs/2.4/platforms/omnipath.html#selecting-a-spawner)
* updated the UDP docs to mention a case where `CHPL_RT_MASTERIP` can help  
  (see https://chapel-lang.org/docs/2.4/platforms/udp.html#i-get-worker-failed-dnslookup-on-master-host-name-error-messages)
* fixed a bug in which `ChapelSysCTypes` was documented twice
* made numerous other minor changes, fixes, and improvements to documentation

Language Specification Improvements
-----------------------------------
* rewrote some examples in the spec to avoid an undesirable busy-wait loop  
  (see https://chapel-lang.org/docs/2.4/language/spec/memory-consistency-model.html#examples)
* updated sample code in the 'Types' chapter to be more inclusive
* removed documentation for no-longer-supported type comparisons like `<=`

Documentation Improvements for Libraries
----------------------------------------
* clarified documentation for `IO.file.init()`  
  (see https://chapel-lang.org/docs/2.4/modules/standard/IO.html#IO.file.init)

Documentation Improvements for Tools
------------------------------------
* added documentation for `chplcheck` linter rules  
  (see https://chapel-lang.org/docs/2.4/tools/chplcheck/chplcheck.html#current-rules)
* clarified build requirements for `chapel-py`  
  (see https://chapel-lang.org/docs/2.4/tools/chapel-py/chapel-py.html#installation)

Platform-Specific Documentation Improvements
--------------------------------------------
* updated documentation on binary packages for WSL  
  (see https://chapel-lang.org/docs/2.4/platforms/windows.html) 

Example Codes
-------------
* updated the HPCC benchmarks to compute good problem sizes for co-locales  
  (see `$CHPL_HOME/examples/benchmarks/hpcc/HPCCProblemSize.chpl`)

Performance Optimizations / Improvements
----------------------------------------
* extended the array view elision optimization to arrays of distinct types  
  (e.g. `LocalArr[x..y] = DistArr[z..t]` is now optimized)
* removed unnecessary checks in `Math.log2()` when `--no-checks` is used

Updates to Chapel's Release Formats
-----------------------------------
* updated our Dockerfile to use default dependency versions/the latest base OS

Configuration / Build Changes
-----------------------------
* moved warnings from `printchplenv` to the end of its output for clarity
* renamed `CHPL_MEM` to `CHPL_TARGET_MEM`  
  (see https://chapel-lang.org/docs/2.4/usingchapel/chplenv.html#chpl-mem)
* added checking that `CHPL_UNWIND` is set to a valid value
* added the ability to infer `CHPL_LLVM_GCC_INSTALL_DIR` when needed  
  (see https://chapel-lang.org/docs/2.4/usingchapel/chplenv.html#chpl-llvm-gcc-install-dir)

GPU Computing
-------------
* removed support for CUDA versions older than 11.7

Portability / Platform-specific Improvements
--------------------------------------------
* fixed a compilation error about missing `inet_aton()` on FreeBSD 13 and 14
* improved the `Python` module's handling of the system Python environment

Compiler Flags
--------------
* changed the `--mem` flag to `--target-mem` to match `CHPL_TARGET_MEM`

Error Messages / Semantic Checks
--------------------------------
* improved error messages for out-of-bounds accesses to tuple elements
* improved and added detailed error messages for use-before-definition errors
* added specialized error messages for defining a variable in terms of itself
* improved error messages reported by the `Sort` module for unsupported types

Runtime Library Improvements
----------------------------
* updated the runtime for `CHPL_COMM=ofi` to support libfabric 2.x
* increased the default/max number of threads supported by `CHPL_COMM=gasnet`
* added a warning when `CHPL_COMM` reduces the # of threads below `maxTaskPar`

Third-Party Software Changes
----------------------------
* updated the bundled version of GASNet to GASNet-2025.2.0-snapshot
* applied a performance fix to the bundled version of Qthreads
* removed the bundled copy of `fltk` due to portability/maintenance challenges

Bug Fixes
---------
* fixed an issue where variables of `extern` types were not default initialized
* fixed an internal error for `extern` return types in multilocale programs
* fixed an internal error when erroneously writing `super.init` twice
* fixed an internal error when assigning a type to a value
* fixed a bug permitting `range` type args to be used before they were defined
* fixed a bug in which `nothing` tuples were not properly cleaned up
* fixed arbitrary-length args and dependency paths in the compiler and runtime
* removed an extraneous error when using `--no-ieee-float` with the C backend

Bug Fixes for Libraries
-----------------------
* fixed various issues with `BigInteger` on 32-bit platforms
* fixed an ABI incompatibility bug between the `GMP` module and LLVM
* fixed a bug preventing `map`s to be passed into `const ref` formals
* fixed a bug with `distBag.addBulk()` when the input was not 0-based
* fixed a free of a non-allocated address in the `CopyAggregation` module
* fixed a bug with `MemDiagnostics.allocations()` on 32-bit systems
* partially fixed a bug with catching errors thrown from `fromJson`
* fixed the handling of comments inside arrays for the `TOML` package
* fixed a bug causing hangs in some `Socket` module functions
* fixed a bug to be able to pass `real`s as timeouts in `Socket` subroutines

Bug Fixes for GPU Computing
---------------------------
* fixed the use of `make check` with the GPU locale model
* fixed an assertion failure when using `CHPL_GPU=amd`

Bug Fixes for Tools
-------------------
* fixed the wrong linter sometimes being used when run with the language server
* fixed name-based linting for `extern` symbols
* fixed incorrect linter warnings for unused tuple unpacks
* fixed the linter's textual locations for various statement types and rules
* fixed a bug where a bad `RPATH` could be embedded in the `chapel-py` library
* fixed an issue with extra arguments passed to `c2chapel` on MacOS
* fixed `mason test` for prefix-based installs

Bug Fixes for Build Issues
--------------------------
* fixed LLVM path deduction logic when multiple LLVM versions are installed
* avoided overriding the default sysroot when using a system version of Clang
* fixed `CHPL_DEVELOPER` not being respected when set to a falsy value
* squashed `pathchk` error output from `./configure` commands

Bug Fixes for the Runtime
-------------------------
* fixed a seg fault when using `CHPL_TASKS=fifo` with `CHPL_COMM=gasnet`
* fixed a bug with the `CHPL_LAUNCHER_USE_SBATCH` implementation
* fixed a bug where Slurm-based launchers didn't preserve quoted string args
* fixed a bug with temporary filenames in PBS-based launchers
* fixed a bug in message buffer management for `CHPL_COMM=ofi`

Developer-oriented changes: Documentation
-----------------------------------------
* updated the instructions for building the Chapel CI Docker image

Developer-oriented changes: Module changes
------------------------------------------
* used the new `Value` class to clean up the `Python` module's implementation
* added a `CTypes` module when using minimal modules, enabling C interop

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* added scripts to update the Chapel version numbers in files that store them
* fixed a developer build issue with GCC 14 with C++ template arguments
* avoided spurious build warnings with MPICH 4 and GCC 12 when `WARNINGS=1`
* fixed documentation builds in dirty source trees for `chapel-py`
* added support for building a subset of LLVM targets
* added support for setting `CHPL_PYTHON` to switch Python versions

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* updated compiler paths from using fixed buffers to arbitrary-length strings
* removed warnings for 1.32 behavior changes in `chpl_comm_{get,put}()` prims

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* added support for bad split-initialization detection and errors
* added detailed errors for failed implicit `super` calls
* made numerous improvements to the 'dyno' resolver for types and calls:
  - enabled `for param` loops over more range types
  - added support for associative domain types and literals via modules
  - added initial support for `subdomain` and `sparse subdomain`
  - added support for rectangular/associative array type exprs via modules
  - enabled converting iterable expressions into arrays
  - added support for `.locale` queries
  - added support for `manage` statements and context managers
  - added support for `let` expressions
  - enabled iteration over heterogeneous tuples
  - enabled unpacking tuples yielded from `zip` expressions
  - added support for checking interface constraints
  - enabled importing tertiary methods via `use`/`import` limitations  
  - added basic support for resolution of nested types
  - enabled resolving enums nested in procedures
  - added support for `compilerError()` and `compilerWarning()` routines
  - added support for file-related reflection routines (e.g., `getLineNumber`)
  - added support for several primitives
  - fixed a bug accessing fields within a module with the same name
  - improved disambiguation process between callable objects and functions
  - fixed ambiguities between forwarded methods and non-forwarded routines
  - fixed handling of `if var` declarations and its generated `=` call
  - implemented numerous bug fixes and stability improvements
* added support for several language features to the typed dyno->prod converter

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added logic to avoid calls to `memalign()` with `size=0`
* updated runtime paths from using fixed buffers to arbitrary-length strings

Developer-oriented changes: Testing System
------------------------------------------
* improved logging for `.skipif` and `.suppressif` files in the test output
* fixed `sub_clean`, which was not properly cleaning up symlinks
* fixed `prediff-for-slurm` to handle output that is not UTF-8
* enabled timing 'dyno' queries across revisions in `testInteractive`

Developer-oriented changes: Utilities
-------------------------------------
* fixed a copyright update script bug that caused end-years to be repeated


version 2.3
===========

released December 12, 2024

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* added a new package module that supports calling to Python from Chapel
* made improvements to the Chapel linter, language server, and Python bindings
* added new builds for AmazonLinux 2023, Fedora 41, and Spack using ROCm
* significantly reduced overhead for many tasking idioms due to Qthreads 1.21
* optimized key communication idioms when using `CHPL_COMM=ofi`
* added initial support for min- and max-related ops on `atomic` variables
* improved CSR/CSC sparse arrays in terms of remote copy performance and naming
* added new routines for querying GPU IDs and GPU device attributes
* added an `allocations()` iterator to enumerate a given locale's memory usage
* made significant advances in the new 'dyno' type and call resolver
* made many other improvements in terms of bug fixes, errors, docs, etc.

Updates to Chapel's Release Formats
-----------------------------------
* enabled Spack support for building Chapel with ROCm  
  (see https://packages.spack.io/package.html?name=chapel)
* added single- and multi-locale packages for AmazonLinux 2023 and Fedora 41  
  (see https://chapel-lang.org/install-pkg.html)
* removed Linux package support for Fedora 37, 38, and 39
* began publishing 'amd64' nightly Docker images, in addition to 'arm64'  
  (see https://hub.docker.com/r/chapel/chapel/tags)

New Language Features
---------------------
* added support for `min`/`max`/`fetchMin`/`fetchMax` ops on atomic variables  
  (see https://chapel-lang.org/docs/2.3/language/spec/task-parallelism-and-synchronization.html#Atomics.fetchMin)

Language Feature Improvements
-----------------------------
* corrected how generic types with defaults are printed in many cases

New Standard Library Features
-----------------------------
* added an `allocations()` iterator to the `MemDiagnostics` module  
  (see https://chapel-lang.org/docs/2.3/modules/standard/MemDiagnostics.html#MemDiagnostics.allocations)

New Package Module Features
---------------------------
* added a new package module supporting calling to Python from Chapel  
  (see https://chapel-lang.org/docs/2.3/modules/packages/Python.html)

Changes / Feature Improvements in Package Modules
-------------------------------------------------
* expanded `PrecisionSerializer` to properly handle `complex` & `imag` values  
  (see https://chapel-lang.org/docs/2.3/modules/packages/PrecisionSerializer.html)
* improved errors thrown by `Image.mediaPipe` when `ffmpeg` is missing  
  (see https://chapel-lang.org/docs/2.3/modules/packages/Image.html#Image.mediaPipe)

New Standard Layout and Distribution Features
---------------------------------------------
* added new utility methods for sparse layouts and distributions
  - `.getCoordinates()` returns indices of non-zeroes for COO sparse arrays
  - `.localSubarrays()` yields each locale's subarray for a block-sparse array
  - `.getLocalSubarray()` returns the local subarray for a  block-sparse array
  - added `ref`-returning overloads of existing `.getLocalSubarray()` methods
* deprecated the `CS` class for CSR/CSC layouts for `[csr|csc]Layout` records  
  (see https://chapel-lang.org/docs/2.3/modules/layouts/CompressedSparseLayout.html#CompressedSparseLayout.csrLayout)

Name Changes for Standard Layouts and Distributions
---------------------------------------------------
* deprecated the `LayoutCS` module in favor of `CompressedSparseLayout`  
  (see https://chapel-lang.org/docs/2.3/modules/layouts/CompressedSparseLayout.html)

Name Changes in Libraries
-------------------------
* renamed `[Default|Reverse]Comparator` types to `[default|reverse]Comparator`  
  (see https://chapel-lang.org/docs/2.3/modules/standard/Sort.html#Sort.defaultComparator  
   and https://chapel-lang.org/docs/2.3/modules/standard/Sort.html#Sort.reverseComparator)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* removed the deprecated `defaultComparator` and `reverseComparator` vars  
* removed the previously deprecated config `fileOffsetWithoutLocking`

Performance Optimizations / Improvements
----------------------------------------
* significantly reduced overhead for many tasking idioms due to Qthreads 1.21
* optimized inter-locale transfers of sparse CSR/CSC arrays for `--fast` runs
* optimized `CHPL_COMM=ofi` by adding support for non-blocking PUT and GET ops
* optimized `CHPL_COMM=ofi` active messages via use of non-blocking PUTs
* improved performance on ARM-based Macs by using a 128-bit cache line

GPU Computing
-------------
* added a `.gpuId` method for GPU sublocales  
  (see https://chapel-lang.org/docs/2.3/language/spec/locales.html#ChapelLocale.locale.gpuId)
* added a `deviceAttributes()` query to the `GPU` module  
  (see https://chapel-lang.org/docs/2.3/modules/standard/GPU.html#GPU.deviceAttributes)
* `@gpu.itersPerThread` attribute can now distribute iterations round-robin  
  (see https://chapel-lang.org/docs/2.3/modules/standard/GPU.html#GPU.@gpu.itersPerThread)
* added initial support for calling `halt()` from GPUs

Portability / Build Improvements for GPUs
-----------------------------------------
* enabled support for building Chapel with ROCm from Spack
* GPU-related `CHPL_` variables can now be set in `chplconfig` files
* improved `chpl`'s ability to infer `CHPL_CUDA_PATH` and `CHPL_ROCM_PATH`
* exposed the current CUDA/ROCm version using `CHPL_GPU_SDK_VERSION`
* fixed an internal error when `CHPL_LOCALE_MODEL=gpu` and `CHPL_GPU=none`
* CUDA headers are now treated as system headers
* removed support for ROCm 4

Tool Improvements
-----------------
* added an `UnusedTaskIntent` linter rule to detect unused task intents
* added an `UnusedTypeQuery` linter rule to detect unused type queries
* added a `MissingInIntent` linter rule to detect missing `in` intents
* made the `ControlFlowParentheses` linter rule report more precise locations
* enabled the `UnusedFormal` linter rule by default
* improved the code completion support for `chpl-language-server` (CLS)
* added support for go-to-definition for called routines in CLS
* expanded the cases for pretty-printing code handled by `chpl-language-server`
* exposed the `chplcheck` argument `--internal-prefix` to linter rules
* added the ability for Mason to use a license reference repository  
  (see https://chapel-lang.org/docs/2.3/tools/mason/guide/environmentvariables.html)
* improved errors for improper uses of built-in `chapel-py` classes
* added `limitation_kind` & `limitations` to `VisibilityClause` in `chapel-py`

Documentation Improvements
--------------------------
* updated the task-parallel primer in terms of terminology and clarity  
  (see https://chapel-lang.org/docs/2.3/primers/taskParallel.html)
* updated the list of currently tested configurations in the GPU docs  
  (see https://chapel-lang.org/docs/2.3/technotes/gpu.html#tested-configurations)
* updated Chapel's `LICENSE` file to indicate that LLVM is now Apache 2.0  
  (see https://raw.githubusercontent.com/chapel-lang/chapel/refs/heads/release/2.3/LICENSE)
* fixed various typos and mis-spellings throughout the documentation

Documentation Improvements for Tools
------------------------------------
* added `chapel-py` API docs to the published documentation  
  (see https://chapel-lang.org/docs/2.3/tools/chapel-py/chapel-py.html#API)
* improved the documentation for `./configure` and `chplconfig`  
  (see https://chapel-lang.org/docs/2.3/usingchapel/building.html#installing-chapel)

Language Specification Improvements
-----------------------------------
* clarified the precedence of binary bitwise operations  
  (see https://chapel-lang.org/docs/2.3/language/spec/expressions.html#precedence-and-associativity)

Platform-Specific Documentation Improvements
--------------------------------------------
* split AWS docs into separate sections for binary vs. source distributions  
  (see https://chapel-lang.org/docs/2.3/platforms/aws.html#getting-chapel)
* replaced 'alinux2' with 'AmazonLinux 2023' in the AWS documentation  
  (see https://chapel-lang.org/docs/2.3/platforms/aws.html#configuring-a-parallelcluster)

Documentation Improvements for Libraries
----------------------------------------
* documented the `Image` module's support for reading and writing images
* updated an outdated reference to `channel` in the `subprocess` documentation  
  (see https://chapel-lang.org/docs/2.3/modules/standard/Subprocess.html#Subprocess.subprocess)
* fixed a rendering issue with some `map`-based methods

Example Codes
-------------
* updated examples w.r.t. new namings in `Sort` and `CompressedSparseLayout`

Memory Improvements
-------------------
* closed memory leaks in several package modules  
  (e.g., `ConcurrentMap`, `EpochManager`, `LockFreeStack`, and `LockFreeQueue`)

Syntax Highlighting
-------------------
* added missing keywords to the `vim` and `emacs` syntax highlighters

Configuration / Build Changes
-----------------------------
* improved the ability to infer flags required by a system's C compiler
* added warnings for setting `CHPL_LLVM_VERSION` or `CHPL_GPU_SDK_VERSION`
* improved error messages for incorrect `CHPL_NETWORK_ATOMICS` settings
* added a proper error message for invalid `CHPL_LOCALE_MODEL` settings

Compiler Improvements
---------------------
* added support for LLVM 19

Compiler Flags
--------------
* improved messaging when using `-j` or `--incremental` with the LLVM back-end

Error Messages / Semantic Checks
--------------------------------
* added a missing error when modifying `const ref` or default-`const` varargs
* improved the error message for mixing `return;` and `return x;` in a routine
* improved error messages for invalid qualified inheritance expressions
* improved the error message when trying to split-initialize using tuple syntax
* improved the error message for `main()` with a `type`/`param` return intent
* improved the error message when calling `popBack()` on an empty list

Launchers
---------
* added support for `--gpus-per-node` flags to all slurm-based launchers
* added `CHPL_LAUNCHER_GPUS_PER_NODE` support to slurm-based GASNet launchers
* reduced forwarding of unnecessary environment variables to GASNet launchers

Runtime Library Improvements
----------------------------
* extended `ofi` network atomics to support `min`/`max` operations
* extended `ofi` network atomics to support `atomic uint(8|16)` ops

Third-Party Software Changes
----------------------------
* updated the bundled version of LLVM to LLVM 19
* updated the bundled version of Qthreads to 1.21
* addressed a performance regression in Qthreads version 1.21 via a patch
* updated Python package versions used by `chpldoc`, `chapel-py` and the CLS
* explicitly pinned `pycparserext` version relied upon by `c2chapel` to 2021.1

Bug Fixes
---------
* fixed an internal error when applying parentheses to a paren-less method  
  (e.g., when writing `c.im()` rather than `c.im` for `var c: complex`)
* fixed a bug with Python interoperability when the module isn't used
* fixed a double-free bug with Python interoperability cleanup
* fixed a bug preventing `init=` with concrete arguments on generic records
* fixed inconsistencies between `printchplenv` and `chpl --print-chpl-settings`
* fixed a constness error for task-private class variables
* fixed constness errors due to iterables of types that contain `owned` classes
* fixed an internal error when returning iterable expression by `ref`
* resolved internal errors in certain `forwarding` statement cases
* avoided duplicate instantiations of types with `param bool` fields
* ensured correct handling of generic-with-default types in type comparisons
* prevented an infinite loop when printing errors in Chapel module code
* fixed compiler memory issues in reference constness analysis
* fixed compiler memory issues when mentioning generic type as `T;`

Bug Fixes for Libraries
-----------------------
* fixed a bounds-checking error when multiplying a `bigint` by a `uint`
* fixed a bug where parallel `fileReader.lines()` calls could drop a final `\n`
* fixed a bug when running `.lines()` calls using more locales than lines

Bug Fixes for GPU Computing
---------------------------
* fixed `complex` support from the CPU when using `CHPL_LOCALE_MODEL=gpu`
* fixed oversubscription when using`CHPL_LOCALE_MODEL=gpu`
* fixed AMD GPU logical-to-physical ID mappings for `CHPL_COMM=ofi`
* fixed an internal error with `CHPL_GPU=amd` and HPE/Cray hugepages modules

Bug Fixes for Tools
-------------------
* fixed missing `chplcheck` `MisleadingIndentation` warnings for nested stmts
* made numerous bug fixes in the Chapel language server (CLS)
  - fixed an infinite recursion bug when modifying standard modules
  - fixed a bug that could lead to missing error messages
  - fixed errors triggered by resolving calls in `OwnedObject`
  - fixed the "call hierarchy" feature to work correctly across multiple files
  - fixed memory errors due to de-allocated data stored in error messages

Bug Fixes for Build Issues
--------------------------
* fixed a formatting bug in the `RPATH` for the Chapel Python bindings
* made `CHPL_LIB_PATH` ignore empty strings between paths
* fixed a warning due to trailing spaces in linker arguments
* fixed `chapel-py` builds when Chapel is using address sanitization
* fixed an issue with `chplconfig` not supporting variables with equals signs
* made C libraries more consistent with how they respect `CFLAGS` and `LDFLAGS`
* stopped `printchplenv` from inferring `CHPL_LLVM_GCC_PREFIX` when not needed
* fixed the parsing for bundled `.pc` files

Bug Fixes for the Runtime
-------------------------
* fixed support for strided non-blocking remote memory accesses (RMAs)
* un-localized memory after non-blocking PUTs have completed
* added missing `tciFree()` calls to `chpl_comm_ensure_progress()`
* fixed incorrect variable names in the atomics compatibility layer

Developer-oriented changes: Module changes
------------------------------------------
* removed a no-longer-needed workaround in `chpl_defaultDistInitPrivate()`
* fixed a bug in the `ChapelHashtable._allSlots()` follower iterator code

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* fixed a bug preventing `make test-dyno` from running in parallel on macOS
* removed unused Makefiles in compiler sources built with `cmake`

Developer-oriented changes: Compiler Flags
------------------------------------------
* `--dyno` now activates the new experimental typed converter
* a new `--[no-]dyno-resolve-only` flag runs the dyno resolver and then stops

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* refactored the uAST-to-AST converter and created a separate typed converter
* added a callgraph analysis for the resolved uAST
* made numerous improvements to the 'dyno' resolver for types and calls:
  - enabled considering common class ancestors for return type unification
  - wired up rectangular domain resolution to use module code
  - enabled resolving serial and parallel loop expressions
  - enabled resolving promoted calls
  - improved resolution of default initializers
  - added support for resolving `init=` when initializing fields
  - enabled resolving returns from within `param` for-loops
  - allowed using receiver scope information within a `param` for-loop
  - trivially resolve non-`param` enum-to-string and string-to-string casts
  - fixed a bug passing `param` integral values to `param` formals
  - implemented casts from `borrowed` to `unmanaged`
  - fixed resolving uses of `type` fields in method signatures
  - improved resolution of type queries
  - added support for tuple variable decls with type and init expressions
  - added support for resolving nested routines that use outer variables
  - fixed a few ambiguity bugs involving nested functions and methods
  - fixed resolving `this` calls on shadowing variables
  - allowed inits in multi-variable decls to use a previous variable's types
  - enabled resolving uses of dependently-typed fields in methods
  - added a representation of the `_ddata` type
  - mapped resolution of the `owned` keyword to the `_owned` record
  - mapped resolution of the `sync` keyword to the `_syncvar` record
  - added support for creation of dyno uAST in compiler-generated functions
  - fixed a bug where `forwarding` with `except` would exclude all symbols
  - fixed a disambiguation bug improperly including intents as parts of a type
  - fixed incorrect ambiguity resolving field access on a record of same name
  - fixed `already deinited` bug for `in` formal passed again as `in` argument
  - renamed uses of 'parenth' to 'paren' match our normal abbreviation

Developer-oriented changes: GPU support
---------------------------------------
* `if gCpuVsGpuToken` now distinguishes between code generated for CPU vs. GPU

Developer-oriented changes: Runtime improvements
------------------------------------------------
* removed the previously deprecated GASNet-1 implementation of the runtime
* refactored GPU co-locale assignment code to be the same across all vendors

Developer-oriented changes: Testing System
------------------------------------------
* updated versions of various Python packages relied on by `start_test`
* allowed the use of semicolons in arguments to `sub_test`
* added guard to prevent test dependency loading script from being run twice
* improved behavior of python interop jobs when dependencies are missing
* fixed a handful a SyntaxWarning's caused by newer Python versions
* added a co-locale performance test suite for GASNet
* added nightly blog testing to gpu, multi-locale, and correctness configs
* increased the frequency of comparing Homebrew's released formula to our own


version 2.2
===========

released September 26, 2024

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* several new Linux packages are being released containing multi-locale support
* programmers can now define and use custom memory allocators with classes
* remote variable declarations are complete in terms of capabilities & behavior
* performance is significantly improved for key array programming patterns
* added ROCm 6 support for AMD GPUs, and generally improved GPU features & perf
* the 'Sort' module has been revised and promoted to a standard module
* new parallel/distributed I/O iterators are available in 'IO'/'ParallelIO'
* a new 'PrecisionSerializer' package controls numerical precision/padding
* the 'Image' and 'Zarr' package modules have been improved via new features
* made many other user-driven improvements w.r.t. bugs, errors, features, tools

Updates to Chapel's Release Formats
-----------------------------------
* added several new Linux package installations supporting multiple locales  
  (see https://chapel-lang.org/install-pkg.html)
* started publishing a `nightly` Docker image tag  
  (see https://hub.docker.com/r/chapel/chapel/tags)

New Language Features
---------------------
* added the ability to define and use custom memory allocators with classes  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Allocators.html)
* added the ability to apply attributes to interfaces

Language Feature Improvements
-----------------------------
* remote variable declarations are now fully implemented  
  (see https://chapel-lang.org/docs/2.2/technotes/remote.html)
  - initializer expressions are now evaluated on the remote locale
  - multi-var declarations and implicit `init=` conversions are now supported
* added support for declaring `enum`s within classes
* added support for using module-qualified expressions in inheritance decls  
  (e.g., `class Child: MyMod.Parent { ... }`)
* improved the orthogonality of Chapel syntax in several cases  
  (e.g., `coforall zip(a, b) { ... }` is now supported)
* added support for additional integer `<` comparisons generating a `param`

Semantic Changes / Changes to the Language Definition
-----------------------------------------------------
* `use` and `import` are now always case sensitive when finding module files  
  (see https://chapel-lang.org/docs/2.2/language/spec/modules.html#finding-toplevel-module-files)
* `require` statements no longer impact the determination of the main module  
  (see https://chapel-lang.org/docs/2.2/language/spec/statements.html#the-require-statement  
   and https://chapel-lang.org/docs/2.2/language/spec/modules.html#the-main-module)
* modules brought in with `require` are no longer initialized if not used
* standard library modules are now preferred in the event of a name conflict

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* user modules sharing names with a standard library module are now unstable
* removed previously deprecated support for `single` variables
* removed `clear()`, `retain()`, `release()`, `create()` on `shared`/`owned`
* removed previously deprecated `owned`/`shared` casts
* removed previously deprecated `assertOnGpu()` routine
* improved the deprecation message when using `<=>` on sync variables

New Standard Library Features
-----------------------------
* promoted the 'Sort' package module to be a standard module  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html)
* added a new argument to request a stable `sort()` (w.r.t. equal key orders)  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.sort)
* added new helper routines to convert values to and from JSON strings  
  (see https://chapel-lang.org/docs/2.2/modules/standard/JSON.html#JSON.fromJson)

New Package Module Features
---------------------------
* added new 'PrecisionSerializer' package to control numeric precision/padding  
  (see https://chapel-lang.org/docs/2.2/modules/packages/PrecisionSerializer.html)
* added support for reading images to the 'Image' module  
  (see https://chapel-lang.org/docs/2.2/modules/packages/Image.html#Image.readImage)
* added PNG and JPEG formats to the 'Image' module  
  (see https://chapel-lang.org/docs/2.2/modules/packages/Image.html#Image.imageType.png)
* added `colorToPixel()` and `pixelToColor()` routines to the 'Image' module  
  (see https://chapel-lang.org/docs/2.2/modules/packages/Image.html#Image.colorToPixel)

Changes / Feature Improvements in Standard Libraries
----------------------------------------------------
* added parallel/distributed support to the `fileReader.lines()` iterator  
  (see https://chapel-lang.org/docs/2.2/modules/standard/IO.html#IO.fileReader.lines)
* added an unstable `sort()` overload accepting a region of indices to sort  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.sort)
* added multi-dimensional support to several `randomStream` methods  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Random.html#Random.randomStream.shuffle)
* added support for passing distributed arrays to `c_addrOf()`
* made `sendPosixSignal()` throw an `IllegalArgumentError` for bad signals  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Subprocess.html#Subprocess.subprocess.sendPosixSignal)
* improved the error message for calling `sort()` on unsupported types

Changes / Feature Improvements in Package Modules
-------------------------------------------------
* added multi-locale support to iterators in the 'ParallelIO' module  
  (see https://chapel-lang.org/docs/2.2/modules/packages/ParallelIO.html#ParallelIO.readLines)
* added support for configurable compressors to the 'Zarr' module  
  (e.g., see https://chapel-lang.org/docs/2.2/modules/packages/Zarr.html#Zarr.writeZarrArray)
* extended the 'Zarr' module to support single-locale IO  
  (e.g., see https://chapel-lang.org/docs/2.2/modules/packages/Zarr.html#Zarr.readZarrArrayLocal)
* added the ability to read a 'Zarr' array using arbitrary target locales  
  (see https://chapel-lang.org/docs/2.2/modules/packages/Zarr.html#Zarr.readZarrArray)

Name Changes in Libraries
-------------------------
* renamed the array arguments for `Sort.sort()` and `Sort.isSorted()`  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.sort  
   and https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.isSorted)
* renamed the `a`,`b` arguments for `compare()` methods in 'Sort' to `x`, `y`  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.DefaultComparator.compare  
   and https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.ReverseComparator.compare)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* added a `false` default to the `locking` property of `file.[reader|writer]`  
  (see https://chapel-lang.org/docs/2.2/modules/standard/IO.html#IO.file.reader  
   and https://chapel-lang.org/docs/2.2/modules/standard/IO.html#IO.file.writer)
* deprecated the standalone comparator instances in the 'Sort' module  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.defaultComparator  
   and https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.reverseComparator)
* deprecated the `inPlaceAlgorithm` argument for the `Sort.sort()` procedure  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#Sort.sort)
* deprecated creating custom 'Sort' comparators in favor of using interfaces  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Sort.html#comparators)
* deprecated `list.sort()` in favor of `Sort.sort(x: list)`  
  (see https://chapel-lang.org/docs/2.2/modules/standard/List.html#List.list.sort)
* removed the deprecated 'VectorizingIterator' module
* removed deprecated `locking=true` overloads of `open[Reader|Writer]()`
* removed deprecated `IllegalArgumentError` overloads in the 'Errors' module
* removed the deprecated `RandomStream` class and `randomStream` methods
* removed the deprecated 'RandomSupport' and 'PCGRandom' submodules

Performance Optimizations / Improvements
----------------------------------------
* significantly improved performance when assigning between array slices  
  (e.g., `Arr1[x..y] = Arr2[a..b]` now performs up to 30x faster)
* enabled an optimization that auto-localizes `const` domains  when possible  
  (use `-slocalizeConstDomains=false` to disable)
* removed an unnecessary allocation when moving an array value to a typed var
* extended the automatic local-access optimization to handle basic stencils  
  (e.g., `forall i in InnerA {... A[i-1] ...}` is optimized for 'StencilDist')
* reduced communication overheads in 'StencilDist's `.updateFluff()` method
* significantly reduced unnecessary fencing overheads when using `ofi`

GPU Computing
-------------
* added support for ROCm 6  
  (see https://chapel-lang.org/docs/2.2/technotes/gpu.html#requirements)
* improved performance for certain kernels on multi-GPU locales
* added a new `@gpu.assertEligible` attribute for compile-time GPU checks  
  (see https://chapel-lang.org/docs/2.2/modules/standard/GPU.html#GPU.@gpu.assertEligible)
* added a new `@gpu.itersPerThread` attribute to control blocking iterations  
  (see https://chapel-lang.org/docs/2.2/modules/standard/GPU.html#GPU.@gpu.itersPerThread)
* added support for GPU attributes to compile without the GPU locale model
* added a warning when `@assertOnGpu` is used without the GPU locale model
* added support for `ref` intents on scalars in GPU-eligible loops
* extended co-locale support to divide GPUs between co-locales
* extended `make check` to test a GPU-oriented example when GPUs are enabled
* improved the error message when a vendor's SDK can't be found

Tool Improvements
-----------------
* added an `--only` flag to `printchplenv` to focus on a specific variable  
  (e.g., `$CHPL_HOME/util/printchplenv --only CHPL_TARGET_COMPILER`)
* made several changes and improvements to the `chplcheck` linter  
  (see https://chapel-lang.org/docs/2.2/tools/chplcheck/chplcheck.html)
  - added a new rule for a `complex` literal whose `imag` precedes its `real`
  - allowed the ability to ignore incorrect indentation within a given scope
  - added support for a `@fixit` decorator to the Python API
  - renamed the `RedundantParentheses` rule to `ControlFlowParentheses`
* added the ability to document interfaces with `chpldoc`
* updated the script for anonymizing unstable warnings  
  (see https://chapel-lang.org/docs/2.2/tools/unstableWarningAnonymizer/unstableWarningAnonymizer.html)

Documentation Improvements
--------------------------
* linked the module index from the documentation landing page  
  (see https://chapel-lang.org/docs/2.2/#indexes)

Documentation Improvements for Tools
------------------------------------
* added a new 'Editor Support' page  
  (see https://chapel-lang.org/docs/2.2/usingchapel/editor-support.html)
* improved the debugging best practices documentation for macOS  
  (see https://chapel-lang.org/docs/2.2/usingchapel/debugging.html#best-known-configuration)
* added a section discussing when to use `mason` to the Mason documentation  
  (see https://chapel-lang.org/docs/2.2/tools/mason/mason.html#when-to-leverage-mason-for-chapel-builds)

Language Specification Improvements
-----------------------------------
* documented the process of finding module files through `use` and `import`  
  (see https://chapel-lang.org/docs/2.2/language/spec/modules.html#finding-toplevel-module-files)
* added a section describing the implicit `this.` in methods  
  (see https://chapel-lang.org/docs/2.2/language/spec/methods.html#implicit-this-in-methods)
* clarified that terminating null bytes are optional on string/bytes buffers  
  (e.g., see https://chapel-lang.org/docs/2.2/language/spec/strings.html#String.string.createAdoptingBuffer)
* added examples of distribution factory methods  
  (see https://chapel-lang.org/docs/2.2/language/spec/domain-maps.html#distributions-for-domain-types)
* searching for `init=` now finds the relevant language spec documentation

Platform-Specific Documentation Improvements
--------------------------------------------
* expanded docs for using Chapel with Windows Subsystem for Linux (WSL)  
  (see https://chapel-lang.org/docs/2.2/platforms/windows.html#using-chapel-on-wsl)

Documentation Improvements for Libraries
----------------------------------------
* fixed and improved descriptions of library modules in Chapel's module index  
  (see https://chapel-lang.org/docs/2.2/chpl-modindex.html)
* added documentation of the GPU attributes to the 'GPU' module docs  
  (see https://chapel-lang.org/docs/2.2/modules/standard/GPU.html#GPU.@gpu.assertEligible)
* corrected/extended the documentation for `atan()` and `atan2()`  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Math.html#Math.atan  
   and https://chapel-lang.org/docs/2.2/modules/standard/Math.html#Math.atan2)
* documented which errors can be thrown from 'Subprocess' procedures  
  (e.g., see https://chapel-lang.org/docs/2.2/modules/standard/Subprocess.html#Subprocess.subprocess.close)
* noted errors from `spawn`/`spawnshell` may be delayed until later calls  
  (see https://chapel-lang.org/docs/2.2/modules/standard/Subprocess.html#Subprocess.spawn)
* clarified the compilation commands for 'LinearAlgebra' and 'LAPACK' modules  
  (see https://chapel-lang.org/docs/2.2/modules/packages/LAPACK.html#compiling-with-lapack  
   and https://chapel-lang.org/docs/2.2/modules/packages/LinearAlgebra.html#compiling-with-linear-algebra)
* made numerous other docs fixes and improvements: wordings, typos, links, etc.

Documentation Improvements to the 'man' Pages
---------------------------------------------
* cross-referenced env var docs within 'Compiler Configuration Options'  
  (see https://chapel-lang.org/docs/2.2/usingchapel/man.html#man-task-tracking)

Example Codes
-------------
* added a new `examples/gpu/` directory for GPU-oriented example codes  
  (see `$CHPL_HOME/examples/gpu/README`)
* restored `examples/patterns/recordio.chpl` using 2.0-compatible features  
  (see `$CHPL_HOME/examples/patterns/recordio.chpl`)
* updated example codes with respect to 'Sort' and 'Random' module changes

Memory Improvements
-------------------
* removed an unnecessary allocation when moving an array value to a typed var
* fixed a memory leak when using loop expressions with empty bodies
* fixed a memory leak when ignoring values in `try!` expressions
* fixed a memory leak when using per-locale "static" variables  
* fixed a memory leak when reading with the 'Zarr' package module

Configuration / Build Changes
-----------------------------
* added `CHPL_[TARGET|HOST]_JEMALLOC` to specify 'jemalloc' usage and sources  
  (see https://chapel-lang.org/docs/2.2/usingchapel/chplenv.html#chpl-target-jemalloc  
   and https://chapel-lang.org/docs/2.2/usingchapel/chplenv.html#chpl-host-jemalloc)
* added `CHPL_LLVM_GCC_INSTALL_DIR` to work with a specific GCC installation  
  (see https://chapel-lang.org/docs/2.2/usingchapel/chplenv.html#chpl-llvm-gcc-install-dir)
* added `CHPL_COMM_OFI_OOB` to specify out-of-band launch mechanism for `ofi`  
  (see https://chapel-lang.org/docs/2.2/platforms/libfabric.html#building-chapel-with-the-ofi-communication-layer)
* added a warning when using `CHPL_ATOMICS=intrinsics`  
  (see https://chapel-lang.org/docs/2.2/usingchapel/chplenv.html#chpl-atomics)
* improved errors for `CHPL_TARGET_COMPILER`/`CHPL_TARGET_CC` mismatches

Portability / Platform-specific Improvements
--------------------------------------------
* made the default for `CHPL_ATOMICS` always be `cstdlib` for bundled LLVM
* disallowed the use of `CHPL_ATOMICS=locks` on macOS
* added the ability to infer the path for `nvcc` from `CHPL_CUDA_PATH`
* changed the Fedora 40 package dependencies to use LLVM 18
* filtered out `-L/usr/lib` when linking to avoid problems on some platforms

Compiler Improvements
---------------------
* made the compiler remove dead modules more aggressively early in compilation

Compiler Flags
--------------
* added a `--lib-pic` flag to control `CHPL_LIB_PIC`'s value at compile time  
  (see https://chapel-lang.org/docs/2.2/usingchapel/man.html#man-lib-pic  
   and https://chapel-lang.org/docs/2.2/usingchapel/chplenv.html#chpl-lib-pic)
* added `--[no-]array-view-elision` to control optimizations of slices/views  
  (see https://chapel-lang.org/docs/2.2/usingchapel/man.html#man-array-view-elision)
* added `--[no-]offset-auto-local-access` to control stencil locality opts  
  (see https://chapel-lang.org/docs/2.2/usingchapel/man.html#man-offset-auto-local-access)
* extended `--print-commands` to include commands run with `--library-python`

Error Messages / Semantic Checks
--------------------------------
* added an error when incorrectly modifying `const [in]` or default varargs
* added an error when modifying `const` `sync` variables
* improved error messages when `const` `c_array`s are passed to `c_ptr` formals
* improved task intent errors for tuples
* added a user error when constructing incomplete `extern` types
* improved the error message for incorrect placement of intent keywords  
  (e.g., `proc in A.foo() { }`)
* added an error for attempted uses of `sync nothing`, which is not supported
* improved the error message for casting abstract `enum`s to numeric types
* improved the error message for incorrectly formatted `with` clauses  
  (i.e. `begin with ref A { }`)
* improved errors for generic anonymous functions  
  (e.g., `proc(x: []) { }`)
* improved the error when creating an associative domain of `owned` classes
* improved the error message when `sparse subdomain` is used incorrectly
* improved error message when accidentally creating special method iterators
* improved error when using same location for `chpldoc` output and Sphinx files
* added a user error when `getFieldRef()` is used on a `type` field
* updated memory management checks for non-classes to fire in more cases
* added a warning for ignoring the result of a function capture
* improved the surprising shadowing warning to consider enclosing module names

Third-Party Software Changes
----------------------------
* updated the bundled version of Qthreads to 1.20
* applied a Qthreads patch to address a performance regression in version 1.20

Bug Fixes
---------
* fixed a bug in `scan` expressions over non-`int(64)` indices
* fixed alignment for records whose fields are a mix of `extern` types and non-
* fixed a bug in which the compiler incorrectly complained about missing `(?)`
* fixed bugs in auto local-access/aggregation optimizations for local arrays
* fixed an automatic-local-access bug for certain poorly aligned zippered loops
* fixed a bug in which certain rank-change slices failed to compile
* fixed support for interfaces nested within subroutines
* removed a redundant library linkage specifier when using `--library-makefile`
* fixed a bug with default values and Python interoperability
* fixed an incorrect deprecation when creating a distributed array of atomics
* fixed a crash when assigning a module-scope `var` to a `ref` in an iterator
* fixed a bug where types of promoted expressions could be incorrectly inferred
* fixed an incorrect error about missing constructor arguments in some cases
* fixed "using value as type" errors in certain conditional type expressions
* allowed `ref`-intent procedures to not return anything if they halt
* fixed an internal error when `out` is used with a default value and no type
* fixed an internal error when returning a `ref` to a value of different type
* fixed an internal error when using first-class fns as arguments to classes
* fixed compilation errors due to runtime types under `--baseline`
* fixed a problem importing from a parent module from an `include`d submodule
* fixed problems resolving calls to parenless methods from within a method

Bug Fixes for Libraries
-----------------------
* fixed a bug preventing `this` from being passed to `Reflection.getFieldRef()`
* fixed 'RangeChunk's `chunks*()` iterators  for non-`int(64)` indices
* fixed a bug where `heap.createHeap()` only accepted the default comparator

Bug Fixes for GPU Computing
---------------------------
* fixed a bug where `on myVar` didn't work correctly for GPU-stored variables
* fixed a bug where some `for` loops could cause inadvertent kernel launches
* fixed support for the `--library` flag when compiling for GPUs
* fixed code generation for ROCm 5.4.3, which was seg faulting
* fixed a bug that prevented Chapel to be built with Clang 18 and CUDA 11
* fixed a bug where GPU allocations on CPU data structures caused segfaults
* fixed a bug where some kernel launch diagnostics line numbers were incorrect
* fixed a host-to-device copy in which an incorrect function was being called
* fixed various errors when bulk transferring GPU arrays

Bug Fixes for Tools
-------------------
* fixed 'goto definition' for inheritance and `enum`s in `chpl-language-server`
* fixed how locations are reported for `enum` elements
* silenced an erroneous `IncorrectIndentation` warning from `chplcheck`
* fixed the `chapel-py` build to use the same compiler as the frontend library

Bug Fixes for Build Issues
--------------------------
* fixed `printchplenv` and `printchplbuilds.py` output for prefix installations
* fixed erroneous `--specialize` warnings when using multi-locale OS packages
* ensured that `pycache` is fully deleted with `make clobber`
* fixed an issue building `CHPL_COMM=gasnet` Docker images

Bug Fixes for the Runtime
-------------------------
* fixed a bug with `CHPL_COMM=ofi` that led to hangs at certain scales
* fixed a bug in progressing non-blocking operations with `CHPL_COMM=ofi`
* worked around a bug with `ofi/efa` related to lack of injection support
* fixed a bug striping the fixed heap for `CHPL_COMM=gasnet` over non-`ibv`

Developer-oriented changes: Process
-----------------------------------
* added a CI check for badly formatted performance tests

Developer-oriented changes: Documentation
-----------------------------------------
* extended the standard module style guide to include more 2.0 decisions  
  (see https://chapel-lang.org/docs/2.2/developer/bestPractices/StandardModuleStyle.html)

Developer-oriented changes: Module changes
------------------------------------------
* removed queries from the argument lists of the 'Sort' routines

Developer-oriented changes: Compiler Flags
------------------------------------------
* added `--llvm-print-ir-file` to write LLVM IR to a file rather than `stdout`

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* removed the broken features intended to support `gdb` cleanup of `tmp` dirs
* added a missing check for `--break-on-codegen-id` on `CForLoop`
* refactored the `always_inline` code for GETs and PUTs

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* the frontend library now drives the process of deciding which files to parse
* made numerous improvements to the 'dyno' resolver for types and calls:
  - added support for resolving tuple accessor calls
  - added support for iterating over `enum` types
  - added support for casting `param` `enum` values to strings
  - implemented paren-less `type`/`param` procs on nilable types
  - added initial support for resolving `zip` expressions and parallel `iter`s
  - improved support for initializers on classes that inherit
  - improved error messages for out-of-order field initialization
  - fixed an error resolving initializers w/ generic fields following concrete
  - adjusted the resolver to syntactically determine whether fields are generic
  - added support for type construction of generic classes
  - fixed a bug resolving constrained, dependently-typed type constructor args
  - fixed a bug passing instantiated generics to generic record formal args
  - improved support for forwarding unmanaged class methods
  - fixed resolution of methods on types that are only generic by inheritance
  - added support for resolving generic routines when passed tuple arguments
  - fixed an incorrect ambiguity between fields and unrelated secondary methods
  - fixed an error for ambiguities btwn locals and paren-less procs in methods
  - fixed a bug causing `testInteractive --std` to not resolve std module types
  - improved performance of `runAndTrackErrors` API function
* improved the performance of `--dyno-scope-bundled`

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added a missing assertion for a non-null pointer

Developer-oriented changes: Testing System
------------------------------------------
* removed the default application of the `-o` flag in the `start_test` system


version 2.1
===========

released June 27, 2024

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* added Chapel installations using Spack or several Linux package managers
* improved the performance and hardware utilization of the Homebrew formula
* added a new prototype ability to directly declare variables on remote locales
* improved sparse domains/arrays via new utility routines and generality
* integrated GPU reductions with Chapel's `reduce` expressions and intents
* made numerous/significant improvements to the linter and language server
* added a new 'Image' package module and updated 'AtomicObjects' to support Arm
* improved docs in many ways, incl. better search and a new portability page
* updated the `chpl` compiler to support (and prefer) LLVM 18
* improved Chapel's support for AWS EFA
* updated GASNet configs to use the GASNet-EX API and support new features
* made many other user-motivated improvements w.r.t. bugs, features, and tools

Updates to Chapel's Release Formats
-----------------------------------
* started releasing Chapel as a Spack package  
  (see https://chapel-lang.org/install-spack.html)
* started releasing Chapel packages for several Linux distributions  
  (see https://chapel-lang.org/install-pkg.html)
* updated Chapel's Homebrew formula to install the preferred shared-mem config

Prerequisite Updates
--------------------
* Chapel now requires Python 3.5 or newer  
  (see https://chapel-lang.org/docs/2.1/usingchapel/prereqs.html#readme-prereqs)
* updated the Python package versions used by `chpldoc`  
  (see `$CHPL_HOME/third-party/chpl-venv/chpldoc-requirements*.txt` for details)
* added sample installation commands for Ubuntu Noble to the prereqs doc  
  (see https://chapel-lang.org/docs/2.1/usingchapel/prereqs.html#installation)

Syntactic / Naming Changes
--------------------------
* stopped allowing spaces after `@` in attributes, which were never intended  
  (see https://chapel-lang.org/docs/2.1/technotes/attributes.html)

New Language Features
---------------------
* added a prototype implementation of remote variable declarations  
  (see https://chapel-lang.org/docs/2.1/technotes/remote.html)

Language Feature Improvements
-----------------------------
* made `in` intent copy behavior for `foreach` loops consistent with `forall`
* enabled support for assigning between sparse arrays with matching indices  
  (e.g., `mySpsArr = mySpsArr2;` now works if the arrays' domains are equal)
* extended local vars that persist across calls to support per-locale copies  
  (see https://chapel-lang.org/docs/2.1/technotes/static.html#sharing-kinds)
* stabilized operators between tuples and scalars, like `+`, `-`, `*`, etc.  
  (see https://chapel-lang.org/docs/2.1/language/spec/tuples.html#tuple-operators)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* deprecated support for `dmapped` clauses with `new`-less initializer calls  
  (see https://chapel-lang.org/docs/2.1/language/spec/domain-maps.html#distributions-for-domain-types)

New Standard Library Features
-----------------------------
* added a `randomStream.sample()` overload that accepts a 'weights' argument  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Random.html#Random.randomStream.sample)

New Package Module Features
---------------------------
* added a new 'Image' package module for writing out image files  
  (see https://chapel-lang.org/docs/2.1/modules/packages/Image.html)
* added support for configurable profiling to the 'Zarr' IO package module  
  (see https://chapel-lang.org/docs/2.1/modules/packages/Zarr.html#Zarr.zarrProfiling)

Changes / Feature Improvements in Standard Libraries
----------------------------------------------------
* improved the return types of `imag` trigonometric/hyperbolic 'Math' routines  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Math.html#Math.useNewImaginaryTrig)
* 'IO' routines like `advanceThrough()` now throw errors for empty separators  
   (see https://chapel-lang.org/docs/2.1/modules/standard/IO.html#IO.fileReader.advanceThrough)
* updated the `regex` initializer to convey that `posix` enables `multiLine`  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Regex.html#Regex.regex.init)
* added support for `mp_exp_t` and `mpf_get_str()` to the 'GMP' module  
  (see https://chapel-lang.org/docs/2.1/modules/standard/GMP.html#GMP.mp_exp_t  
   and https://chapel-lang.org/docs/2.1/modules/standard/GMP.html#GMP.mpf_get_str)
* improved support for 'GMP' routines that accept varargs  
  (e.g., see https://chapel-lang.org/docs/2.1/modules/standard/GMP.html#GMP.gmp_printf)

Changes / Feature Improvements in Package Modules
-------------------------------------------------
* updated 'BLAS' `alpha`/`beta` arguments to accept `const`/`param` vals  
  (e.g., see https://chapel-lang.org/docs/2.1/modules/packages/BLAS.html#BLAS.gemm)
* enabled the 'AtomicObjects' package module to work on Arm processors  
  (see https://chapel-lang.org/docs/2.1/modules/packages/AtomicObjects.html)

Standard Layouts and Distributions
----------------------------------
* added a new initializer to 'LayoutCS', supporting positional arguments
* added new utility routines for sparse arrays stored using 'LayoutCS':
  - `rows`/`cols()` queries to return the dense range of indices per dimension
  - `[cols|rows]AndVals()` iterators that yield non-zeroes' indices and values
* enabled `.targetLocales()` queries on sparse `blockDist` domains/arrays
* added new utility routines for sparse `blockDist`-distributed domains/arrays:
  - `setLocalSubdomain()` to assign the current locale's subdomain of nonzeroes
  - `[get|set]LocalSubarray()` to query/set the current locale's nonzero values

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* deprecated the `cIsoDayOfWeek` `config param` from the 'Time' module
* removed several deprecated features from the 'Time' module:
  - the `MINYEAR` and `MAXYEAR` constants
  - the day-of-week `enum`s as well as procedures that used them
  - the `getCurrentDate()`, `isoCalendar()`, `isoFormat()`, `abs()` procedures
  - the `dateTime` ordinal methods and `combine()` method

Tool Improvements
-----------------
* made numerous improvements to Chapel's linter, `chplcheck`:
  - added support for auto-fixits  
    (see https://chapel-lang.org/docs/2.1/tools/chplcheck/chplcheck.html#fixits)
  - added a `chplcheck` warning for simple domains in loops  
    (e.g., `for i in {1..10} do ...` should be `for i in 1..10 do ...`)
  - added a warning that checks for improper indentation
  - added a warning for redundant semicolons
  - added a warning for pointless pattern-matching like `(_, _)`
  - added a warning for redundant parentheses in if-else and loop conditions
  - added command-line flags to list available and enabled rules  
    (see https://chapel-lang.org/docs/2.1/tools/chplcheck/chplcheck.html#enabling-disabling-rules)
  - allowed silencing advanced rules with `@chplcheck.ignore`  
    (see https://chapel-lang.org/docs/2.1/tools/chplcheck/chplcheck.html#making-rules-ignorable)
  - fixed false positives in 'MisleadingIndentation' rule
* made numerous improvements to the Chapel language server (CLS):
  - provided auto-completion for symbols from `use` and `import` statements
  - enabled go-to-definition on identifiers in `use` and `import` statements
  - adjusted error messages to display additional information on hover
  - ensured redefinition errors are issued as intended in more cases
  - extended call inlays to support negative numbers and `complex` literals
  - expanded support for end-block markers
  - ensured types displayed in hints are valid Chapel syntax
  - added a `--chplcheck` flag to run linting from within the CLS  
    (see https://chapel-lang.org/docs/2.1/tools/chpl-language-server/chpl-language-server.html#using-chplcheck-from-cls)
  - added a `--[no]-show-instantiations` flag to control CLS code lenses  
    (see https://chapel-lang.org/docs/2.1/tools/chpl-language-server/chpl-language-server.html#experimental-resolver-features)
* improved error messages when Python versions don't match in `chapel-py` tools
* added the Sphinx and chapeldomain versions to `chpldoc --version` output
* updated `c2chapel` to map `FILE` to `c_FILE`
* updated script for anonymizing unstable warnings w.r.t. Chapel 2.1 behavior  
  (see https://chapel-lang.org/docs/2.1/tools/unstableWarningAnonymizer/unstableWarningAnonymizer.html)
* improved Mason error messages when dependencies are missing

GPU Computing
-------------
* added support for `reduce` expressions and intents within GPU kernels
* extended GPU attributes to apply to promoted initializer expressions
* added support for `syncWarp()` for gpu kernels  
  (see https://chapel-lang.org/docs/2.1/modules/standard/GPU.html#GPU.syncWarp)
* extended `@gpu.blockSize` to support GPU-ineligible expressions as arguments

Performance Optimizations / Improvements
----------------------------------------
* added an experimental optimization that localizes domains for array copies  
  (enable by compiling with `-slocalizeConstDomains=true`)
* enabled bulk assignment between sparse arrays whose index sets match
* applied LLVM inlining to reduce overheads for remote data transfers
* improved performance for several 'IO' `fileReader` methods like `readAll()`
* improved the performance of `regex.replace*()` methods in the 'Regex' module
* improved code-generation of `complex` math functions for better performance

Documentation Improvements
--------------------------
* improved the behavior of the documentation search box  
  (e.g., see https://chapel-lang.org/docs/2.1/search.html?q=forall&check_keywords=yes&area=default)
* added a new page documenting and visualizing Chapel's portability  
  (see https://chapel-lang.org/docs/2.1/usingchapel/portability.html)
* refreshed the 'Chapel Quick Reference' document for 2.x versions  
  (see https://chapel-lang.org/docs/2.1/language/reference.html)
* updated Quickstart instructions to show commands for setting `CHPL_LLVM`  
  (see https://chapel-lang.org/docs/2.1/usingchapel/QUICKSTART.html#using-chapel-in-its-preferred-configuration)
* added a mention of expected memory requirements for building Chapel  
  (see https://chapel-lang.org/docs/2.1/usingchapel/prereqs.html)
* improved descriptions of routines like `expand()` in the domain primer  
  (see https://chapel-lang.org/docs/2.1/primers/domains.html)
* clarified Chapel environment requirements for GPUs  
  (see https://chapel-lang.org/docs/2.1/technotes/gpu.html#requirements)
* added `-M` to the list of useful compiler flags and improved `-s`'s position  
  (see https://chapel-lang.org/docs/2.1/usingchapel/compiling.html#most-useful-flags)
* fixed broken links in the prerequisites docs  
  (see https://chapel-lang.org/docs/2.1/usingchapel/prereqs.html#amazon-linux-2-chpl-llvm-system-incompatibility)

Documentation Improvements for Tools
------------------------------------
* refactored the tools documentation to be more user-friendly  
  (see https://chapel-lang.org/docs/2.1/tools/)
* documented how to install the language server and linter tools for Emacs  
  (see https://chapel-lang.org/docs/2.1/tools/chpl-language-server/chpl-language-server.html#emacs  
   and https://chapel-lang.org/docs/2.1/tools/chplcheck/chplcheck.html#emacs)
* added a 'quick start' section to the documentation for `mason`  
  (see https://chapel-lang.org/docs/2.1/tools/mason/mason.html#quick-start-instructions)
* updated the VSCode extension's documentation  
  (see https://chapel-lang.org/docs/2.1/tools/chpl-language-server/chpl-language-server.html#vscode)

Language Specification Improvements
-----------------------------------
* added index entries for the language specification  
  (see https://chapel-lang.org/docs/2.1/genindex.html)
* documented the behavior of parenless procedure calls in generic functions  
  (see https://chapel-lang.org/docs/2.1/language/spec/generics.html#function-visibility-in-generic-functions)
* improved formatting of the 'Task Parallelism and Synchronization' chapter  
  (see https://chapel-lang.org/docs/2.1/language/spec/task-parallelism-and-synchronization.html)

Platform-Specific Documentation Improvements
--------------------------------------------
* updated the Mac OS X platform docs to describe non-homebrew installations  
  (see https://chapel-lang.org/docs/2.1/platforms/macosx.html#building-from-source)
* added documentation for running with hugepages when using AWS EFA  
  (see https://chapel-lang.org/docs/2.1/platforms/aws.html#building-chapel)

Technical Note Improvements
---------------------------
* improved the descriptions of `require` statements and `-I`/`-L` flags  
  (see https://chapel-lang.org/docs/2.1/technotes/extern.html#expressing-dependencies)
* clarified how to call module init functions when using Chapel as a library  
  (see https://chapel-lang.org/docs/2.1/technotes/libraries.html#initializing-your-library  
   and https://chapel-lang.org/docs/2.1/technotes/libraries.html#initializing-and-using-your-library-from-fortran)
* updated the `manage` technote to reflect the current state of the language  
  (see https://chapel-lang.org/docs/2.1/technotes/manage.html)

Documentation Improvements for Libraries
----------------------------------------
* documented that 'Regex' replacement can use capture groups like `\1`  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Regex.html#Regex.string.replace)
* documented how a `fileReader` behaves when reading invalid UTF-8  
  (see https://chapel-lang.org/docs/2.1/modules/standard/IO.html#unicode-support)
* fixed the docs for `[numBits|numBytes|min|max]()` in 'Types' w.r.t. `bool`s  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Types.html#Types.numBits)
* removed some accidentally documented `ioerror()` routines in the 'OS' module

Documentation Improvements to the 'man' Pages
---------------------------------------------
* added support for linking to a specific flag's entry on the 'man' page  
  (e.g., see https://chapel-lang.org/docs/2.1/usingchapel/man.html#man-module-dir)
* removed outdated compiler internal information from `chpl`'s 'man' page
* simplified the version numbers on our 'man' pages to reduce maintenance  
  (e.g., see the last line when running `man chpl`)

Example Codes
-------------
* updated example codes to avoid deprecated `dmapped` clause patterns
* updated `revcomp-fast.chpl` to reflect changes in thrown errors
* fixed a docs/code inconsistency in the 'distributions' primer
* added index entries to some primers to aid in documentation search results

Generated Code Improvements
---------------------------
* added `const` qualifiers for `c_ptrConst` types in generated C code

Configuration / Build Changes
-----------------------------
* added support for building with `CHPL_HWLOC=system` and/or `CHPL_GMP=system`  
  (see https://chapel-lang.org/docs/2.1/usingchapel/chplenv.html#chpl-hwloc  
   and https://chapel-lang.org/docs/2.1/usingchapel/chplenv.html#chpl-gmp)
* added an error message if the user attempts to set `CHPL_RE2=system`
* improved error messages when the Clang version doesn't match LLVM
* added `chpl-shim` to `make install` to make it available in the user's path
* added `printchplenv --ignore-errors` to continue past errors encountered
* removed some unnecessary `__pycache__` files from the released source tarball

Portability / Platform-specific Improvements
--------------------------------------------
* improved portability for various compilers and libraries  
  (e.g. LLVM, GCC, Clang, CUDA, and OFI)
* removed usage of non-standard C++17 variable length arrays
* fixed memory leaks in the runtime when using `CHPL_COMM=ofi` with AWS EFA
* fixed regex escape sequences generating errors with Python 3.12
* fixed some bugs with `CHPL_COMM=ugni` when using bundled LLVM and/or GPUs
* fixed a portability issue  in which the PGI compiler's name was misspelled

Compiler Improvements
---------------------
* updated `chpl` to support LLVM 18
* improved `--explain-call` output in the presence of return intent overloads

Compiler Flags
--------------
* removed the deprecated `--llvm` flag in favor of `--target-compiler=llvm`

Generated Executable Flags
--------------------------
* added a new `--gpus-per-node` flag for SLURM-based launchers

Error Messages / Semantic Checks
--------------------------------
* improved errors when modifying `const` shadow variables in nested `forall`s
* added an error message for calling `export proc`s with wrong number of args
* improved error message for improper uses of `_`, the 'throwaway' variable
* added an error when using `var` intents with `foreach` loops
* added warnings for copy-initing maps/sets/lists with mismatched `parSafe`s  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Map.html#Map.warnForMapParsafeMismatch,  
       https://chapel-lang.org/docs/2.1/modules/standard/Set.html#Set.warnForSetParsafeMismatch,  
   and https://chapel-lang.org/docs/2.1/modules/standard/List.html#List.warnForListParsafeMismatch)

Launchers
---------
* updated the `pbs-gasnetrun_ibv` launcher to request exclusive access to nodes

Runtime Library Changes
-----------------------
* updated runtime to use the GASNet-EX API by default for `CHPL_COMM=gasnet`
* enabled GASNet's `hwloc` support, using the same copy of `hwloc` as Chapel
* added support for transparent huge pages with OFI  
  (see https://chapel-lang.org/docs/2.1/platforms/libfabric.html#transparent-hugepages)
* ensured that co-locales respect `CHPL_RT_MAX_HEAP_SIZE`  
  (see https://chapel-lang.org/docs/2.1/platforms/libfabric.html#memory-registration-and-the-heap)
* added the ability to enable shared-memory bypass when using 'gasnet/ibv'
* added the ability to use a dedicated core for progress threads with 'gasnet'
* added the ability to enable a blocking send thread for `gasnet/ibv`

Bug Fixes
---------
* fixed a bug with error-handling and reductions within `forall` loops
* fixed calling throwing functions from square-bracket loop expressions
* fixed an erroneous error message with certain uses of parenless procs
* fixed 'symbol not found' errors when checking imports due to module order
* fixed a bug in the LLVM back-end for `export` procedures with `in` intents
* fixed a bug where `export` declarations could hit 'missing `override`' errors
* fixed bad applications of `pragma "llvm readnone"` in new versions of LLVM

Bug Fixes for Build Issues
--------------------------
* fixed `--print-chpl-settings`/`printchplenv` inconsistency in prefix installs
* fixed an error when compiling `chpl` with GCC 13 when using LLVM <= 14

Bug Fixes for GPU Computing
---------------------------
* fixed the error message for using `CHPL_TASKS=fifo` with GPU support
* fixed errors concerning rank-change array views on GPU memory
* improved error messages for `gpuSort()` when called from the wrong locale  
  (see https://chapel-lang.org/docs/2.1/modules/standard/GPU.html#GPU.gpuSort)

Bug Fixes for Libraries
-----------------------
* fixed behavior of the `advanceThrough()` and `advanceTo()` methods on EOF  
  (see https://chapel-lang.org/docs/2.1/modules/standard/IO.html#IO.fileReader.advanceThrough)
* fixed `advanceThrough()` to throw when a single-byte pattern was not found  
  (see https://chapel-lang.org/docs/2.1/modules/standard/IO.html#IO.fileReader.advanceThrough)
* fixed a problem where `atEOF()` / `assertEOF()` would consume whitespace  
* fixed several problems in the 'Regex' module:
  - fixed a bug where regular expressions defaulted to 'longest-match' mode
  - fixed the behavior of `replace()` when the pattern matches the empty string
  - fixed the `nonGreedy` and `multiLine` initializer arguments
* fixed `fillRandom()` to allow type coercion for `min`/`max` arguments  
  (see https://chapel-lang.org/docs/2.1/modules/standard/Random.html#Random.fillRandom)
* removed erroneously emitted unstable warnings for `[map|set].parSafe`
* fixed an off-by-one error in the 'Zarr' IO module's chunk index calculations

Bug Fixes for Tools
-------------------
* enabled `chplcheck` and `chpl-language-server` to be built w/out `CHPL_HOME`
* fixed various visual bugs and crashes in `chpl-language-server`
* fixed `chapel-py` failing to build with some compilers
* fixed the `chapel-py` build config to not warn with `CHPL_LLVM=none`
* prevented `chpl-shim` from overwriting files when not necessary
* fixed a bug in the Mason registry's CI that prevented using sub-modules  
  (see https://chapel-lang.org/docs/2.1/tools/mason/guide/buildinglargerpackages.html)
* added `--refresh-licenses` flag to `mason publish` to update license names 
* updated `mason`'s source of valid license names to use the latest SPDX repo

Bug Fixes for the Runtime
-------------------------
* fixed a bug where `-nl Mx1` did not set `CHPL_RT_LOCALES_PER_NODE` correctly
* fixed a bug where fencing was not done correctly when `CHPL_COMM=ofi`
* fixed a bug with respect to write-after-write ordering for `CHPL_COMM=ofi`
* fixed a bug in the binding of progress threads with `CHPL_COMM={ofi,gasnet}`
* set `CHPL_RT_COMM_OFI_INJECT_*` to false to avoid runtime hangs with AWS EFA

Third-Party Software Changes
----------------------------
* updated the bundled version of LLVM to 18.1.6
* updated the bundled copy of GASNet to version 2024.5.0
* updated the bundled version of libfabric/OFI to 1.21

Developer-oriented changes: Documentation
-----------------------------------------
* fixed some code examples in the 'All About Compiler-Generated Code' doc  
  (see https://chapel-lang.org/docs/2.1/developer/bestPractices/GeneratedCode.html#best-practices-generated-code)

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* added support for building Chapel with `CHPL_TARGET_JEMALLOC=system`
* added environment variables to always build `chapel-py` and language server
* added `clean-cmakecache` target to delete `CMakeCache.txt`

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* added support for tracking creation of LLVM `Value`s using `breakOnLLVMID`
* fixed `--llvm-print-ir-stage every` not working with old LLVM versions

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* improved the computation of module initialization order
* made numerous improvements to the 'dyno' resolver for types and calls:
  - added support for resolving if-variables as non-nilable classes
  - added support for compiler-generated initializers for basic generic types
  - added support for user-provided initializers for generic classes
  - added support for resolving `this.init()` calls from other `init` methods
  - added support for initializers on inheriting, non-generic classes
  - added support for `init=` from types other than the one that was declared
  - added support for initializing a nilable class from a `new` non-nilable one
  - added support for module-qualified function calls like `M.f()`
  - added support for overloaded parenless procs with `where` clauses
  - added support for passing `param` strings to `c_ptrConst(c_char)`
  - added support for `none` `param` value
  - added support for the 'get svec member [value]' primitives
  - improved support for initializers for generic types with defaults
  - improved support for where-clauses on generic methods
  - improved resolution of range literals
  - improved resolution of multi-decl and tuple-decl variables at module scope
  - improved resolution of tuple-grouped arguments
  - improved error messages for compile-time out-of-bounds errors on tuples
  - fixed the resolution of chained method calls in the form `a.b().c()`
  - fixed a bug in resolving types in multi-decl field declarations
  - fixed resolution of methods declared on `extern` types
  - fixed a bug where variables passed to `in` intents were considered 'dead'
  - fixed a bug in `param` coercion when passing to arguments
  - fixed crash when casting `param`s to non-`param` types
  - fixed a bug where unpacked tuple assignment caused false constness errors
  - fixed a bug disambiguating between `unmanaged` and `borrowed` formals
  - fixed a resolver crash due to circular forwarding statements
* improved performance when using `--dyno-scope-bundled`
* fixed how 'dyno' prints booleans to match the production compiler

Developer-oriented changes: Testing System
------------------------------------------
* added flags to optionally test blog articles' code using the `nightly` script
* extended 'skipif' files to support logging output
* fixed issue with `sub_test` not suppressing perf test timeouts
* removed single `-hello` option from `nightly` script

Developer-oriented changes: Tool Improvements
---------------------------------------------
* improved `chapel-py` scope resolution results for `use`s/`import`s

Developer-oriented changes: Utilities
-------------------------------------
* added support for building Chapel packages for multiple Linux distributions
* removed Python2 support from `compileline.py`


version 2.0.1
=============

released April 25, 2024

This version is an update to the 2.0 release to address a portability
bug when using GASNet on InfiniBand systems with LLVM 16 or 17.


version 2.0
===========

released March 21, 2024

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* Chapel's core language and library features are now considered stable!
* added `chpl-language-server`, a new LSP-based tool for VSCode/vim/... users
* added new 'ParallelIO' & 'Zarr' package modules and reworked 'DistributedBag'
* significantly improved the behavior and interfaces of the 'Random' module
* dramatically improved co-locale support (running multiple locales per node)
* improved GPU support via new attributes, optimizations, and portability
* significantly improved default `sort()` performance for large local arrays
* added support for `foreach` expressions and better default `foreach` intents
* extended `chplcheck` to support user-defined lint rules
* updated `chpl` to support LLVM 17 & use a new compiler-driver mode by default
* improved portability, particularly w.r.t. AMD GPUs and WSL
* removed a large number of deprecated library/language features for 2.0
* made many other user-motivated improvements w.r.t. bugs, docs, and features

Syntactic / Naming Changes
--------------------------
* disabled chained comparison operations without parentheses, like `a < b < c`
* added a warning when passing generic types to routines without using `(?)`  
  (e.g., `f(G)` should be written as `f(G(?))` if `G` is a generic type)  
  (see https://chapel-lang.org/docs/2.0/language/spec/generics.html#marking-generic-types)

New Language Features
---------------------
* added support for `foreach` expressions
* added prototype support for local variables that persist across invocations  
  (see https://chapel-lang.org/docs/2.0/technotes/static.html)

Language Feature Improvements
-----------------------------
* associative domains are now stable when using the default of `parSafe=false`
* added support for `borrowed` class expressions to be cast to `unmanaged`
* added support for bitwidth queries in tuple formals  
  (e.g., `proc foo(x: (int, int(?w))) { ... }` is now supported)
* added support for using detupled formal components in where clauses  
  (e.g., `proc foo((x, y), z) where x.type == int { ... }` is now supported)
* added support for formal array arguments with generic element types  
  (e.g., `proc foo(x: [] integral) { ... }  foo([1, 2, 3, 4];` now works))

Semantic Changes / Changes to the Language Definition
-----------------------------------------------------
* changed arrays' default task intent to be based on the array's `const`-ness  
  (see https://chapel-lang.org/docs/2.0/language/spec/data-parallelism.html#forall-intents)
* changed associative domains to be `parSafe=false` by default  
  (see https://chapel-lang.org/docs/2.0/language/spec/domains.html#parallel-safety-with-respect-to-domains-and-arrays)
* aligned default task intents on `foreach` loops to match `forall` loops
* enabled implicit `param` conversions when passing to `const ref` formals  
  (e.g., `proc f(const ref arg: int(8))` can now be called with `f(1)`)  
  (see https://chapel-lang.org/docs/2.0/language/spec/conversions.html#implicit-conversions-for-function-calls)
* disallowed assignment between unbounded ranges of incompatible index types
* slicing with a negative-stride range now reverses the first operand's dir  
  (see https://chapel-lang.org/docs/2.0/language/spec/ranges.html#range-slicing)
* iterators with no reachable `yield`s must now declare the type they yield
* `otherwise` blocks must now be the last case in their `select` statements  
  (see https://chapel-lang.org/docs/2.0/language/spec/statements.html#the-select-statement)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* `serial` statements are now considered unstable  
  (see https://chapel-lang.org/docs/2.0/language/spec/task-parallelism-and-synchronization.html#serial)
* marked `local` blocks as unstable
* implicitly converting an 8-/16-bit `int`/`uint` to `real(32)` is now unstable
* removed the deprecated support for casting any expression to a string
* removed the deprecated `owned.borrow()` type method
* removed the deprecated `BoundedRangeType` enum
* removed the deprecated `.intIdxType` query on arrays, domains, and ranges
* removed the deprecated `isBoundedRange()` and `ident()` range queries
* removed other deprecated methods and properties on ranges and domains  
  (e.g., `.stridable`, `.boundedType`, `.safeCast()`, `.boundsCheck()`, etc.)
* removed the `useNewArrayFind` config param used to update `.find()` calls

New Standard Library Features
-----------------------------
* added new routines for reading from a `string`/`bytes` like it was a file  
  (see https://chapel-lang.org/docs/2.0/modules/standard/IO.html#IO.openStringReader)
* added a new `getFile()` method to 'IO's `fileReader`/`fileWriter` types  
  (see https://chapel-lang.org/docs/2.0/modules/standard/IO.html#IO.fileReader.getFile)
* added support for initializing a `list` of `list`s from an array of arrays
* `abs()` and `sqrt()` taking `param`s now return a `param` in more cases  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Math.html#Math.sqrt  
   and https://chapel-lang.org/docs/2.0/modules/standard/Math.html#Math.abs)
* added support for comparing `c_fn_ptr` values against `nil`
* added unstable methods to append numeric values to a `bytes`/`string`  
  (see https://chapel-lang.org/docs/2.0/language/spec/bytes.html#Bytes.bytes.appendByteValues  
   and https://chapel-lang.org/docs/2.0/language/spec/strings.html#String.string.appendCodepointValues)
* added an unstable method to compute the hexadecimal encoding of a `bytes`  
  (see https://chapel-lang.org/docs/2.0/language/spec/bytes.html#Bytes.bytes.toHexadecimal)

New Package Module Features
---------------------------
* added a new 'ParallelIO' module with routines for reading files in parallel  
  (see https://chapel-lang.org/docs/2.0/modules/packages/ParallelIO.html)
* reworked the `DistributedBag` package w.r.t. depth-first-search and quality  
  (see https://chapel-lang.org/docs/2.0/modules/packages/DistributedBag.html)
* added a new prototype distributed 'Zarr' I/O module  
  (see https://chapel-lang.org/docs/2.0/modules/packages/Zarr.html)
* improved the performance of `toHex()` routines in the 'Crypto' package

Changes / Feature Improvements in Libraries
-------------------------------------------
* improved the uniqueness of default seeds generated by the 'Random' module  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#seed-generation)
* `LinearAlgebra.solve()` no longer modifies its actual arguments
* added the missing deserializer for the `bigint` type  
  (see https://chapel-lang.org/docs/2.0/modules/standard/BigInteger.html#BigInteger.bigint.deserialize)

Name Changes in Libraries
-------------------------
* replaced `randomStream.permutation()` with an improved `permute()` method  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#Random.randomStream.permute)
* replaced `randomStream.choice()` with improved `choose()`/`sample()` calls  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#Random.randomStream.choose)
* renamed `randomStream.getNext()` to `next()`  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#Random.randomStream.next)
* renamed `randomStream.iterate()` to a new overload of `next()`  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#Random.randomStream.next)
* replaced `randomStream.skipToNth()` with an improved `skipTo()`  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#Random.randomStream.skipTo)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* deprecated default `true` value for `locking` arg in `openReader|Writer()`  
  (see https://chapel-lang.org/docs/2.0/modules/standard/IO.html#IO.OpenReaderLockingDefault  
   and https://chapel-lang.org/docs/2.0/modules/standard/IO.html#IO.OpenWriterLockingDefault)
* deprecated default value for `locking` argument in `file.reader|writer()`  
  (see https://chapel-lang.org/docs/2.0/modules/standard/IO.html#IO.file.reader  
   and https://chapel-lang.org/docs/2.0/modules/standard/IO.html#IO.file.writer)
* deprecated `randomStream.getNth()` in favor of `skipTo()` then `next()`  
  (see https://chapel-lang.org/docs/2.0/modules/standard/Random.html#Random.randomStream.getNth)
* unstabilized `imag` overloads of trigonometric/hyperbolic 'Math' functions
* removed the vast majority of deprecated features in the 'IO' module
* removed all previously deprecated features from the 'FormattedIO' module
* removed the unstable `imag` overloads of the `fma()` procedure
* removed the remaining deprecated routines/constants from the 'Math' module  
  (e.g., `carg()`, `conjg()`, `divceil()`, `log2_e`, `half_pi`, etc.)
* removed the previously deprecated `BitOps.popcount()` function
* removed all previously deprecated `BigInteger` functions and configs
* removed some of the previously deprecated `Time` types  
  (e.g., `datetime`, `timedelta`, `Timer`, `TZInfo`, `TimeUnits`, etc.)
* removed some of the previously deprecated `Time.date[time]` methods
* removed the previously deprecated `Time.getCurrentTime()` function
* removed all previously deprecated `FileSystem` functions

GPU Computing
-------------
* replaced `setBlockSize` with a new `@gpu.blockSize` loop attribute
* added support for `@assertOnGpu` and `@gpu.blockSize` on variable decls
* improved GPU sorting routines w.r.t. performance and supported types  
  (see https://chapel-lang.org/docs/2.0/modules/standard/GPU.html#GPU.gpuSort)
* improved the compiler to print traces of call chains that thwart GPUization
* enabled using ROCm's LLVM using `CHPL_LLVM=system` and `CHPL_GPU=amd`  
  (see https://chapel-lang.org/docs/2.0/technotes/gpu.html#requirements)
* eliminated unnecessary synchronization for reductions on AMD GPUs
* improved the error generated when using `setBlockSize` improperly
* the 'GPU' module is no longer compiled in non-GPU configurations

Performance Optimizations / Improvements
----------------------------------------
* significantly improved `Sort.sort()` performance for large problem sizes
* eliminated extraneous array copies in initializers caused by domain queries
* improved codegen for `sqrt()` and `abs()` to directly map to LLVM intrinsics
* adjusted the LLVM optimizer to assume math functions don't set C's `errno`
* optimized the computation of `min()` and `max()` on `real(*)` values

Improvements to Compilation Times / Generated Code
--------------------------------------------------
* reduced `chpl`'s memory usage for large programs via the compiler driver  
  (see https://chapel-lang.org/docs/2.0/technotes/driver.html)

Tool Improvements
-----------------
* added `chpl-language-server`, a language server implementation for Chapel  
  (see https://chapel-lang.org/docs/2.0/tools/chpl-language-server/chpl-language-server.html)
* added support for user-defined lint rules in `chplcheck`  
  (see https://chapel-lang.org/docs/2.0/tools/chplcheck/chplcheck.html)
* improved how locations are reported by tools making use of the `chpl` parser
* added `printchplenv --bash/--csh` flags to to print shell-compatible output
* improved rendering of `chplcheck` lint rules in editors
* improved rendering of return intents by `chpldoc` for some browsers
* fixed cross-references for nested types within `chpldoc`

Documentation Improvements
--------------------------
* updated platform documentation for AWS to reflect current best practices  
  (see https://chapel-lang.org/docs/2.0/platforms/aws.html)
* added a new platform page for Windows, covering WSL (preferred) and Cygwin  
  (see https://chapel-lang.org/docs/2.0/platforms/windows.html)
* improved InfiniBand documentation for clarity and to mention `pmi` launches  
  (see https://chapel-lang.org/docs/2.0/platforms/infiniband.html)
* refreshed documentation concerning troubleshooting GASNet runs  
  (see https://chapel-lang.org/docs/2.0/usingchapel/multilocale.html#troubleshooting)
* generally updated the documentation for the 'IO' and 'FormattedIO' modules  
  (see https://chapel-lang.org/docs/2.0/modules/standard/IO.html  
   and https://chapel-lang.org/docs/2.0/modules/standard/IO/FormattedIO.html)
* merged 'ChapelIO' documentation into the 'IO' module's documentation  
  (see https://chapel-lang.org/docs/2.0/modules/standard/IO.html#automatically-available-symbols)
* clarified required conditions for split initialization and copy elision  
  (see https://chapel-lang.org/docs/2.0/language/spec/variables.html#split-initialization  
   and https://chapel-lang.org/docs/2.0/language/spec/variables.html#copy-elision)
* improved test system documentation with respect to running multiple trials  
  (see https://chapel-lang.org/docs/2.0/developer/bestPractices/TestSystem.html#running-multiple-times)
* improved documentation of enum constants to leverage new `chpldoc` features
* fixed up various typos and formatting or rendering issues

Example Codes
-------------
* updated examples to reflect:
  - no-longer-necessary `with`-clauses for parallel loops modifying arrays
  - changes to `parSafe` for associative domains and locking behavior for IO
  - changes to the 'Random' module's interface

Configuration / Build / Packaging Changes
-----------------------------------------
* updated Chapel prereqs to match LLVM 17, requiring CMake 3.20 and C++ 17  
  (see https://chapel-lang.org/docs/2.0/usingchapel/prereqs.html)
* when building the compiler with gcc, version 7.4 or later is now required  
  (see https://chapel-lang.org/docs/2.0/usingchapel/prereqs.html)
* `chpldoc` now requires Python versions after 3.7
* refreshed the sample installation commands in the prerequisites docs  
  (see https://chapel-lang.org/docs/2.0/usingchapel/prereqs.html#installation)
* made `make install` install `chapel-py`, `chplcheck`, `chpl-language-server`
* added `chapel-py`, `chplcheck`, `chpl-language-server` to the Docker image
* reduced the Docker image size by eliminating unnecessary files/directories
* disallowed building `chpl` with AMD GPU support when using the bundled LLVM
* fixed a bug causing `chpldoc` to always be built by `make install`

Compiler Improvements
---------------------
* upgraded `chpl` to now support LLVM 17
* switched `chpl` to use its compiler driver mode by default  
  (see https://chapel-lang.org/docs/2.0/technotes/driver.html)

Compiler Flags
--------------
* added new flags to request warnings for implicit numeric conversions  
  (see https://chapel-lang.org/docs/2.0/usingchapel/man.html starting from `--[no-]warn-int-to-uint`)
* added a new off-by-default warning for potential race conditions  
  (see `--warn-potential-races` in https://chapel-lang.org/docs/2.0/usingchapel/man.html)

Generated Executable Flags
--------------------------
* added `-nl` suffixes to bind co-locales to specific architectural feature  
  (e.g., `-nl 8x2s` says to run 2 locales on each of 8 nodes, one per socket)  
  (see https://chapel-lang.org/docs/2.0/usingchapel/multilocale.html#co-locales)

Runtime Library Changes
-----------------------
* added co-locale support to the `gasnet/smp` configuration
* added support for generalized co-locales that are not bound to a socket  
  (see https://chapel-lang.org/docs/2.0/usingchapel/multilocale.html#co-locales)
* added co-locale support for NICs that are not in a socket

Portability / Platform-specific Improvements
--------------------------------------------
* added support for generating debug symbols on Mac OS X with the LLVM back-end
* improved performance/correctness of remote mem ops for `ofi` on HPE Cray EX
* improved support for SS11 authentication on HPE Cray EX
* improved error-checking logic when `libfabric` is missing
* worked around runtime hangs during teardown when using `libfabric` with `EFA`
* updated detection of `lld` for AMD GPUs with the spack `llvm-amdgpu` package
* updated `chplenv` scripts to detect Windows Subsystem for Linux (WSL)
* updated `chplenv` scripts to support and locate CUDA libraries in WSL
* addressed a problem building Chapel on Alpine linux

Error Messages / Semantic Checks
--------------------------------
* added a dynamic check that default-intent args aren't indirectly modified  
  (enable using `--const-arg-checks` or `--warn-unstable` without `--fast`)
* disabled warnings about implicit modules for main modules
* improved error messages when a `record` is `const` due to shadow variables
* added an error message for invalid assignments from tuples to domains
* improved locations reported by the compiler's detailed error messages
* made clang detection of bad `--ccflags` arguments terminate compilation

Bug Fixes
---------
* fixed a bug converting tuples to complexes, e.g. when containing `inf`
* fixed a bug where `continue`s within `forall` loops read uninitialized memory
* fixed a bug where a loop in an `if` expression did not promote to an array
* fixed a bug that caused array type sub-expressions to be compiled into loops
* fixed a bug where using class variables in `coforall` crashed compilation
* fixed a bug where a type with no default initializer would halt compilation
* fixed a bug where mentions of `chpl_external_array` crashed compilation
* fixed a bug where nested functions passed as call actuals crashed compilation
* fixed a bug preventing implementing interfaces for generic class types
* fixed a bug in which compiler-generated code would warn about lack of `(?)`

Bug Fixes for Build Issues
--------------------------
* fixed issue with detecting `CHPL_HOME` in prefix-based installs
* fixed a bug in which the `c2chapel` virtual environment was incorrectly built
* fixed unrecognized key bug for `CHPL_GPU_MEM_STRATEGY` in `chplconfig` files

Bug Fixes for Libraries
-----------------------
* fixed a bug that incorrectly copied a `c_array` when casting to `c_ptr`
* fixed a string localization bug in `read[To|Through|Line]()`
* fixed a crash when calling `.seek()` on a remote `fileReader`/`fileWriter`

Bug Fixes for Tools
-------------------
* fixed a bug that caused `c2chapel` to mishandle forward-declared structs
* fixed a path parsing issue in `printchplbuilds.py`

Bug Fixes for the Runtime
-------------------------
* fixed useable core determination when some PUs are inaccessible
* fixed environment variable parsing for some runtime variables

Third-Party Software Changes
----------------------------
* updated the bundled copy of LLVM to version 17.0.6
* updated the Python package versions used by `chpldoc`  
  (see `$CHPL_HOME/third-party/chpl-venv/chpldoc-requirements*.txt` for details)

Developer-oriented changes: Documentation
-----------------------------------------
* updated some out-of-date details in `frontend/lib/parser/README`
* made clarifications to the driver mode technical note  
  (see https://chapel-lang.org/docs/2.0/technotes/driver.html)
* added a note about using an older valgrind with newer LLVM versions  
  (see https://chapel-lang.org/docs/2.0/developer/bestPractices/Valgrind.html#llvm-compatibility)
* added a note about debugging LLVM passes
* removed the Docker packaging README in favor of Chapel's Dockerhub page  
  (see https://hub.docker.com/r/chapel/chapel/)

Developer-oriented changes: Module changes
------------------------------------------
* applied missing `(?)` expressions on generic formals in the 'Version' module

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* fixed an issue preventing developer builds with `clang` versions prior to 16

Developer-oriented changes: Compiler Flags
------------------------------------------
* made `--compiler-driver` the default and added `--no-compiler-driver`  
  (see https://chapel-lang.org/docs/2.0/technotes/driver.html)
* added a new developer flag, `--llvm-print-passes`  
  (see https://chapel-lang.org/docs/2.0/technotes/llvm.html#inspecting-individual-llvm-passes)
* added more options for the `--llvm-print-ir-stage` flag
* added `--no-return-by-ref` to avoid returning by reference in generated C
* `--print-additional-errors` now also shows some speculative errors
* `--iterator-contexts` enables an early prototype of iterator contexts  
  (see https://github.com/chapel-lang/chapel/pull/24488)
* `--report-context-adjustments` prints debugging output for iterator contexts

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* improved support for `with` clauses on `foreach` loops
* fixed a number of bugs with the compiler driver mode

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* significantly improved the compiler front-end library's Python bindings
  - added the remaining AST accessors
  - improved portability to older Python versions
  - removed the need for the `chapel.core` module
  - added a `clean` build target
* made numerous improvements to the 'dyno' resolver for types and calls:
  - implemented type resolution of module-level split-initialized variables
  - implemented `is [const] copyable` and `is [const] assignable` primitives
  - implemented `pragma "last resort"` function resolution logic
  - added support for explicitly casting params
  - added support for param-folding `select`s w.r.t. copy elision & split-init
  - added support for resolving calls to the `this` method of a field
  - added support for casting between enums and other types
  - added support for converting from a C pointer to a const C pointer
  - added support for the built-in `_ptrConst` type
  - improved default initialization of generics
  - improved support for `borrowed` and `unmanaged` classes
  - improved support for interaction between variable arguments and tuples
  - implemented numerous compiler primitives
  - made calling `.type` on a type emit an error
  - added detection of infinite recursions during resolution, printing an error
  - eliminated incorrect error messages involving type queries
  - fixed resolution of `eltType` queries on the `c_ptr` type
  - fixed a bug in resolving user-defined initializers of `owned` classes
  - fixed a bug preventing formals with default values to implicitly convert
* improved the prototype support for library files:
  - added the ability to re-use LLVM IR stored in a library file
  - changed to using an ID-based munging strategy for library files
  - resolve all concrete functions when generating a library file

Developer-oriented changes: GPU support
---------------------------------------
* added an initial capability to use distributed arrays within GPU kernels
* improved kernel launch w.r.t. debuggability and to enable upcoming features

Developer-oriented changes: Platform-specific bug fixes
-------------------------------------------------------
* removed a developer assertion when an invalid `pragma` was used

Developer-oriented changes: Testing System
------------------------------------------
* added a CI check for undocumented stable standard library symbols
* updated the Python package versions used by `start_test`

Developer-oriented changes: Tool Improvements
---------------------------------------------
* improved 'chapel-py', the Python bindings to the compiler front-end library
  - added a 'visitor' API to implement more complicated AST traversals
  - exposed 'dyno's type resolution functionality
  - improved generated Python interface files for better editor integration

Developer-oriented changes: Utilities
-------------------------------------
* added a script to mass-update the copyright year of Chapel's source files


version 1.33.0
==============

released December 14, 2023

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* added a new `--detailed-errors` flag to opt-in to better compiler errors
* added support for co-locales to the `[slurm-]gasnetrun_*` launchers
* added a number of new command-line tools, including:
  - a prototype linter, 'chplcheck'
  - a script for summarizing unstable warnings
  - a script for reporting symbols that are missing documentation
* continued improving GPU support in terms of generality and library routines
* added a new prototype `breakpoint` procedure in support of debugging
* added support for system installations of LLVM 16 as the compiler backend
* refactored the features in the standard 'Random' module for stability
* generally refactored and improved support for binary I/O
* removed many deprecated language/library features to prep for Chapel 2.0

Syntactic / Naming Changes
--------------------------
* removed unstable paren-less `@attribute` syntax when arguments are present  
  (e.g., `@attribute "foo"` must now be written `@attribute("foo")`)

Language Feature Improvements
-----------------------------
* improved support for primitive type queries in formal array type expressions
* added support for declaring that unions fulfill a given interface  
  (e.g., `union u: i { ... }` says that `u` implements the `i` interface)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* marked `!=` between bounded and unbounded ranges of `bool` or `enum` unstable
* marked `range.strType` unstable
* removed support for single-statement `return` procedures without `do`
* removed support for allocating a class with `borrowed` memory management
* removed support for deprecated subtype comparison operators
* removed the deprecated `create[Bytes|String]With*Buffer()` routines

Namespace Changes
-----------------
* moved 'NPBRandom' from a submodule of 'Random' to a standalone package  
  (see https://chapel-lang.org/docs/1.33/modules/packages/NPBRandom.html#module-NPBRandom)

Standard Library Modules
------------------------
* added a new 'Debugger' module with an experimental `breakpoint` procedure  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Debugger.html)
* added a new `fma()` routine to the 'Math' module for fused multiply-adds  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Math.html#Math.fma)

Changes / Feature Improvements in Libraries
-------------------------------------------
* changed `binary(De)Serializer` to use less metadata for strings/classes  
  (see https://chapel-lang.org/docs/1.33/modules/standard/IO.html#IO.binarySerializer)
* changed `binaryDeserializer` to throw an error when reading strings/bytes  
  (see https://chapel-lang.org/docs/1.33/modules/standard/IO.html#IO.binaryDeserializer)
* added a flag to control whether large I/O operations bypass buffering  
  (see https://chapel-lang.org/docs/1.33/modules/standard/IO.html#IO.IOSkipBufferingForLargeOps)
* deprecated the `RandomStream` class in favor of a new `randomStream` record  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Random.html#Random.randomStream)

Name Changes in Libraries
-------------------------
* renamed the `IO.ioendian` enum to `IO.endianness`
* replaced `PCGRandomStream` with `randomStream`

Package Modules
---------------
* added a new 'ObjectSerialization' package supporting more structured I/O  
  (see https://chapel-lang.org/docs/1.33/modules/packages/ObjectSerialization.html)
* replaced `start`/`end` arguments in the 'URL' module with `region` args  
  (see https://chapel-lang.org/docs/1.33/modules/packages/URL.html#URL.openUrlReader)
* updated 'UnitTest' to report the filename & line number of failed assertions

Deprecated / Unstable Library Features
--------------------------------------
* deprecated and hid the transitional `CTypes.cPtrToLogicalValue` config param
* deprecated and hid the transitional `IO.fileOffsetWithoutLocking` config
* deprecated the symbols used to select RNG algorithms: `RNG`, `defaultRNG`  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Random.html#note-about-deprecations-and-future-work)
* deprecated `algorithm` args from `fillRandom()`, `shuffle()`, `permutation()`
* deprecated `createRandomStream()`
* deprecated `randomStreamInterface`  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Random.html#note-about-deprecations-and-future-work)
* deprecated the 'RandomSupport' module
* marked implicit seed creation in the 'Random' module as unstable  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Random.html#seed-generation)
* marked `permutation()` in the 'Random' package module as unstable

Removed Library Features
------------------------
* removed deprecated `sorted()`, `head()`, `tail()`, and `reverse()` on arrays
* removed deprecated `newBlock*()`, and `newCyclic*()` routines
* removed the deprecated old-behavior overloads for `c_ptrTo[Const]()`
* removed the deprecated `c_nil` type as well as `is_c_nil()` and `isAnyCPtr()`
* removed `c_FILE`'s deprecated behavior, in which `c_FILE` meant `FILE*`
* removed the deprecated `c_[malloc|calloc|aligned_alloc|free]()` routines
* removed the deprecated `c_[memmove|memcpy|memcmp|memset]()` routines
* removed the deprecated `file.lines()` method
* removed the deprecated bool-returning overloads of `fileReader.readBinary()`
* removed the deprecated `[read|write]Bytes()` methods accepting pointers
* removed the deprecated `fileReader.readstring()` method
* removed the deprecated `file[Reader|Writer].advancePastByte()` methods
* removed the deprecated `IO.[_mark|_revert|_commit|_offset]()` routines
* removed the previously deprecated locking behavior of `IO.offset()`
* removed the previously deprecated `BigInteger` methods  
  (i.e., `divexact()`, `pow[Mod]()`, `root[rem]()`, `sqrt[rem]()`,  
  `nextprime()`, `gcd()`, `lcm()`, `invert()`, `removeFactor()`, `fac()`,  
  `bin()`, `fib[2]()`, `lucnum[2]()`, `add[mul]()`, `sub[mul]()`,  
  `mul[_2exp]()`, `neg()`, `abs()`, `div[Q][R][2Exp]()`, `mod()`, `and()`,  
  `[i|x]or()`, `com()`)
* removed a few deprecated `list` methods: `append()`, `pop()`, `set()`
* removed the previously deprecated 'Memory' module and its sub-modules
* removed the previously deprecated `BitOps.popcount()` routine
* removed the previously deprecated 'Barriers' module
* removed the previously deprecated `Collectives.BarrierType` enum
* removed the previously deprecated reusable `barrier` type
* removed the previously deprecated `FileSystem.copyFile()` routine
* removed the previously deprecated `FileSystem.isLink()` routine
* removed the deprecated non-camel-case functions from 'FileSystem'

GPU Computing
-------------
* enabled GPU execution of promoted expressions in variable initializers
* added standalone procedures to support whole-array reductions  
  (see https://chapel-lang.org/docs/1.33/modules/standard/GPU.html#GPU.gpuSumReduce)
* added a standalone procedure for computing exclusive sum scans  
  (see https://chapel-lang.org/docs/1.33/modules/standard/GPU.html#GPU.gpuScan)
* added a procedure for sorting `uint`s on GPUs  
  (see https://chapel-lang.org/docs/1.33/modules/standard/GPU.html#GPU.gpuSort)
* squashed kernel launches when the number of threads is 0
* resolved deprecation warnings occurring with ROCm 5.2, 5.3, and 5.4

Performance Optimizations / Improvements
----------------------------------------
* optimized `[read|write]Binary()` when big/little endianness matches system's

Memory Improvements
-------------------
* fixed a memory leak in the GPU runtime

Tool Improvements
-----------------
* developed a prototype linter for Chapel code, 'chplcheck'  
  (see https://github.com/chapel-lang/chapel/tree/main/tools/chplcheck#readme)
* added a new script for summarizing a program's anonymized unstable warnings  
  (see https://chapel-lang.org/docs/1.33/tools/unstableWarningAnonymizer/unstableWarningAnonymizer.html)
* added a script to report symbols that are missing documentation  
  (see `tools/chpldoc/findUndocumentedSymbols`)
* updated 'chpldoc' to put unstable/deprecation warnings in clearer locations  
  (e.g., compare https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.ioMode.a  
   and https://chapel-lang.org/docs/1.33/modules/standard/IO.html#IO.ioMode.a)

Documentation Improvements
--------------------------
* merged the docs for the automatically-included math symbols into 'Math'  
  (see https://chapel-lang.org/docs/1.33/modules/standard/Math.html#automatically-available-symbols)
* improved the documentation with respect to profiling  
  (see https://chapel-lang.org/docs/1.33/usingchapel/building.html#makefile-options  
   and https://chapel-lang.org/docs/1.33/developer/bestPractices/GeneratedCode.html#profiling-the-generated-code)
* updated 'mason' docs and example to show required use of `--` before `-M`  
  (see https://chapel-lang.org/docs/1.33/tools/mason/guide/buildinglargerpackages.html)
* added missing documentation for symbols in stable standard modules

Example Codes
-------------
* removed LCALS & PTRANS from the benchmarks directory due to lack of attention
* updated example codes with respect to changes in the language and libraries

Syntax Highlighting
-------------------
* added missing keywords to the syntax highlighter for 'vim'

Configuration / Build / Packaging Changes
-----------------------------------------
* made `make install` create the installation directory rather than `configure`
* refreshed the sample installation commands in the prerequisites docs  
  (see https://chapel-lang.org/docs/1.33/usingchapel/prereqs.html#installation)

Portability / Platform-specific Improvements
--------------------------------------------
* added support for system installations of LLVM 16  
  (see https://chapel-lang.org/docs/1.33/usingchapel/prereqs.html)
* addressed a problem building the compiler on recent versions of FreeBSD

Compiler Improvements
---------------------
* started ignoring `when` blocks known to be false when inferring return types

Compiler Flags
--------------
* added `--[no-]detailed-errors` to request error messages with more detail  
  (see https://chapel-lang.org/docs/1.33/usingchapel/man.html)
* added `--[no-]const-arg-checks` to check for potential `const` violations  
  (see https://chapel-lang.org/docs/1.33/usingchapel/man.html)
* renamed the `CHPL_NO_*` env vars to make their behavior more predictable  
  (e.g. `CHPL_NO_CHECKS` is deprecated in favor of `CHPL_CHECKS`)  
  (see `chpl --help-env` for environment variable names)

Launchers
---------
* added co-locale support to `slurm-gasnetrun_*` and `gasnetrun_*` launchers

Error Messages / Semantic Checks
--------------------------------
* added an error when two files define a top-level module with the same name
* added an error for `ref` declarations with incorrect declared types
* added a warning for cases where symbol shadowing might be surprising  
  (e.g., if `M` and `N` both define `x`, `use M; public use N; f(x);` warns)
* added a compiler error when casting to a generic subclass in unsupported ways
* added an unstable warning when `const` arguments are indirectly modified  
  (see https://chapel-lang.org/docs/1.33/language/spec/procedures.html#the-const-intent)
* fixed the unstable warning for `gpuUseStreamPerTask` to use the correct name
* made code locations of `extern record` consistent with `record` in errors

Bug Fixes
---------
* fixed a bug with throwing within `forall` loops that span locales
* fixed a bug when initializing fields inside `try!` statements
* fixed a bug involving `try!` statements and arguments with default values
* added missing warnings for deprecated implicit conversions
* added missing warnings for deprecations in routines with default arguments
* added missing "ref if modified" warnings for arrays modified with a slice
* fixed an internal error when returning a generic type by `ref`
* fixed segmentation faults caused by incorrect uses of an empty `regex`  
* fixed a bug that caused certain nested functions to crash the compiler
* fixed a bug where type queries with the same name did not trigger an error
* fixed an internal error with attempting to optimize an undefined variable
* fixed an internal error in certain incorrectly-typed assignments

Bug Fixes for Build Issues
--------------------------
* fixed a bug where Python dependencies for 'chpldoc' might not get installed

Bug Fixes for GPU Computing
---------------------------
* made `forall` loops with reduce intents run on CPU to avoid incorrect results
* fixed a bug preventing passing `int(32)` values to `GPU.setBlockSize()`
* added warnings for some misuses of `CommDiagnostics` and `GpuDiagnostics`
* fixed crashes with `.localSubdomain()` on a multidimensional array
* fixed a bug in the "strided bulk transfer" optimization for array assignment
* fixed kernels within standard modules causing segfaults

Bug Fixes for Libraries
-----------------------
* fixed `readBinary()` on arrays to return #elements rather than #bytes
* fixed `fileReader.readBinary(numeric)` to properly throw `UnexpectedEofError`
* fixed an I/O bug in which file reads could occur from an incorrect offset
* fixed calls to `[read|write]Binary()` on `stdin`/`stdout`/`stderr`
* fixed a bug when calling `[read|write]Binary()` on a 0-length array
* fixed a bug in which `LinearAlgebra.dot()` did not work on 2D array views
* fixed a bug in 'UnitTest' that caused a segfault with certain codes

Bug Fixes for Tools
-------------------
* fixed a bug in 'chpldoc' where uses of `code-block` would overflow
* improved the accuracy of the language server's 'go to declaration' message

Developer-oriented changes: Documentation
-----------------------------------------
* updated docs to describe additional features of the testing system  
  (see https://chapel-lang.org/docs/1.33/developer/bestPractices/TestSystem.html)

Developer-oriented changes: Syntactic / Naming Changes
------------------------------------------------------
* removed the deprecated `pragma "no doc"` 

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* removed duplicate link arguments for 'chpl' and compiled executables
* started parsing and stripping redundant `-std=c++14` from 'CMake' build flags

Developer-oriented changes: Compiler Flags
------------------------------------------
* updated developer `--dyno` flag to utilize dyno's type resolution
* added a warning for names passed to `--llvm-print-ir` that couldn't be found
* improved `--print-passes` output for the experimental driver mode

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* made bug fixes and performance improvements to the experimental driver mode
* fixed `--devel`  causing the parser to crash in the face of syntax errors
* fixed an issue where `--llvm-print-ir` printed the wrong function linkage
* fixed incorrectly-specified `AstTag` for `TypeQuery AstNode`

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* updated developer `--dyno` flag to utilize dyno's type/call resolution
* made numerous improvements to the 'dyno' resolver for types and calls:
  - added basic support for `atomic` types
  - improved resolution of methods on generic types
  - implemented numerous compiler primitives
  - improved errors reporting why a call is a bad match
  - updated resolver's disambiguation rules to more closely match production's
  - disallowed subtype coercions for `const ref` formals to match past behavior
* significantly improved the prototype support for library files:
  - reduced library file size
  - added the ability for library files to include LLVM IR
  - documented the library file format  
    (see https://chapel-lang.org/docs/1.33/developer/compiler-internals/file-format.html)
* improved the output format of `--detailed-errors`
* added a mechanism for associating additional locations with an AST node

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added a prototype GASNet-EX comm option (enabled w/ `CHPL_GASNET_VERSION=ex`)

Developer-oriented changes: Testing System
------------------------------------------
* made test system not run custom 'sub_test' scripts for `-performance` runs
* fixed a bug in which 'sub_test' could emit duplicate error messages

Developer-oriented changes: Tool Improvements
---------------------------------------------
* silenced a 'gdb' warning when using the `--gdb` flag on the compiler

Developer-oriented changes: Utilities
-------------------------------------
* added new Python bindings to the 'dyno' frontend library, `chapel-py`  
  (see https://github.com/chapel-lang/chapel/tree/main/tools/chapel-py#readme)


version 1.32.0
==============

released September 28, 2023

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* Chapel 1.32.0 is a release candidate for Chapel 2.0 — please send feedback!
* significantly improved overall GPU performance, features, and portability
* generally improved support for ARM64 in terms of performance and portability
* added support for co-locales on IB networks and added a new `-nl 8x2` format
* significantly improved the IO serialization framework and its instantiations
* improved the features and docs for 'IO, 'Math', 'Time', and 'BigInteger'
* improved the safety of special methods through reserved words and interfaces
* began unifying default intents for all non-synchronizing types to `const`
* added warnings to make uses of incomplete generic types clearer in the code
* converted all standard distributions to records, avoiding the need for `dmap`
* scrutinized range, domain, and array features as stable vs. unstable
* added initial support for array allocations that throw when out of memory
* made the handling of C pointer types more robust and uniform within Chapel
* added a new primer providing a deep-dive into Chapel's various loop forms

New Language Features
---------------------
* added explicit `out` return and yield intents  
  (see https://chapel-lang.org/docs/1.32/language/spec/procedures.html#the-out-return-intent  
   and https://chapel-lang.org/docs/1.32/language/spec/iterators.html#the-yield-statement)
* added a user-facing task yield mechanism, `currentTask.yieldExecution()`  
  (see https://chapel-lang.org/docs/1.32/language/spec/task-parallelism-and-synchronization.html#yielding-task-execution)
* added support for declaring that records/classes fulfill a given interface  
  (e.g., `record r: i { ... }` says that `r` implements the `i` interface;  
   see https://chapel-lang.org/docs/1.32/technotes/interfaces.html)
* added `range.tryCast()` to support throwing casts between range types  
  (see https://chapel-lang.org/docs/1.32/language/spec/ranges.html#ChapelRange.range.tryCast)
* added support for an array creation interface that throws if out of memory  
  (see https://chapel-lang.org/docs/1.32/language/spec/domains.html#ChapelDomain.tryCreateArray)
* added support for applying @attributes to loops

Language Feature Improvements
-----------------------------
* added support for slicing arrays with unaligned ranges  
  (e.g., `var A: [1..3] int = 1..3; writeln(A[..2 by 2]);` prints 1)
* casts between ranges now check the validity of the stride  
  (see https://chapel-lang.org/docs/1.32/language/spec/conversions.html#explicit-range-conversions)
* enabled assigning and initializing integral ranges from bool ranges  
  (e.g., `var r: range(int(8)) = false..true;` is now supported)
* added a compiler warning when range slicing might halt execution  
  (e.g., `var r1 = 1.. by 2, r2 = 2.. by 2; writeln(r1[r2]);`)
* improved handling of intents on array formals in extern functions
* added promoted casts from array-of-`T` to `T` without a cast from `T` to `T`
* added support for a new `bulkAddNoPreserveInds()` method to sparse domains  
  (see https://chapel-lang.org/docs/1.32/language/spec/domains.html#ChapelDomain.bulkAddNoPreserveInds)
* first-class procedures are now printed similarly to Chapel's syntax
* improved support for casts in formal argument type expressions
* added new routines to create multidimensional arrays from C pointers

Syntactic / Naming Changes
--------------------------
* deprecated support for `$` in identifiers  
  (e.g., `foo$` is deprecated)
* `these` is now reserved as a keyword for use as the default iterator method  
  (see https://chapel-lang.org/docs/1.32/language/spec/methods.html#the-these-method)
* reserved `init`, `postinit`, `deinit`, `super`, and `range` as keywords
* replaced `[this.]complete();` with `init this;` when defining initializers  
  (see https://chapel-lang.org/docs/1.32/language/spec/classes.html#limitations-on-instance-usage-in-initializers)
* renamed `range.aligned` to `range.isAligned()`  
  (see https://chapel-lang.org/docs/1.32/language/spec/ranges.html#ChapelRange.range.isAligned)
* renamed `domain.dist` to `domain.distribution`  
  (see https://chapel-lang.org/docs/1.32/language/spec/domains.html#ChapelDomain.distribution)
* added a warning when inheriting from a generic class if `(?)` is not used  
  (e.g., `class C: D` must now be written `class C: D(?)` for generic `D`)
* added warnings for non-fully-defaulted generic type constraints w/out `(?)`  
  (e.g., `var t: T;` should be written `var t: T(?);` if `T` is such a type)  
  (see https://chapel-lang.org/docs/1.32/language/spec/generics.html#marking-generic-types)
* added a warning for type signatures like `T()` if `T` is not fully defaulted
* added a warning for fields with generic class management to avoid confusion
* renamed context manager `[enter|leave]This()` to `[enter|exit]Context()`  
  (see https://chapel-lang.org/docs/1.32/language/spec/statements.html#the-manage-statement)
* renamed `sync` formals from `x: valType` to `val: valType`
* renamed `atomic` formals and formal types from `value: T` to `val: valType`

Semantic Changes / Changes to the Chapel Language
-------------------------------------------------
* began transitioning the default argument/task intent for arrays to `const`  
  (see https://chapel-lang.org/docs/1.32/language/spec/procedures.html#the-default-intent)
* began transitioning the default receiver intent for records to `const`  
* redefined the `const` intent to enable optimization opportunities
  - `const` allows implementation to choose `const ref` or `const in`
  - `const` asserts that the value will not be modified by other means
  - `const` for an array now asserts that the domain will not change  
  (see https://chapel-lang.org/docs/1.32/language/spec/procedures.html#the-const-intent)
* began changing the type of range literals with mixed-type `param` bounds  
  (e.g., `0..1:int(8)` is changing from `idxType=int(8)` to `int(64)`)
* added an error for addition/subtraction of multi-dim. domains and `[u]int`s  
  (e.g., `{1..2, 1..2} - 1` is now an error)
* built-in hashing now relies on the `hashable` interface  
  (see https://chapel-lang.org/docs/1.32/language/spec/records.html#hashing-a-record  
   and https://chapel-lang.org/docs/1.32/technotes/interfaces.html)
* context managers now rely on the `contextManager` interface  
  (see https://chapel-lang.org/docs/1.32/language/spec/statements.html#the-manage-statement  
   and https://chapel-lang.org/docs/1.32/technotes/interfaces.html)
* removed some capabilities from records with generic `var`/`const` fields  
  (e.g., `record R { var x; }` or `record S { var y: integral; }`)
  - variables of such types can no longer be default-initialized
  - type signatures w/ named arguments are no longer supported (`R(x=int)`)  
    (see https://chapel-lang.org/docs/1.32/language/spec/generics.html#fields-without-types)
* adjusted the deinit point for nested call expressions in `var`/`const` decls  
  (see https://chapel-lang.org/docs/1.32/language/spec/variables.html#deinit-points)
* a call that could refer to a method or a non-method is now an ambiguity  
  (see https://chapel-lang.org/docs/1.32/language/spec/procedures.html#determining-most-specific-functions)
* methods are no longer included in the more-visible disambiguation check  
  (see https://chapel-lang.org/docs/1.32/language/spec/procedures.html#determining-most-specific-functions)
* declaring a paren-less method with the same name as a field is now an error  
  (see https://chapel-lang.org/docs/1.32/language/spec/methods.html#methods-without-parentheses)
* numeric `param`s can now be passed to `const ref` formals  
  (e.g. given `proc f(const ref arg)`, `f(1)` is now supported)
* l-value checking now applies to nested call expressions returning arrays  
  (e.g., `modifyArray(returnsArray)` will now emit an l-value error)
* `return` statements following a `throw` or `halt()` are now ignored  
  (see https://chapel-lang.org/docs/1.32/language/spec/error-handling.html#throwing-errors  
   and https://chapel-lang.org/docs/1.32/modules/standard/Errors.html#Errors.halt)
* split initialization is now allowed into a `sync` block  
  (see https://chapel-lang.org/docs/1.32/language/spec/variables.html#split-initialization)

Unstable Language Features
--------------------------
* marked `foreach` loops unstable due to lack of shadowing and `with`-clauses
* marked associative and sparse domains as unstable
* marked the `dmap` type and `dmapped` keyword as unstable
* marked `scan` unstable due to uncertainty about inclusive/exclusive behavior
* made importing tertiary methods by naming their type unstable  
  (e.g., `import IO.string;` is no longer stable)
* marked the `[string|bytes].createBorrowingBuffer` factory method unstable  
  (see https://chapel-lang.org/docs/1.32/language/spec/strings.html#String.string.createBorrowingBuffer  
  and https://chapel-lang.org/docs/1.32/language/spec/bytes.html#Bytes.bytes.createBorrowingBuffer)
* marked `.localize()` on `string` and `bytes` as being unstable
* marked `compareAndSwap()` on `atomic` variables as unstable
* marked `sync.[readXX|writeFF|writeXF|reset|isFull]()` unstable
* marked `umask()` on `locale` as being unstable
* marked binary operators between tuples and scalars as unstable
* marked several binary operators over ranges and integral values as unstable  
  (e.g., `(1..3)*(1..5)` and `(1..3) + 1` are now unstable
* marked default initialization of partially bounded ranges as unstable  
  (see https://chapel-lang.org/docs/1.32/language/spec/ranges.html#default-values)
* marked first/last/empty queries on unbounded ranges of bool/enum unstable  
  (e.g., `(false..).last` is now unstable)
* marked `==` and `!=` between unbounded ranges of bool/enum unstable  
  (e.g., `(false..true) == (false..)` is now `true` and unstable)
* marked transformational methods on ranges and domains unstable  
  (e.g., `.translate()`, `.interior()`, `exterior()`, `.expand()`)
* marked `.orderToIndex()` on domains as unstable
* marked `.offset()` and `.indexOrder()` on ranges as unstable
* marked `.hasSingleLocalSubdomain()` and `.localSubdomains()` as unstable
* marked all `.safeCast()` methods unstable
* marked explicit calls to `this()` methods as unstable
* marked serial `these()` iterators taking arguments as unstable
* marked most built-in `config` constants and params as unstable
* marked `extern` procedures with array arguments as unstable  

Deprecated / Removed Language Features
--------------------------------------
* deprecated the `c_string` type in favor of `c_ptrConst(c_char)`  
  (see https://chapel-lang.org/docs/1.32/language/evolution.html#c-string-deprecation)
* deprecated implicit conversions for formals with generic numeric types  
  (e.g., given `proc f(r: real(?w)) {}`, `f(1)` will not compile in the future)
* deprecated `single` variables
* deprecated returning `sync`, `single`, or `atomic` by value
* deprecated relying on default initializers for `sync`, `single`, and `atomic`
* deprecated the `owned.borrow()` type method  
  (see https://chapel-lang.org/docs/1.32/language/spec/classes.html#OwnedObject.owned.borrow)
* deprecated assignment between unbounded ranges of incompatible `idxType`
* deprecated `range.isAmbiguous()` in favor of `!range.isAligned()`
* deprecated `range.isNaturallyAligned()` and `range.boundsCheck()`
* deprecated the `.intIdxType` query on ranges, domains, and arrays  
  (see https://chapel-lang.org/docs/1.32/language/spec/domains.html#ChapelDomain.intIdxType)
* deprecated the default cast from arrays to `string`
* deprecated `require` statements for Chapel source files at non-module scope  
  (see https://chapel-lang.org/docs/1.32/language/spec/statements.html#the-require-statement)
* deprecated the `useNewArrayFind` config param
* removed the previously deprecated casts from `string` and `bytes` to `regex`
* removed support for the deprecated array `.find()` overload
* removed support for variable-width `bool` types and related queries
* removed the `preserveInds` argument to `bulkAdd` on sparse domains  
  (see https://chapel-lang.org/docs/1.32/language/spec/domains.html#ChapelDomain.bulkAdd)

Namespace Changes
-----------------
* moved several automatically-included math symbols from 'AutoMath' to 'Math'  
  (e.g., `div[ceil|floor][pos]()`, `nearbyint()`, `rint()`)
* moved `string.c_str()` and `bytes.c_str()` to `CTypes`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/CTypes.html#CTypes.string.c_str)
* upgraded `Json` from a package to a standard module, now named `JSON`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/JSON.html)
* renamed the `Yaml` module to `YAML`  
  (see https://chapel-lang.org/docs/1.32/modules/packages/YAML.html)

Standard Library Modules
------------------------
* marked the 'Random', 'CommDiagnostics', and 'Communication' modules unstable
* added `binarySerializer` and `binaryDeserializer` types to the 'IO' module  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.binarySerializer  
   and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.binaryDeserializer)
* added new `%<`, `%^`, and `%>` format specifiers for justification  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO/FormattedIO.html#id1)
* added support for casting `bool` values to `bigint`  
* began an update to the definition of `dayOfWeek` to use ISO numbering  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.cIsoDayOfWeek)
* added `date.utcToday` as a UTC version of local-time `date.today`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.date.utcToday)
* added a `compiledForSingleLocale()` query to the 'ChplConfig' module  
  (see https://chapel-lang.org/docs/1.32/modules/standard/ChplConfig.html#ChplConfig.compiledForSingleLocale)

Package Modules
---------------
* marked all package modules as being unstable  
  (see https://chapel-lang.org/docs/1.32/modules/packages.html)
* added `isEye` and `isZero()` routines to the 'LinearAlgebra' package module  
  (see https://chapel-lang.org/docs/1.32/modules/packages/LinearAlgebra.html#LinearAlgebra.isEye  
   and https://chapel-lang.org/docs/1.32/modules/packages/LinearAlgebra.html#LinearAlgebra.isZero)

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* marked all domain maps other than `blockDist` and `cyclicDist` as unstable
* converted standard distributions into records, removing the need for `dmap`  
  (e.g., see https://chapel-lang.org/docs/1.32/modules/dists/BlockDist.html#BlockDist.blockDist)
* renamed the standard distributions to match their module names  
  (e.g., `Block` is now `blockDist`, `Cyclic` is now `cyclicDist`, etc.)  
  (e.g., see https://chapel-lang.org/docs/1.32/modules/dists/BlockDist.html#BlockDist.blockDist)
* unified and extended the factory methods on `[block|cyclic|stencil]Dist`  
  (see https://chapel-lang.org/docs/1.32/modules/dists/BlockDist.html#BlockDist.blockDist.createDomain,  
   https://chapel-lang.org/docs/1.32/modules/dists/CyclicDist.html#CyclicDist.cyclicDist.createDomain,  
  and https://chapel-lang.org/docs/1.32/modules/dists/StencilDist.html#StencilDist.stencilDist.createDomain)
* disallowed oversubscription in `cyclicDist` and `stencilDist`  
  (e.g., `var c = new cyclicDist(1, [here, here]);` now reports an error)
* marked advanced initializer arguments in `blockDist`/`cyclicDist` unstable  
  (see https://chapel-lang.org/docs/1.32/modules/dists/BlockDist.html#BlockDist.blockDist  
   and https://chapel-lang.org/docs/1.32/modules/dists/CyclicDist.html#CyclicDist.cyclicDist)

Changes / Feature Improvements in Libraries
-------------------------------------------
* significantly improved support for IO Serializers and Deserializers  
  (see https://chapel-lang.org/docs/1.32/technotes/ioSerializers.html)
* added overloads of deserializing methods that take arguments by `ref`  
  (see https://chapel-lang.org/docs/1.32/technotes/ioSerializers.html#the-user-facing-deserializer-api)
* `%i` and `%u` format specifiers now emit warnings for unused precision args  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO/FormattedIO.html#id1)
* generalized `[read|write]Binary()` to support multi-dimensional arrays  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.readBinary  
   and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileWriter.writeBinary)
* made `readLiteral()` and `matchLiteral()` respect leading whitespace  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.readLiteral  
   and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.matchLiteral)
* added `Math.ln()` to be consistent with the constant names in 'Math'  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.ln)
* limited `AutoMath.isClose()` to only accept `real`/`imag`/`complex` args  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.isClose)
* extended `Math.gcd()` support to include overloads for all integral types  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.gcd)
* indexing into a `map` with default-initializable values no longer `throws`  
  (e.g., `var m = new map(int, int); m[5] = 6;` will no longer throw errors)
* `map.values()` is now available for maps with non-nilable `owned` values  
  (e.g., `var m = new map(int, owned MyClass); for v in m.values() do ...`)

Name Changes in the 'Math' Library
----------------------------------
* unified the argument names in 'Math' module routines
* renamed `INFINITY` to `inf` and `NAN` to `nan`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.inf  
   and https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.nan)
* renamed `is[finite|inf|nan]()` to `is[Finite|Inf|Nan]()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.isFinite et al.)
* renamed `conjg()` to `conj()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.conj)
* renamed `carg()` to `phase()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.phase)
* renamed `cproj()` to `riemProj()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.riemProj)
* renamed `div[ceil|floor][pos]()` to `div[Ceil|Floor][Pos]()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.divCeil et al.)
* renamed `isclose()` to `isClose()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.isClose)
* renamed `tgamma()` to `gamma()` and `lgamma()` to `lnGamma()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.gamma  
   and https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.lnGamma)
* renamed `ldexp()` to `ldExp()` and its argument from `n` to `exp`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.ldExp)
* renamed `*_pi` constants to `*Pi` and marked them unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.halfPi et al.)
* renamed `sqrt_2` to `sqrt2` and `recipr_sqrt_2` to `reciprSqrt2`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.sqrt2)
* renamed `log2_e` to `log2E` and `log10_e` to `log10E`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.log2E)
* renamed `ln_2` to `ln2` and `ln_10` to `ln10`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.ln2)

Name Changes in the 'BigInteger' Library
----------------------------------------
* generally unified argument names in these routines to `x`, `y`, ...
* renamed the enum `round` to `roundingMode`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.roundingMode)
* renamed `[set|tst|com|clr]bit()` to `[set|get|toggle|clear]Bit()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.bigint.setBit)
* renamed `divQ()`/`divR()`/`divQR()` to `div()`/`rem()`/`divRem()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.divQ)
* renamed `divexact()` to `divExact()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.divExact)
* renamed `scan[0|1]()` to `findNext[0|1]()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.bigint.findNext0)
* renamed `popcount()` to `popCount()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.bigint.popCount)
* renamed `ior()` to `or()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.or)
* renamed `[root|sqrt]rem()` to `[root|sqrt]Rem()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.rootRem  
  and https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.sqrtRem)
* renamed `[add|sub]mul()` to `[add|sub]Mul()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.addMul  
  and https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.subMul)
* renamed `hamdist()` to the now unstable `hammingDistance()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.bigint.hammingDistance)
* renamed `nextprime()` to the now unstable `nextPrime()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.nextPrime)
* renamed `lucnum[2]()` to the now unstable `lucNum[2]()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.lucNum)
* renamed `mul_2exp()` to the now unstable `mul2Exp()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.mul2Exp)
* renamed `divQ2Exp()` to the now unstable `div2Exp()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.div2Exp)
* renamed `divR2Exp()` to the now unstable `rem2Exp()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html#BigInteger.rem2Exp)

Other Name Changes in Libraries
-------------------------------
* renamed the serializer/deserializer types to use camelCasing  
  (e.g., `DefaultSerializer` is now `defaultSerializer`)
* renamed `map.addOrSet()` to `map.addOrReplace()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Map.html#Map.map.addOrReplace)
* renamed `CodepointSplittingError` to `CodepointSplitError`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Errors.html#Errors.CodepointSplitError)
* renamed `date.isoCalendar()` to `isoWeekDate()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.date.isoWeekDate)
* replaced `abs(timeDelta)` with a method `timeDelta.abs()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.timeDelta.abs)

Deprecated / Unstable / Removed 'IO' Library Features
-----------------------------------------------------
* marked the default-included 'ChapelIO' module name as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/ChapelIO.html)
* marked `fileReader.assertEOF()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.assertEOF)
* deprecated `[read|write]This()` methods in favor of `[de]serialize()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/ChapelIO.html#the-serialize-and-deserialize-methods
* deprecated `fileReader.skipField()` in favor of (de)serializers  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO/FormattedIO.html#FormattedIO.fileReader.skipField)
* deprecated `iostyle` and `iokind` in favor of serializers and deserializers  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.iostyle  
   and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.iokind)
* deprecated `file[Reader|Writer].kind` in favor of (de)serializers
* deprecated the `kind` argument in various reader/writer routines  
  (e.g., `open[URL][Reader|Writer]()`, `file.[reader|writer]()`, etc.)
* deprecated `fileReader.binary` in favor of checks for binary [de]serializer  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.binary)
* deprecated `io[dynamic|native|little|big]` module-scope convenience params  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.iokind)
* deprecated `fileReader.ioLiteral` in favor `readLiteral()`/`matchLiteral()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.ioLiteral)
* deprecated `fileReader.ioNewline` in favor of `[read|match]Newline()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.ioNewline)
* deprecated the 'BinaryIO' module  
  (see https://chapel-lang.org/docs/1.32/modules/packages/BinaryIO.html)
* deprecated the `%t`, `%jt`, and `%ht` format specifiers in favor of `%?`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO/FormattedIO.html#general-conversions)
* deprecated the `%-` format specifier in favor of `%<`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO/FormattedIO.html#id1)
* deprecated usage of `iokind` in the `Subprocess` module
* deprecated a number of `config param`s in 'IO' used to transition behavior  
  (e.g., `useNewFileReaderRegionBounds`, `useNewLinesRegionBounds`, etc.)
* removed the deprecated `IO.open[Reader|tmp|fp|fd]()` routines
* removed the deprecated `file.reader()` and `.writer()` overloads
* removed the deprecated `file.check()` and `file.lines()` methods
* removed the deprecated `fileReader.flush()` method
* removed the deprecated `.seek()` method overloads on `file[Reader|Writer]`
* removed deprecated `%<` and `%>` format specifiers for designating endianness
* removed the deprecated overload of `file.path` that provided a relative path
* removed the deprecated `openMemFile()` and `[read|write]Bits()` procedures
* removed the deprecated `openreader()` and `openwriter()` procedures
* removed the deprecated types `iomode`, `ioBits`, and `ioChar`

Deprecated / Unstable / Removed 'Math' Library Features
-------------------------------------------------------
* marked the default-included 'AutoMath' module name as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html)
* marked `signbit()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.signbit)
* marked `nearbyint()` and `rint()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.nearbyint  
   and https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.rint)
* marked the `log*()` functions with `int` and `uint` arguments as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.log2)
* marked `logBasePow2()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.logBasePow2)
* marked `erf()` and `erfc()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.erf)
* marked the Bessel functions as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.j0 et al.)
* marked `divCeilPos()` and `divFloorPos()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.divCeilPos  
   and https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.divFloorPos)
* marked `[half|quarter|recipr|twiceRecipr[Sqrt]Pi` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.halfPi et al.)
* marked `sqrt2` and `reciprSqrt2` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.sqrt2  
   and https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.reciprSqrt2)
* removed the deprecated Bessel functions that were included by default

Deprecated / Unstable / Removed 'Time' Library Features
-------------------------------------------------------
* marked `Timezone` and any `Time` methods using it as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.Timezone)
* deprecated the `day` and `isoDayOfWeek` enums in favor of `dayOfWeek`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.day)
* deprecated `MINYEAR`/`MAXYEAR` in favor of `date.[min|max].year`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.MINYEAR)
* deprecated `getCurrentDate()` and `getCurrentDayOfWeek()` in 'Time'  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.getCurrentDate)
* marked the default 0-argument initializers for `date` and `dateTime` unstable
* deprecated `date.createFromTimestamp()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.date.createFromTimestamp)
* deprecated `{date,time,dateTime}.isoFormat()` in favor of casts to strings  
* deprecated `dateTime.combine()` in favor of using initializers  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.dateTime.combine  
   and https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.dateTime.init)
* deprecated `dateTime.{isoCalendar(), toOrdinal(), weekday(), isoWeekday()}`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Time.html#Time.dateTime.toOrdinal et al.)

Unstable Library Features
-------------------------
* marked `parSafe` as being unstable for `list`, `set`, and `map`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/List.html#List.list.parSafe,  
   https://chapel-lang.org/docs/1.32/modules/standard/Set.html#Set.set.parSafe,  
   and https://chapel-lang.org/docs/1.32/modules/standard/Map.html#Map.map.parSafe)
* marked several 'BigInteger' procedures as unstable  
  (i.e., `jacobi()`, `legendre()`, `kronecker()`, `gcd()`, `lcm()`, `fac()`,
   `bin()`, `fib()`, `fib2()`, `probablyPrime()`)
* marked `c_fn_ptr` unstable  
  (see https://chapel-lang.org/docs/1.32/technotes/extern.html#c-fn-ptr)
* marked `list.sort()` as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/List.html#List.list.sort)
* marked `Reflection.getRoutineName()` unstable within first-class procedures
* marked several other 'Reflection' routines as unstable
* marked all `CHPL_*` params in 'ChplConfig' as unstable  
  (see https://chapel-lang.org/docs/1.32/modules/standard/ChplConfig.html#ChplConfig.CHPL_HOME et al.)

Deprecated / Removed Library Features
-------------------------------------
* deprecated `c_void_ptr` in favor of now-equivalent `c_ptr(void)`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/CTypes.html#CTypes.c_ptr)
* deprecated casts from classes to `c_ptr(void)` in favor of `c_ptrTo()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/CTypes.html#CTypes.cPtrToLogicalValue)
* deprecated the transitional `BigInteger.bigintInitThrows` config param
* deprecated `BigInteger.get_str()` in favor of a cast to `string`  
* deprecated `list.first()`/`.last()` in favor of using paren-less methods  
  (see https://chapel-lang.org/docs/1.32/modules/standard/List.html#List.list.first  
   and https://chapel-lang.org/docs/1.32/modules/standard/List.html#List.list.last)
* deprecated `IllegalArgumentError`'s two-argument initializer
  (see https://chapel-lang.org/docs/1.32/modules/standard/Errors.html#Errors.IllegalArgumentError)
* deprecated `Reflection.numFields()` in favor of `Reflection.getNumFields()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Reflection.html#Reflection.getNumFields)
* removed the deprecated `BigInteger.Round` enum
* removed the deprecated `bigint` initializers that halted/returned error codes
* removed the deprecated `bigint.mpzStruct()` method
* removed the deprecated `bigint.fits_*()` methods
* removed the deprecated `bigint.div_q()` method
* removed the deprecated `bigint.powm()` method
* removed the deprecated `bigint.sizeinbase()` and `.size()` methods
* removed the deprecated `bigint.get_d_2exp()` method
* removed several deprecated procedures from 'BigInteger'  
  (i.e., `scan0())`, `scan1()`, `divexact()`, `qcdext()`, `probab_prime_p()`,
   `divisible_[2xp_]p()`, `congruent_[2exp_]p()`, `div_r()`, `div_qr()`,
   `div_[q|r]_2exp()`)
* removed deprecated `c_sizeof()` signature with formal name `x`
* removed a `regex.matches()` overload with deprecated arguments
* removed the deprecated `regex.compile()` type method
* removed the deprecated `regex.sub()` and `regex.subn()` methods
* removed the deprecated `[list|unrolledLinkedList].extend()` methods
* removed the deprecated 'Sys' module
* removed the deprecated 'OrderedSet' and 'OrderedMap' package modules

GPU Computing
-------------
* significantly improved `array_on_device` performance, making it the default
* improved the performance of math routines in GPU kernels
* improved performance when using arrays within kernels
* added more math routines when using AMD GPUs
* added support for dumping AMD assembly files when using `--savec`  
  (see https://chapel-lang.org/docs/1.32/technotes/gpu.html#examining-generated-assembly)
* started using per-task, per-device streams to enable better overlap
* CUDA 12 is now supported when using `CHPL_LLVM=bundled`
* generated GPU kernels are now named using their source filename/line number
* added support for multi-arch GPU executables when targeting NVIDIA GPUs  
  (see https://chapel-lang.org/docs/1.32/technotes/gpu.html#vendor-portability)
* added an experimental `--gpu-specialization` optimization
* deprecated `assertOnGpu()` in favor of a new `@assertOnGpu` loop attribute  
  (see https://chapel-lang.org/docs/1.32/technotes/gpu.html#diagnostics-and-utilities)
* enabled bulk-transfer of Chapel arrays with `c_array` element type

Performance Optimizations / Improvements
----------------------------------------
* optimized aligned array swaps for `cyclicDist` and `stencilDist`

Platform-specific Performance Optimizations / Improvements
----------------------------------------------------------
* improved the performance of aggregators on HPE Cray EX systems
* improved task creation and switching performance on ARM processors

Compilation-Time / Generated Code Improvements
----------------------------------------------
* improved the preservation of paths in compiler-generated `#line` directives

Memory Improvements
-------------------
* fixed a sporadic memory leak in the 'Futures' package module

Tool Improvements
-----------------
* made `c2chapel` generate `c_ptr[Const]`s for multidimensional arrays
* `printchplenv` now prints `CHPL_GPU` by default when `CHPL_LOCALE_MODEL=gpu`
* made `printchplenv` error when using `CHPL_GPU=cpu` and `CHPL_TASKS=fifo`
* added `:enum[constant]:` to the list of `chpldoc`-supported inline markups  
  (see https://chapel-lang.org/docs/1.32/tools/chpldoc/chpldoc.html#inline-markup-2)

Language Specification Improvements
-----------------------------------
* documented the `require` statement  
  (see https://chapel-lang.org/docs/1.32/language/spec/statements.html#the-require-statement)
* simplified the explanation of default intents  
  (see https://chapel-lang.org/docs/1.32/language/spec/procedures.html#the-default-intent)
* updated the default intent of `owned`/`shared` to reflect that it's `const`  
  (see https://chapel-lang.org/docs/1.32/language/spec/classes.html#owned-default-intent  
  and https://chapel-lang.org/docs/1.32/language/spec/classes.html#shared-default-intent)
* described how uses of generic types can be decorated with `(?)`  
  (see https://chapel-lang.org/docs/1.32/language/spec/generics.html#marking-generic-types)
* added a section describing how fields can be declared with generic type  
  (see https://chapel-lang.org/docs/1.32/language/spec/generics.html#fields-with-generic-types)
* added a section describing generic types with defaults  
  (see https://chapel-lang.org/docs/1.32/language/spec/generics.html#fully-defaulted-generic-types)
* improved the description of how identifiers are interpreted in methods  
  (see https://chapel-lang.org/docs/1.32/language/spec/classes.html#field-accesses)
* reformatted the classes section to hide implementation details  
* added a link between the `%` documentation and `mod()`  
  (see https://chapel-lang.org/docs/1.32/language/spec/expressions.html#modulus-operators)
* added links to the types discussed in `string` and `bytes` documentation 

Documentation Improvements for the 'IO' Library
-----------------------------------------------
* added a new section about I/O transactions to the 'IO' module  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#i-o-transactions)
* improved the clarity of the documentation of `mark()`/`commit()`/`revert()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.mark  
   and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileWriter.mark)
* improved the clarity of the docs for `file[Reader|Writer].[advance|seek]()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.advance  
   and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.fileReader.seek)
* added a new section about `file[Reader|Writer]` regions to the 'IO' module  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#specifying-the-region-of-a-filereader-or-filewriter)
* added new section about `file[Reader|Writer]` locking to the 'IO' module  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#locking-behavior-of-filereaders-and-filewriters)
* removed references to file descriptors in `stdin`/`stdout`/`stderr` docs  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.stdin)
* refactored documentation for `IO.ioMode` and `IO.ioendian`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.ioMode  
  and https://chapel-lang.org/docs/1.32/modules/standard/IO.html#IO.ioendian)
* refactored `where` clauses to improve the generated documentation  

Documentation Improvements for the 'Math' Library
-------------------------------------------------
* added missing documentation for arguments of `isClose()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.isClose)
* removed an incorrect mention of "absolute value" for `tgamma()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.tgamma)
* improved the description for `ldExp()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.ldExp)
* fixed the documentation for `atan2()` with 32-bit arguments  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.atan2)
* extended the documentation for `erf()`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.erf)
* added a link between the `mod()` documentation and `%`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/AutoMath.html#AutoMath.mod)
* added a link between `exp()`/`expm1()` and `e`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.exp  
   and https://chapel-lang.org/docs/1.32/modules/standard/Math.html#Math.expm1)

Other Documentation Improvements
--------------------------------
* added a new primer providing a deep-dive into Chapel's various loop forms  
  (see https://chapel-lang.org/docs/1.32/primers/loops.html)
* made a major refresh to the distributions primer  
  (see https://chapel-lang.org/docs/1.32/primers/distributions.html)
* updated the first-class procedures technote to reflect the new syntax  
  (see https://chapel-lang.org/docs/1.32/technotes/firstClassProcedures.html)
* replaced uses of `dmapped` with factory methods throughout the docs  
  (e.g., see https://chapel-lang.org/docs/1.32/primers/distributions.html)
* simplified documentation of `c_ptrTo()` and related procedures' overloads  
  (see https://chapel-lang.org/docs/1.32/modules/standard/CTypes.html#CTypes.c_ptrTo)
* added a warning that the result of `.c_str()` may contain mid-buffer NULLs  
  (see https://chapel-lang.org/docs/1.32/modules/standard/CTypes.html#CTypes.string.c_str)
* refactored and expanded 'BigInteger' documentation to be more comprehensive  
  (see https://chapel-lang.org/docs/1.32/modules/standard/BigInteger.html)
* added a note that `chown()` requires elevated privileges to be successful
* refactored documentation for `DynamicIters.Method` and `Subprocess.pipeStyle`  
  (see https://chapel-lang.org/docs/1.32/modules/standard/DynamicIters.html#DynamicIters.Method  
  and https://chapel-lang.org/docs/1.32/modules/standard/Subprocess.html#Subprocess.pipeStyle)
* fixed warnings in 'Map' that incorrectly referred to the `set` type
* updated docs to mention `arm64` as a synonym for `aarch64`  
  (see https://chapel-lang.org/docs/1.32/usingchapel/chplenv.html#chpl-host-arch)

Example Codes
-------------
* updated sync primer to reflect stable methods and variable naming conventions  
  (see https://chapel-lang.org/docs/1.32/primers/syncs.html)
* moved `fft.chpl` and `hpl.chpl` out of the release example due to immaturity
* generally kept example codes up-to-date with respect to language changes

Generated Executable Flags
--------------------------
* added co-locale support to the `-nl`/`--numLocales` flag  
  (e.g., `-nl 4x2` means run on 4 nodes with 2 locales per node)  
  (see https://chapel-lang.org/docs/1.32/usingchapel/multilocale.html#co-locales)
* unstable `config` variables are now hidden in the output of `--help`
* unstable `config`s now generate a warning when set on the command-line

Portability / Platform-specific Improvements
--------------------------------------------
* added support for co-locales to `CHPL_COMM=gasnet` with the `ibv` substrate  
  (see https://chapel-lang.org/docs/1.32/usingchapel/multilocale.html#co-locales)
* updated arm-based (M1/M2) Macs to default to `CHPL_TASKS=qthreads`
* updated arm-based (M1/M2) Macs to default to `CHPL_MEM=jemalloc`
* resolved sporadic memory consistency issues on ARM processors
* improved the equivalence of `arm64` and `aarch64` in our scripting
* added support for processors with heterogeneous processing units  
  (see https://chapel-lang.org/docs/1.32/usingchapel/executing.html#controlling-the-kind-of-processing-units)
* enabled support for hugepages on the HPE Cray EX platform  
  (see https://chapel-lang.org/docs/1.32/platforms/libfabric.html#hugepages-on-cray-xc-and-hpe-cray-ex-systems)
* improved the landing zone sizing when using `CHPL_COMM=ofi`
* fixed a linkage issue in which system libraries could override ours
* suppressed invalid gcc 13 "possibly dangling reference" warning

Compiler Improvements
---------------------
* added `@llvm.assertVectorized` and `@llvm.metadata` as attributes on loops  
* stopped applying `-Wall` and `Werror` when compiling `extern` blocks
* improved the behavior of `--mllvm` when it is passed an unknown flag

Runtime Library Changes
-----------------------
* made `chpl_library_init()` issue an error if called twice
* made `chpl_library_finalize()` no longer exit, permitting client to continue
* removed the ability to override the max # of endpoints with `CHPL_COMM=ofi`

Launchers
---------
* added co-locale support to the `[slurm|pbs]-gasnetrun_ibv` launchers
* updated the `pbs-gasnetrun_ibv` launcher to use `place/select` qsub syntax

Error Messages / Semantic Checks
--------------------------------
* shortened paths displayed in some error messages with `$CHPL_HOME`
* simplified error formatting when compiling C code within an `extern` block
* improved errors when calling `Reflection.getFieldRef()` on an internal type  
* fixed incorrect underlining of string literals in detailed error messages

Bug Fixes
---------
* fixed importing tertiary methods by naming a builtin type like `string`
* fixed a bug in which `CHPL_UNWIND` could not be overridden on some platforms
* fixed internal errors when using tuples as formal or return types in FCPs
* fixed declaring a variable with an explicitly generic type  
  (e.g., `var d: domain(?) = {1..5}` now works)
* fixed incorrect scoping of variables in `do`...`while` loops' conditions
* fixed a bug in which FCPs printed incorrectly with JSON serializers
* fixed a bug in which unstable warnings were generated when using `_`
* fixed `fifo` guard pages when using `CHPL_MEM=jemalloc` on arm-based macs
* fixed a bug when using array type expression actuals within loop bodies
* removed extra borrow when casting from a managed class to an unmanaged class
* fixed a bug in which unstable warnings were generated for non-user code

Bug Fixes for Build Issues
--------------------------
* fixed handling of `pkg-config --exists` exit status

Bug Fixes for GPU Computing
---------------------------
* fixed a bug in which GPU atomic routines returned the wrong values  
* fixed a bug with accessing `ref`s declared outside of a GPU-eligible loop
* fixed a bug with `.locale` queries on AMD GPUs, or when `--fast` was used
* fixed an assertion when running GPU programs for AMD w/ `CHPL_DEVELOPER` set

Bug Fixes for Libraries
-----------------------
* fixed `regex.split()` when matching to a pattern with an empty group
* fixed error-checking logic for `regex` that was being optimized away
* fixed a bug where `%r`/`%n` ignored precision arguments for integer values
* fixed bug that prevented deserialization of `bytes` in JSON and CHPL formats
* fixed bug where the `JsonDeserializer` could fail to parse a list
* fixed incorrect error text when calling `c_ptrTo[Const]()` on a domain
* removed unintended warning when calling `Types.isCopyableType()` on a `sync`

Bug Fixes for Tools
-------------------
* fixed several bugs where `chpldoc` did not handle unstable warnings correctly
* fixed procedure signatures not rendering correctly in `chpldoc` HTML output
* fixed documentation-generation script for distributions to preserve warnings

Third-Party Software Changes
----------------------------
* updated the bundled version of GASNet-EX to 2023.3.0
* updated the bundled version of Qthreads to 1.19
* updated the bundled version of hwloc to 2.9
* updated the bundled version of GMP to version 6.3.0

Developer-oriented changes: Process
-----------------------------------
* moved top-level .gitignore entries to their closest subdirectory

Developer-oriented changes: Module changes
------------------------------------------
* improved the `BigInteger` module organization to reduce maintenance burden

Developer-oriented changes: Compiler Flags
------------------------------------------
* added `--llvm-remarks[-function]` to report LLVM optimization information  
  (see https://chapel-lang.org/docs/1.32/technotes/llvm.html#inspecting-llvm-optimizations)
* improved `--log-module` to support logging multiple modules at a time
* removed the broken `--log-node` flag

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* added prototypical support for LLVM 16
* added an experimental driver mode, enabled using `--compiler-driver`  
  (see https://chapel-lang.org/docs/1.32/technotes/driver.html)
* improved `@deprecated` to handle deprecations from paren-ful to paren-less
* stopped generating LLVM lifetime and invariant hints
* put and get primitives now assume a `ref` / `const ref` is passed to them

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* made numerous improvements to the 'dyno' resolver for types and calls:
  - added basic support for `forwarding` to members in a class or record
  - added basic support for generic tuple type expressions (e.g. (?, integral))
  - added basic support for param-folding `select` statements
  - added support for the `class` typeclass
  - improved handling of control flow when inferring an `iter`'s `yield` type
  - added support for the `c_ptr` type
  - added support for opaque `extern` types
  - fixed a bug involving recursive type resolution in fields

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added a new runtime shim for the GASNet-EX API upgrade
* enabled forceable creation of a fixed heap with `CHPL_COMM=ofi`
* pinned the `CHPL_COMM=ofi` `fi_getinfo` API version to 1.9

Developer-oriented changes: Testing System
------------------------------------------
* modified `start_test` to not look for performance keys on a non-zero exit
* added a warning when a line in a `.graph` file is unrecognized
* removed email capability from `cron` scripts
* throttled compile-only tests when the execution limiter is enabled
* improved `chpl_launchcmd` support for systems with queues and prologues

Developer-oriented changes: Tool Improvements
---------------------------------------------
* improved how `chpldoc` generates module documentation:
  - `where`-clauses are now printed out as part of a routine's signature
  - individual constants within an `enum` can now have their own documentation
* added support for Chapel AST syntax highlighting
* added sphinx message filter for `:enumconstant:`
* added support for 'Goto Declaration' to the Chapel language server

Developer-oriented changes: Utilities
-------------------------------------
* added a utility for batch replacement guided by errors reported by paratest  
  (see https://github.com/chapel-lang/chapel/tree/release/1.32/util/devel/deprecationScript)


version 1.31.0
==============

released June 22, 2023

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* many language and library improvements in support of Chapel 2.0:
  - improved naming, ergonomics, and precision for the `range` type
  - improved APIs in the 'BigInteger', 'CTypes', 'List', 'Time', ... modules
  - improved the organization of math symbols between 'Math' and 'AutoMath'
* significant improvements to Chapel's GPU support, including:
  - support for multilocale computing with AMD GPUs
  - increased flexibility and generality for code patterns that run on GPUs
  - a new mode for using the GPU locale model on CPUs
  - a `--report-gpu` flag to get feedback about GPU-eligible loops
  - prototype support for NVIDIA peer-to-peer accesses
* LLVM 15 is now supported and the preferred compiler back-end
* the 'dyno' scope resolver is now the default, featuring improved errors
* improved performance for `bigint`s, 'Time' routines, and large IO operations
* a prototype IO serialization framework with JSON, YAML, and binary formats
* prototype support for redistributing `Block` arrays and domains
* numerous improvements in terms of portability, documentation, bug fixes, ...

Configuration / Build / Packaging Changes
-----------------------------------------
* added a new `CHPL_GPU` environment variable to specify GPU targets  
  (see https://chapel-lang.org/docs/1.31/technotes/gpu.html#gpu-related-environment-variables)
* improved error messages when the build is unable to find LLVM
* `CHPL_[HOST|TARGET]_COMPILER` can now be inferred from `CHPL_*_[CC|CXX]`  
  (see https://chapel-lang.org/docs/1.31/usingchapel/chplenv.html#chpl-compiler)
* `CHPL_TARGET_CC|CXX` now impacts the `clang` commands used by LLVM  
  (see https://chapel-lang.org/docs/1.31/usingchapel/chplenv.html#cc-and-similar)

Language Feature Improvements
-----------------------------
* changed `range.stridable` bool to `range.strides` of type `enum strideKind`  
  (see https://chapel-lang.org/docs/1.31/language/spec/ranges.html#range-types  
   and https://chapel-lang.org/docs/1.31/language/spec/ranges.html#range-type-queries)
* `range.alignment` and `range.aligned` are now `param`s when possible
* `domain.stride` is now a `param` for 1D domains with `strides==one`/`negOne`
* stabilized `.count()` on arrays
* the const-ness of C pointers in `extern` blocks is now respected  

Syntactic / Naming Changes
--------------------------
* renamed the `BoundedRangeType` enum to `boundKind`  
  (see https://chapel-lang.org/docs/1.31/language/spec/ranges.html#range-types)
* renamed `range.boundedType` to `range.bounds`  
  (see https://chapel-lang.org/docs/1.31/language/spec/ranges.html#range-type-queries)
* renamed the abstract root class from `object` to `RootClass`  
  (see https://chapel-lang.org/docs/1.31/language/spec/classes.html#the-root-class)
* changed `string`/`bytes` factory routines to type methods and renamed them  
  (e.g., see https://chapel-lang.org/docs/1.31/language/spec/bytes.html#Bytes.bytes.createBorrowingBuffer,  
   and https://chapel-lang.org/docs/1.31/language/spec/strings.html#String.string.createBorrowingBuffer)

Semantic Changes / Changes to the Chapel Language
-------------------------------------------------
* `break`, `return`, and labeled `continue` are now illegal in `foreach` loops
* `.alignment` on strided ranges now returns a value within `0..<abs(stride)`

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* deprecated the `range` type's `stridable` field
* deprecated support for `isBounded[Range]()` queries for ranges  
  (see https://chapel-lang.org/docs/1.31/language/spec/ranges.html#ChapelRange.isBoundedRange)
* deprecated `.head()` and `.tail()` on arrays
* deprecated casts from `owned`, `shared`, or `borrowed` to `unmanaged`
* deprecated casts from `owned` to `shared` in favor of `shared.adopt(owned)`  
  (see https://chapel-lang.org/docs/1.31/language/spec/classes.html#SharedObject.shared.adopt)
* deprecated `.create`/`.retain` on `owned`/`shared` in favor of `.adopt`  
  (see https://chapel-lang.org/docs/1.31/language/spec/classes.html#OwnedObject.owned.adopt  
   and https://chapel-lang.org/docs/1.31/language/spec/classes.html#SharedObject.shared.adopt)
* deprecated `.clear()` on `owned` and `shared` in favor of assigning `nil`  
  (see https://chapel-lang.org/docs/1.31/language/spec/classes.html#OwnedObject.owned.clear  
   and https://chapel-lang.org/docs/1.31/language/spec/classes.html#SharedObject.shared.clear)
* deprecated `lambda` and `func` in favor of the new `proc`-based syntax
* marked the first-class function `retType` and `argTypes` methods as unstable
* marked the `const` return and yield intents as being unstable
* marked casts between ranges of enum types as being unstable
* removed the deprecated method `domain.makeIndexBuffer()`
* removed the deprecated `locale.getChild[Count]()`, `.callStackSize()` methods
* removed support for `%=` on `real`s for now (because it didn't work)

Namespace Changes
-----------------
* moved several automatically-included math symbols from 'AutoMath' to 'Math'  
  (e.g., `e`, `[half_|quarter_|[twice_]recipr_][sqrt_]pi`, `[recipr_]sqrt_2`,  
   `log[10|2]()`, `log[2|10]_e`, `ln_[2|10]`, `[ld]exp[2|m1]()`,  
   `[a][cos|sin|tan][2|h]()`, `[l|t]gamma()`, `gcd()`, `erf[c]()`)  
  (see https://chapel-lang.org/docs/1.31/modules/standard/Math.html  
   and https://chapel-lang.org/docs/1.31/modules/standard/AutoMath.html)
* renamed 'Memory.Diagnostics' to 'MemDiagnostics'  
  (see https://chapel-lang.org/docs/1.31/modules/standard/MemDiagnostics.html)

Standard Library Modules
------------------------
* added `c_ptrConst` and `c_ptrToConst()` to represent `const` C pointers  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.c_ptrConst  
   and https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.c_ptrToConst)
* introduced user-defined serialization that can integrate with standard IO  
  (see https://chapel-lang.org/docs/1.31/technotes/ioSerializers.html)
* added a `stripNewline` option to `fileReader.lines()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileReader.lines)
* relaxed locking needs for `file[Reader|Writer].[mark|revert|commit|offset]`  
  (e.g., see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileReader.mark)

Package Modules
---------------
* added a new 'Json' module that implements IO serialization of JSON  
  (see https://chapel-lang.org/docs/1.31/modules/packages/Json.html)
* added a new 'BinaryIO' module that implements binary IO serialization  
  (see https://chapel-lang.org/docs/1.31/modules/packages/BinaryIO.html)
* added a new 'Yaml' package supporting YAML IO including [de]serialization  
  (see https://chapel-lang.org/docs/1.31/modules/packages/Yaml.html)
* added a new 'ChplFormat' module that implements `%ht` IO serialization  
  (see https://chapel-lang.org/docs/1.31/modules/packages/ChplFormat.html)

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added initial support for redistributing `Block` distributions  
  (e.g., `myBlockDist.redistribute({1..2*n});` or `myBlockDist = blockDist2;`)

Changes / Feature Improvements in Libraries
-------------------------------------------
* changed many `bigint` methods into standalone procedures taking `ref` args  
  (e.g., `divexact()`, `pow[Mod]()`, `root[rem]()`, `sqrt[rem]()`,  
   `nextprime()`, `gcd()`, `lcm()`, `invert()`, `removeFactor()`, `fac()`,  
   `bin()`, `fib[2]()`, `lucnum[2]()`, `add[mul]()`, `sub[mul]()`,  
   `mul[_2exp]()`, `neg()`, `abs()`, `div[Q][R][2Exp]()`, `mod()`, `and()`,  
   `[i|x]or()`, `com()`;  
   see https://chapel-lang.org/docs/1.31/modules/standard/BigInteger.html)
* changed `CTypes.c_ptrTo()` to point to the object for a class variable  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.cPtrToLogicalValue)
* changed `CTypes.c_ptrTo()` to point to the buffer for a `string`/`bytes`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.cPtrToLogicalValue)
* added a warning for `c_ptr()` casts that may violate C's aliasing rules  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.c_ptr)
* changed `CTypes.c_FILE` to represent a C `FILE` rather than a `FILE*`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.cFileTypeHasPointer)
* added support for creating an uninitialized `weak` value for a given class  
  (see https://chapel-lang.org/docs/1.31/builtins/WeakPointer.html#WeakPointer.weak)

Name Changes in Libraries
-------------------------
* renamed `list.append()` to `list.pushBack()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/List.html#List.list.pushBack)
* renamed `list.pop()` for the end of a list to `list.popBack()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/List.html#List.list.popBack)
* renamed `list.pop()` for a specific index to `list.getAndRemove()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/List.html#List.list.getAndRemove)
* renamed `list.set()` to `list.replace()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/List.html#List.list.replace)
* renamed `BitOps.popcount()` to `BitOps.popCount()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/BitOps.html#BitOps.popCount)
* renamed `c_*alloc()` and `c_free()` to `allocate()` and `deallocate()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.allocate  
   and https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.deallocate)
* dropped `c_` prefixes from `mem[move|cpy|cmp|set]`, moving them to 'OS.POSIX'  
  (see https://chapel-lang.org/docs/1.31/modules/standard/OS/POSIX.html#POSIX.memmove)
* updated 'Time' symbols to use preferred capitalization styles  
  (see https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.dateTime,  
   https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.timeDelta,  
   https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.day,  
   https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.dateTime.getDate,  
   and https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.dateTime.getTime)
* updated 'Time' factory procedures to start with `create*()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.date.createFromTimestamp,  
   https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.date.createFromOrdinal,  
   https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.dateTime.createFromTimestamp,  
   https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.dateTime.createUtcFromTimestamp,  
   and https://chapel-lang.org/docs/1.31/modules/standard/Time.html#Time.dateTime.createFromOrdinal)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* marked standard modules that are not a focus for Chapel 2.0 as unstable
* deprecated `c_nil` and `is_c_nil` in favor of using `nil` and `== nil`
* deprecated `isAnyCPtr()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.isAnyCPtr)
* marked `set.parSafe` as unstable  
  (see https://chapel-lang.org/docs/1.31/modules/standard/Set.html#Set.set.parSafe)
* marked `readln()` as unstable  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileReader.readln)
* deprecated `.writing` on `file[Reader|Writer]` in favor of a type query  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileReader.writing  
   and https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileWriter.writing)
* deprecated `_mark|_revert|_commit|_offset` in favor of no underscores  
  (e.g., see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileReader._offset)
* deprecated `.offset` on `fileReader|Writer` automatically taking a lock  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileOffsetWithoutLocking)
* marked `readWriteThisFromLocale` as unstable  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.fileReader.readWriteThisFromLocale)
* deprecated support for non-reusable barriers from the 'Collectives' module
* deprecated `barrier.check()` in favor of `barrier.pending()`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/Collectives.html#Collectives.barrier.pending)
* deprecated the now-empty 'Memory' module  
  (see https://chapel-lang.org/docs/1.31/modules/standard/Memory.html)
* removed the deprecated 'SysBasic' module
* removed the deprecated procedure `IO.unicodeSupported()`

GPU Computing
-------------
* added multi-locale support for computing with AMD GPUs
* added a new mode to enable using the GPU locale model on CPUs w/out GPUs  
  (see https://chapel-lang.org/docs/1.31/technotes/gpu.html#cpu-as-device-mode)
* added a `--report-gpu` compiler flag to list GPU-[in]eligible loops  
  (see https://chapel-lang.org/docs/1.31/technotes/gpu.html#diagnostics-and-utilities)
* added an `enableGpuP2P` config const to enable NVIDIA peer-to-peer accesses  
  (see https://chapel-lang.org/docs/1.31/technotes/gpu.html#device-to-device-communication-support)
* added atomic operations to the GPU module  
  (see https://chapel-lang.org/docs/1.31/modules/standard/GPU.html#GPU.gpuAtomicAdd)
* added support for calling recursive functions from GPU code
* fixed support for modifying arrays passed by `ref` intent on GPUs
* introduced a new `CHPL_GPU` setting to replace `CHPL_GPU_[CODEGEN|RUNTIME`  
  (see https://chapel-lang.org/docs/1.31/technotes/gpu.html#gpu-related-environment-variables)
* added a check to validate the CUDA and ROCM versions when building `chpl`
* added an error for `createSharedArray()` when arguments have unknown size

Performance Optimizations / Improvements
----------------------------------------
* added support for remote-value-forwarding `bigint` values across on-clauses
* eliminated needless communication from many routines in the 'Time' module
* optimized IO performance for large read/write operations
* improved the compiler's ability to optimize 'BitOps' procedures

Compilation-Time / Generated Code Improvements
----------------------------------------------
* restored the `--savec` Makefile's dependencies when using the C back-end

Memory Improvements
-------------------
* fixed a sporadic memory leak when deinitializing `shared` variables

Tool Improvements
-----------------
* updated `chpldoc` to squash documentation for symbols beginning with `chpl_`
* added `chpldoc` support for rst hyperlinks of the form `nicename<target>`  
  (see https://chapel-lang.org/docs/1.31/tools/chpldoc/chpldoc.html#inline-markup-2)
* added support for filtering `chpldoc` deprecations that use `~` or `!`  
  (see https://chapel-lang.org/docs/1.31/tools/chpldoc/chpldoc.html#inline-markup-2)

Language Specification Improvements
-----------------------------------
* updated the language specification with respect to major changes in 1.31
* removed the previously deprecated `new borrowed MyClass()` from the spec
* fixed other various typos and spelling issues

Other Documentation Improvements
--------------------------------
* refreshed the sample installation commands in the prerequisites docs  
  (see https://chapel-lang.org/docs/1.31/usingchapel/prereqs.html#installation)
* refreshed the primer on rectangular arrays  
  (see https://chapel-lang.org/docs/1.31/primers/arrays.html)
* unified two distinct documents with debugging tips into one  
  (see https://chapel-lang.org/docs/1.31/usingchapel/debugging.html)
* added an example of multi-argument promotion to the user's guide  
  (see https://chapel-lang.org/docs/1.31/users-guide/datapar/promotion.html#multi-argument-promotion)
* added quick link categories to the 'AutoMath' and 'Math' library modules  
  (see https://chapel-lang.org/docs/1.31/modules/standard/AutoMath.html#roots  
   and https://chapel-lang.org/docs/1.31/modules/standard/Math.html#constants)
* added a section about the use of `SystemError` in the 'IO' module  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#error-handling)
* improved the accuracy of thrown error types in the 'IO' module
* improved the consistency of how throwing procedures are formatted
* added information to the C interop technote about `c_ptr`s to classes  
  (see https://chapel-lang.org/docs/1.31/technotes/extern.html#working-with-c-ptr)
* hid the underlying implementation types of `c_ptr` and `c_array` in docs  
  (see https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.c_ptr  
  and https://chapel-lang.org/docs/1.31/modules/standard/CTypes.html#CTypes.c_array)
* clarified `CHPL_LIB_PIC` in the documentation  
  (see https://chapel-lang.org/docs/1.31/usingchapel/chplenv.html#chpl-lib-pic)
* updated an assertion that `fileReader` can produce `EEOF` to `OS.EofError`  
  (see https://chapel-lang.org/docs/1.31/modules/standard/IO.html#IO.file.reader)

Example Codes
-------------
* added a new user's guide example program for promoted procedure calls
* updated example codes with respect to language and library changes in 1.31

Portability / Platform-specific Improvements
--------------------------------------------
* improved portability to GCC 12 and 13
* improved portability to Intel Classic Compiler 2023.1.0 with warnings enabled
* added the ability to build with GCC as the host compiler on Macs
* improved logic for finding dependencies within NixOS
* fixed a portability problem with finding `addr2line` for stack unwinding
* improved the portability of the HDF5 module w.r.t. integer sizes

Compiler Improvements
---------------------
* the compiler now supports LLVM 15 in addition to versions 11 through 14
* the 'dyno' scope resolver is now the default, featuring better error messages

Compiler Flags
--------------
* added a new `--print-chpl-home` flag to query the location of `$CHPL_HOME`  
  (see https://chapel-lang.org/docs/1.31/usingchapel/man.html#options)
* made the `--version` output print available LLVM targets

Launchers
---------
* made 'slurm-srun' respect Slurm reservations when querying node properties

Error Messages / Semantic Checks
--------------------------------
* improved several error messages thanks to the new 'dyno' error framework  
  (use `--detailed-errors` to opt-in to more detailed error messages)
* improved an error message for malformed `config var`s set at compile-time
* added an error if an `extern` block is not at module scope
* improved errors when an `extern` block' is missing relevant `#include`s
* removed a warning about behavior changes for `zip()`s led by unbounded ranges

Bug Fixes
---------
* fixed a bug with first-class functions that caused crashes
* fixed a bug preventing the use of `forall` in `chpl_deserialize()` routines
* fixed a bug in which attributes on certain statements would cause segfaults
* removed extra null when creating `string`/`bytes` from remote borrowed data
* fixed a bug in which casting ranges of ints to enums used the ordinal values
* fixed a bug in which replacement modules were not suppressing warnings
* fixed a bug where promotion would squash deprecation and unstable warnings
* fixed a bug in which extra line number arguments were added to routines

Bug Fixes for Build Issues
--------------------------
* fixed a bug in which Protocol Buffer support was omitted from the release
* fixed a problem building `chpl` with `CC` and `CXX` set

Bug Fixes for GPU Computing
---------------------------
* fixed a bug involving querying grid dimensions when using AMD GPUs
* fixed the behavior of `.locale` queries within GPU kernels
* fixed a bug that prevented compiling `.c` files with the GPU locale model
* fixed a bug with loops whose bounds didn't fit into 32-bit integers
* fixed a bug with `string`/`bytes` config variables with the GPU locale model
* fixed a bug in which certain values of `CHPL_GPU_ARCH` crashed the compiler

Bug Fixes for Libraries
-----------------------
* fixed a bug where `regex.match('$')` returned an incorrect offset
* fixed a bug preventing default `map` accessors from returning references
* fixed support for reading/writing `map` and `list` types as JSON (`%jt`)
* fixed a bug in which `fileWriter.writeBinary()` assumed 0-based indexing
* fixed several bugs in `fileReader.search` and `fileReader.matches`
* fixed a bug in which `fileWriter` could write past its region's upper bound
* prevented region upper bounds from overflowing for `fileReader|Writer` types
* fixed a `bigint` memory corruption  when multiple arguments shared a value
* fixed a bug where `Reflection.getField[Ref]` didn't work with wrapper fields
* fixed a bug preventing the use of `socket.close()` in the 'ZMQ' module
* fixed a bug with `SortedSet.kth()` for types that can't be default-init'ed

Bug Fixes for Tools
-------------------
* fixed a bug in which `chpldoc` was not deleting its temporary directory

Third-Party Software Changes
----------------------------
* updated the bundled version of LLVM to 15.0.7
* updated the bundled copy of 'libfabric' to version 1.17.1
* removed the 'qthreads' config-time check of 'hwloc' linking
* fixed an issue where `amudprun` was built with GCC rather than `CHPL_HOST_CC`

Developer-oriented changes: Documentation
-----------------------------------------
* cleaned up the developer document on deprecating features  
  (see https://chapel-lang.org/docs/1.31/developer/bestPractices/Deprecation.html#best-practices-deprecation)
* added developer-oriented documentation for the 'dyno' query system
* updated the required 'sphinxcontrib-chapeldomain' version to 0.0.25
* updated remaining references to the 'Compiler Library' to 'Frontend Library'

Developer-oriented changes: Syntactic / Naming Changes
------------------------------------------------------
* deprecated `pragma "no doc"` in favor of the `@chpldoc.nodoc` attribute

Developer-oriented changes: Module changes
------------------------------------------
* stamped out built-in routines using the `x: t(?w), y: t(w)` argument pattern
* reimplemented `bigint` operators to share code with the procedure versions
* simplified `bigint` locality checks to reduce duplicated code

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* updated the Makefiles to remove the compiler as a dependency for `chpldoc`
* updated developer-oriented warnings for clang to more closely match gcc/g++

Developer-oriented changes: Compiler Flags
------------------------------------------
* added flags to control the default implementation of IO serialization:  
  - `--[no-]io-gen-serialization` controls the generation of default methods
  - flags to replace `serialize`/`deserialize` with `writeThis`/`readThis`  
    (see `--[no-]io-serialize-writeThis`, `--[no-]io-deserialize-readThis`)
* added a `--print-chpl-loc` flag for determining the compiler's location

Developer-oriented changes: Compiler improvements / changes
-----------------------------------------------------------
* adjusted the compiler's use of LLVM's Support Library to prepare for LLVM 16
* migrated Chapel's LLVM pass implementations to the new pass manager
* stopped showing deprecation/unstable warnings in standard modules
* moved all 'chpl' flags into 'driver.cpp' now that 'chpldoc' doesn't use them

Developer-oriented changes: 'dyno' Compiler improvements / changes
------------------------------------------------------------------
* improved several aspects of the 'dyno' scope resolver:
  - fixed auto-used modules being preferred over regular modules
  - fixed corner cases in which adding a `use` statement hid a symbol
  - fixed private module `include`s and report related errors in production
  - added support for compiler-generated constants like `boundsChecking`
* improved detailed error message output to avoid printing too much code
* improved several aspects of 'dyno's resolution of types and calls:
  - added basic support for arrays and domains
  - added support for tuple types using the `*` operator (e.g. `3*int`)
  - added support for compile-time folding involving unary operators
  - added basic support for the `locale` type
  - added name resolution for `extern` blocks
  - added support for compile-time reflection
  - added support for the `super` and `index` keywords
  - added support for detecting dead `return` and `yield` statements
  - added support for the `return` keyword within iterators
  - added validation for `try`/`catch` blocks
  - fixed bugs involving optional type arguments
  - fixed bugs involving type methods in generic types
* fixed a bug where `testQueryTimingAndTrace` query tracing tool could not run
* reduced memory consumed by `ResolutionResultByPostorderID`s

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added `CHPL_HWLOC_DEBUG`/`CHPL_TASKS_DEBUG` to help debug hwloc/tasking code

Developer-oriented changes: Testing System
------------------------------------------
* added support for directory-wide `PRETEST` scripts to support generated tests

Developer-oriented changes: Tool Improvements
---------------------------------------------
* added a prototypical version of the Chapel language server 'chpldef'
* changed 'c2chapel' to generate `c_ptrConst` rather than `c_ptr` where correct


version 1.30.0
==============

released March 23, 2023

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* significantly increased GPU performance and added support for AMD GPUs
* added a generalized attribute syntax and used it to support stability notes
* made many improvements to the capabilities and interfaces of 'IO' routines
* improved the correctness, performance, and compilation time of `bigint`s
* added a prototype `weak(C)` type for weak references to `shared` classes
* improved the behavior of passing and yielding tuples
* significantly improved compilation speeds for certain large applications
* switched to a CMake-based build of `chpl` and `chpldoc`
* added initial support for running a locale per socket / NIC on HPE Cray EX
* added a best practices document for using Chapel on Raspberry Pi
* made numerous renamings, deprecations, and improvements to standard modules
* addressed a number of user-reported bugs and documentation requests

Configuration / Build / Packaging Changes
-----------------------------------------
* switched to using CMake behind the scenes to build `chpl` and `chpldoc`
* added new `QUIET` and `VERBOSE` build modes by setting these vars to `1`  
  (see https://chapel-lang.org/docs/1.30/usingchapel/building.html#controlling-build-output)
* for `./configure --chpl-home`, installs now require CMake 3.16 or later  
  (see https://chapel-lang.org/docs/1.30/usingchapel/prereqs.html#chapel-prerequisites)
* updated Chapel's Dockerfiles to support the C back-end in addition to LLVM  
  (see https://hub.docker.com/r/chapel/chapel/)

New Language Features
---------------------
* added support for a generalized attribute syntax  
  (see https://chapel-lang.org/docs/1.30/technotes/attributes.html)
* added new `@deprecated` and `@stable` attributes for indicating stability  
  (see https://chapel-lang.org/docs/1.30/technotes/attributes.html#stability-attributes)
* added a new 2-argument `.find()` method on arrays  
  (see https://chapel-lang.org/docs/1.30/language/spec/arrays.html#ChapelArray.find)
* added new `.adopt()` methods to the `owned` and `shared` classes  
  (see https://chapel-lang.org/docs/1.30/language/spec/classes.html#OwnedObject.owned.adopt  
   and https://chapel-lang.org/docs/1.30/language/spec/classes.html#SharedObject.shared.adopt)
* added a new `.release()` method for `owned` classes  
  (see https://chapel-lang.org/docs/1.30/language/spec/classes.html#OwnedObject.owned.release)
* added initial support for initializers that can `throw` errors  
  (see https://chapel-lang.org/docs/1.30/technotes/throwingInit.html)
* added a prototype `.transmute()` for bitwise `uint` <-> `real` conversions  
  (e.g., `r.transmute(uint)` will return a `uint` with `r`'s bit pattern)
* added support for single-statement subroutine bodies using the `do` keyword  
  (see https://chapel-lang.org/docs/1.30/language/spec/procedures.html#the-function-body)
* added a `.fullIdxType` query on arrays to get multidimensional index types  
  (see https://chapel-lang.org/docs/1.30/language/spec/arrays.html#ChapelArray.fullIdxType)

Feature Improvements
--------------------
* improved the behavior when slicing ranges, domains, and arrays  
  (see https://chapel-lang.org/docs/1.30/language/spec/ranges.html#range-slicing)
* enabled the ability to query `type`/`param` values within formal types  
  (e.g., `proc foo(r: range(?it, ?bd, ?sb)) { ... }` is now supported)
* improved support for loops over unbounded ranges/domains of `enum`/`bool`  
  (e.g., `for i in false.. by -1` will now yield `true`, `false`)
* added new optional arguments to the `@unstable` annotation  
  (see https://chapel-lang.org/docs/1.30/technotes/attributes.html#stability-attributes)
* enabled classes to have methods that share the class's name  
  (e.g., `class C { proc C() { ... } }` is now legal)

Syntactic / Naming Changes
--------------------------
* renamed the new `weakPointer(C)` type to `weak(C)`  
  (see https://chapel-lang.org/docs/1.30/builtins/WeakPointer.html#WeakPointer.weak)
* changed the syntax of `@unstable "msg"` to `@unstable("msg", ...)`
* unified `chpl`'s parsing of array types/values and square bracket loops

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* deprecated the old `.find()` method on arrays to update its return type  
  (see https://chapel-lang.org/docs/1.30/language/spec/arrays.html#ChapelArray.find)
* marked arrays and slices with negatively strided dimensions as unstable
* deprecated support for single-statement `return` routines that don't use `do`
* deprecated support for `bool` types with specified widths (e.g., `bool(8)`)
* removed deprecated `isFloat*()` query routines
* removed support for the deprecated `alignedBoundsByDefault` `config param`

Standard Library Modules
------------------------
* added new GPU-oriented utility routines  
  (see 'GPU Computing' below)
* added `.read[To|Through]()` methods to read up to/through a given separator  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readTo,  
   https://chapel-lang.org/docs/1.30/modules/standard/Regex.html#Regex.fileReader.readTo,  
   https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readThrough,  
   and https://chapel-lang.org/docs/1.30/modules/standard/Regex.html#Regex.fileReader.readThrough)
* added `.advance[To|Through]()` methods to advance to/through a separator  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.advanceTo  
   and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.advanceThrough)
* added `.write[String|Bytes]()` methods to write out `string`/`bytes` values  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileWriter.writeString  
   and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileWriter.writeBytes)
* added new `[read|write]Codepoint()` methods to read/write UTF-8 codepoints  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readCodepoint  
   and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileWriter.writeCodepoint)
* added `readByte()` and `writeByte()` routines to read/write a single byte  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readByte  
   and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileWriter.writeByte)
* updated I/O errors in 'OS' to inherit from `Error` instead of `SystemError`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/OS.html#OS.EofError,  
   https://chapel-lang.org/docs/1.30/modules/standard/OS.html#OS.UnexpectedEofError, and  
   https://chapel-lang.org/docs/1.30/modules/standard/OS.html#OS.BadFormatError)

Changes / Feature Improvements in Libraries
-------------------------------------------
* made `bigint` initializers that halted/returned error codes `throw` instead  
  (see https://chapel-lang.org/docs/1.30/modules/standard/BigInteger.html#BigInteger.bigint.init,  
  https://chapel-lang.org/docs/1.30/modules/standard/BigInteger.html#BigInteger.bigintInitThrows)
* updated the `bigint` cast from `string` so it `throw`s for illegal values
* added a `permissions` argument to `FileSystem.copy()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/FileSystem.html#FileSystem.copy)
* added a `metadata` argument to `FileSystem.copyTree()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/FileSystem.html#FileSystem.copyTree)
* added explicit type constraints to `date`/`time`/`datetime` initializers  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Time.html#Time.date.init,  
   https://chapel-lang.org/docs/1.30/modules/standard/Time.html#Time.time.init, and  
   https://chapel-lang.org/docs/1.30/modules/standard/Time.html#Time.datetime.init)

Name Changes in Libraries
-------------------------
* renamed `new[Block|Cyclic][Dom|Arr]` to `[Block|Cyclic].new[Domain|Array]`  
  (see https://chapel-lang.org/docs/1.30/modules/dists/BlockDist.html  
   and https://chapel-lang.org/docs/1.30/modules/dists/CyclicDist.html)
* changed GPU-related features to use `Gpu` over `GPU` in identifier names  
  (e.g. `GPUDiagnostics` is now `GpuDiagnostics`)
* renamed the `.read[string|bytes]()` methods to `.read[String|Bytes]()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readString  
   and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readBytes)
* renamed `[read|write]bits()` to `[read|write]Bits()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.readBits  
   and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileWriter.writeBits)
* renamed `open[reader|writer]()` to `open[Reader|Writer()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.openReader  
  and https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.openWriter)
* renamed `iomode` to `ioMode`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.ioMode)
* renamed `file.check()` to `file.isOpen()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.file.isOpen)
* renamed `openmem()` to `openMemFile()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.openMemFile)
* replaced `IO.openfp()` with a file initializer taking a `c_FILE` argument  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.file.init)
* replaced `IO.openfd()` with a file initializer taking a `fileDescriptor` arg  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.file.init)
* replaced `map.set()` with `map.replace()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Map.html#Map.map.replace)
* unified formatting of 'Errors' varargs procedure signatures  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Errors.html#Errors.compilerError)
* renamed `IllegalArgumentError`'s initializer formal from `info` to `msg`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Errors.html#Errors.IllegalArgumentError)
* renamed `c_sizeof()`'s formal from `x` to `t` in the 'CTypes' module  
  (see https://chapel-lang.org/docs/1.30/modules/standard/CTypes.html#CTypes.c_sizeof)
* renamed the 'Barriers' module to 'Collectives'  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Collectives.html)
* renamed the `Barrier` type to `barrier`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Collectives.html#Collectives.barrier)
* renamed `MemMove.needsDeinit()` to `MemMove.needsDestroy()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/MemMove.html#MemMove.needsDestroy)
* renamed `MemMove.explicitDeinit()` to `MemMove.destroy()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/MemMove.html#MemMove.destroy)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* deprecated `file.lines()` in favor of `file.reader().lines()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.lines)
* deprecated `readBinary()` on arrays to update its return type to `int`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.ReadBinaryArrayReturnInt)
* deprecated `advancePastByte()` in favor of the new `advanceThrough()` method  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileReader.advanceThrough)
* deprecated the `fileWriter.writeBytes()` version that took generic arguments  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.fileWriter.writeBytes)
* deprecated `ioBits` in favor of `readBits()`/`writeBits()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.ioBits)
* deprecated `ioChar` in favor of `readCodepoint()`/`writeCodepoint()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.ioChar)
* deprecated `ioHintSet.noMmap` in favor of `ioHintSet.mmap(false)`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#IO.ioHintSet.mmap)
* deprecated `regex.compile()` in favor of `new regex()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Regex.html#Regex.regex.init)
* deprecated `regex.sub[n]()` in favor of `replace[AndCount]()` methods  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Regex.html#Regex.string.replace)
* deprecated `map.items()` and `map.these()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Map.html#Map.map.items)
* marked `map.parSafe` as being unstable
* deprecated `map.getBorrowed()`, `.getReference()`, and `.getValue()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Map.html#Map.map.getBorrowed)
* marked `TaskErrors.first()` unstable, expecting a potential name change  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Errors.html#Errors.TaskErrors.first)
* deprecated the `TimeUnits` enum and routines that made use of it  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Time.html#Time.TimeUnits)
* marked 'Time' routines that wrap C functions as unstable  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Time.html#Time.date.ctime)
* deprecated `FileSystem.copyFile()` in favor of `FileSystem.copy()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/FileSystem.html#FileSystem.copyFile)
* deprecated the `FileSystem.sameFile()` overload accepting `file` arguments  
  (see https://chapel-lang.org/docs/1.30/modules/standard/FileSystem.html#FileSystem.sameFile)
* deprecated the option to choose between barrier types for `barrier`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/Collectives.html#Collectives.BarrierType)
* deprecated `moveInitializeArrayElements()` for new `moveArrayElements()`  
  (see https://chapel-lang.org/docs/1.30/modules/standard/MemMove.html#MemMove.moveInitializeArrayElements)
* removed the deprecated `channel` type
* removed the deprecated 'Spawn' module
* removed the deprecated pipe style constants from the 'Subprocess' module
* removed deprecated POSIX signal name constants from the 'Subprocess' module
* removed the deprecated `subprocess.send_signal()` method
* removed the integer-returning version of `bigint.invert()`

Tool Improvements
-----------------
* added `@chpldoc.nodoc` as a means of stifling `chpldoc` documentation  
  (see https://chapel-lang.org/docs/1.30/tools/chpldoc/chpldoc.html#stifling-documentation)
* added a filter to strip the `:enum:` tag in `chpldoc` output

Performance Optimizations / Improvements
----------------------------------------
* parallelized array deinitialization
* parallelized the new array `.find()` methods
* eliminated an unnecessary and non-trivial zero-initialization in `bigint`

Compilation-Time / Generated Code Improvements
----------------------------------------------
* accelerated compiler performance for `bigint`-heavy multi-locale codes
* improved compile times for codes with straightforward declared return types

Memory Improvements
-------------------
* closed memory leaks in `fileReader.mark()` and `fileWriter.mark()`

Language Specification Improvements
-----------------------------------
* merged the `sync` & `single` API docs into the language specification  
  (see https://chapel-lang.org/docs/1.30/language/spec/task-parallelism-and-synchronization.html#predefined-single-and-sync-methods)
* clarified the split-initialization behavior of `out` arguments  
  (see https://chapel-lang.org/docs/1.30/language/spec/variables.html#split-initialization)
* updated the section on re-exporting symbols to describe current behavior  
  (see https://chapel-lang.org/docs/1.30/language/spec/modules.html#re-exporting)
* added a new subsection defining procedure/iterator bodies  
  (see https://chapel-lang.org/docs/1.30/language/spec/procedures.html#the-function-body)
* improved the discussion of `yield` semantics  
  (see https://chapel-lang.org/docs/1.30/language/spec/iterators.html#the-yield-statement)
* improved the description of return intents' effects on `return`  
  (see https://chapel-lang.org/docs/1.30/language/spec/procedures.html#the-return-statement)
* clarified that records don't store array data in fields  
  (see https://chapel-lang.org/docs/1.30/language/spec/records.html#storage-allocation)
* clarified the behavior of non-promoted arguments in promoted expressions  
  (see https://chapel-lang.org/docs/1.30/language/spec/data-parallelism.html#zippered-promotion)
* added an additional example of using `param`s with generic types  
  (see https://chapel-lang.org/docs/1.30/language/spec/generics.html#parameters-in-generic-types)

Other Documentation Improvements
--------------------------------
* refreshed the GPU technical note with respect to current capabilities  
  (see https://chapel-lang.org/docs/1.30/technotes/gpu.html)
* added a new document with best practices for building on a Raspberry Pi  
  (see https://chapel-lang.org/docs/1.30/platforms/raspberrypi.html)
* moved the `weak(C)` documentation into the standard modules section  
  (see https://chapel-lang.org/docs/1.30/builtins/WeakPointer.html)
* removed the now-empty "Built-in Types and Functions" section from the docs
* clarified the location of CHPL_HOME in `make install` builds  
  (see https://chapel-lang.org/docs/1.30/usingchapel/building.html#installing-chapel)
* added a new technical note about debugging Chapel programs  
  (see https://chapel-lang.org/docs/1.30/technotes/debuggingChapel.html)
* updated the debugging documentation to mention the ability to use `lldb`  
  (see https://chapel-lang.org/docs/1.30/usingchapel/debugging.html#running-in-gdb)
* updated the `init=` technote w.r.t. compiler-generated copy initializers  
  (see https://chapel-lang.org/docs/1.30/technotes/initequals.html#the-init-method-for-non-generic-types)
* fixed the 'IO' example codes to work with strict or relaxed error handling  
  (see https://chapel-lang.org/docs/1.30/modules/standard/IO.html#i-o-overview)
* fixed other bugs, typos, and formatting issues in the documentation

Example Codes
-------------
* updated examples to reflect language and library changes

Syntax Highlighting
-------------------
* improved `vim` support to simplify customization of indentation levels

Portability / Platform-specific Improvements
--------------------------------------------
* fixed `CHPL_GMP=bundled` on recent ARM-based Macs
* improved portability for configurations using GCC 13 and clang 15
* improved the ability to find an LLVM 14 dependency on Alpine Linux 3.17

GPU Computing
-------------
* added support for generating single-locale code for one or more AMD GPUs  
  (see https://chapel-lang.org/docs/1.30/technotes/gpu.html)
* significantly improved GPU launch times by only loading the kernel once  
* improved performance by page-locking host arrays for 'array-on-device' mode
* improved performance via a loop optimization before extracting GPU kernels
* added heuristic defaults for `CHPL_GPU_CODEGEN` based on user's environment  
  (see https://chapel-lang.org/docs/1.30/technotes/gpu.html#gpu-related-environment-variables)
* enabled calling routines that access `nil` from within GPU kernels
* 'GPU' module improvements:
  - added `createSharedArray()` to support allocating block-shared memory  
    (see https://chapel-lang.org/docs/1.30/modules/standard/GPU.html#GPU.createSharedArray)
  - added `syncThreads()` to synchronize threads within a GPU block  
    (see https://chapel-lang.org/docs/1.30/modules/standard/GPU.html#GPU.syncThreads)
  - added `setBlockSize()` to configure the block size of GPU kernels  
    (see https://chapel-lang.org/docs/1.30/modules/standard/GPU.html#GPU.setBlockSize)

Compiler Improvements
---------------------
* improved parsing of first-class function types that return arrays
* added a warning for `[lo..hi]` literals to reduce the potential for confusion

Compiler Flags
--------------
* added flags to support processing attributes belonging to different tools  
  (e.g., `--warn-unknown-attribute-toolname`, `--using-attribute-toolname`)

Runtime Library Changes
-----------------------
* enabled overriding the max # of endpoints reported by the 'ofi' provider  
  (see https://chapel-lang.org/docs/1.30/platforms/libfabric.html#bound-endpoints)

Launchers
---------
* stopped using `--quiet` with `srun`/`sbatch` if `[SLURM|SBATCH]_DEBUG` is set

Error Messages / Semantic Checks
--------------------------------
* added a warning for partial instantiations that do not include `?`  
  (see https://chapel-lang.org/docs/1.30/technotes/partialInstantiations.html#creating-partial-instantiations)
* improved errors for invalid uses of `break`, `continue`, `return`, `yield`
* removed "It's us, not you" phrasing from `chpl`'s internal error messages
* improved error messages when applying multiple class memory management styles
* rephrased generic class management errors to reflect the current behavior
* added errors for iterators that yield `const`/non-lvalue expressions by `ref`
* added a compile-time error for `postinit()` routines that `throw`
* improved error messages for invalid uses of `private`
* improved an error message for indexing into a `map` of non-nilable values
* added an error when passing empty arrays to `c_ptrTo()`

Bug Fixes
---------
* fixed several bugs related to uses of labeled `break`/`continue` statements
* fixed a bug in which variable constraints of type `domain` were ignored
* fixed a bug in which tuple arguments were incorrectly passed by `ref`
* fixed a bug in which records in tuples were yielded by `ref` by default
* fixed a bug in which internal modules were stacking class memory managements
* fixed a compiler hang when reporting an error with split initialization
* fixed a problem where passing `--target-cpu` would cause a core dump
* fixed an internal error when initializing a list from an iterator
* fixed support for casts from `weak(C)` to non-nilable `shared` classes
* fixed a bug with `--memTrack` when using 'qthreads'
* re-enabled the ability to use `CHPL_HOST_MEM=jemalloc` on Macs
* fixed a mishandling of certain `export` procedures with optimization
* fixed missing LLVM sign/zero extension attributes for certain `export` procs

Bug Fixes for GPU Computing
---------------------------
* fixed a bug causing segfaults with `CHPL_GPU_MEM_STRATEGY=array_on_device`
* fixed a bug with how errors are handled in GPU codegen
* fixed a bug involving thread-block barrier syncs

Bug Fixes for Libraries
-----------------------
* fixed a divide-by-zero error for reductions over a large list
* fixed a bug in which `**` on `bigint` would always return 0
* fixed a bug in which `>>` on `bigint` gave incorrect results
* fixed a bug when subtracting `bigint` values from `int`
* fixed a bug in which `%` would crash for remote `bigint` values

Third-Party Software Changes
----------------------------
* updated the bundled version of LLVM to 14.0.6
* updated GASNet-EX to the version 2023.2.0 snapshot

Developer-oriented changes: Documentation
-----------------------------------------
* added a section on naming accessors to the Standard Module Style Guide  
  (see https://chapel-lang.org/docs/1.30/developer/bestPractices/StandardModuleStyle.html#accessors)
* updated `frontend/README` to focus on code structure and best practices

Developer-oriented changes: Syntactic / Naming Changes
------------------------------------------------------
* removed the `deprecated` keyword in favor of a new `@deprecated` attribute  
  (see https://chapel-lang.org/docs/1.30/developer/bestPractices/Deprecation.html#best-practices-deprecation)
* replaced `pragma "no doc"` with `@chpldoc.nodoc`
* renamed the 'parse' pass to 'parseAndConvertUast'
* renamed `IntentList` to `Qualifier` in 'dyno'

Developer-oriented changes: Module changes
------------------------------------------
* added prototype asynchronous communication capabilities to the GPU module
* made Chapel-specific `EEOF`, `ESHORT`, and `EFORMAT` private in 'IO' module
* refactored `bigint` routines w.r.t. how localization is implemented

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* renamed the compiler library from `liblibdyno.so` to `libChplFrontend.so`

Developer-oriented changes: Compiler Flags
------------------------------------------
* added `--use-io-formatters` to enable experimental IO format customization
* validated that the pass provided to the `--stop-after-pass` flag exists
* prohibited using the `--parse-only` and `--stop-after-pass` flags together
* added `--gpu-ptxas-enforce-optimization` for debugging optimized GPU builds

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* improved the compiler's internal representation of function types

Developer-oriented changes: 'dyno' Compiler improvements/changes
----------------------------------------------------------------
* added support for experimental `.dyno` library files
* added 'dyno' warnings/errors for:
  - `use` or `import` referring to an ambiguous module
  - multiply-defined symbols stemming from `public use`/`import`
  - module symbols that hide subroutine arguments via `use`/`import`
  - disallowed cases of relative `use`/`import`
  - attempted successive renames in `use`/`import`
  - modules referenced as though they were variables
  - referencing fields of outer classes from inner ones
  - references to `@deprecated` and `@unstable` symbols
* made numerous improvements to the 'dyno'-based scope resolver:
  - implemented shadow scopes for `use` and `private use`
  - significantly improved scope resolution within methods
  - added the ability for errors to describe where a symbol came from
  - fixed internal failures with `if var` conditionals and `coforall` loops
  - fixed detection of task-private variables
  - fixed a number of other bugs revealed in testing
* improved several aspects of 'dyno's resolution of types and calls:
  - added the ability to resolve reductions
  - added the ability to resolve task/loop intents
  - added `const` checking
  - added support for `forwarding` fields
  - added support for return-intent overloading
  - added support for handling 'ref-if-modified' types, like arrays
  - added support for default-init, copy-init, assignment, and deinit actions
  - started resolving error types in `catch` statements
* improved semantic checks for conditionals within initializers
* added support for serializing and deserializing the dyno uAST
* significantly improved the quality of the uAST dumps
* fixed dyno traces writing terminal color commands when piping to a file
* added support for computing a program's module initialization order
* fixed bugs in split-initialization and copy-elision analyses
* fixed bugs in return-type inference
* fixed the `DUMP_WHEN_CONVERTING_UAST_TO_AST` macro
* refactored uAST node `Attributes` into `AttributeGroup` and added `Attribute`

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added support for running a locale per socket on HPE Cray EX
* added support for socket-aware NIC selection on HPE Cray EX
* added the bound/unbound status of 'ofi' endpoints when using verbose output

Developer-oriented changes: Testing System
------------------------------------------
* improved the speed of parallel testing via the `paratest.*` scripts
* adjusted the `smokeTest` script to print out lines with trailing whitespace
* added a `--respect-notests` flag to the `start_test` script
* enabled `start_test` to infer `.good` filenames when using `COMPOPTS` files

Developer-oriented changes: Tool Improvements
---------------------------------------------
* fixed a bug in which using `--gdb` resulted in an infinite loop


version 1.29.0
==============

released December 15, 2022

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* compile times have been reduced for most platforms via the use of 'jemalloc'
* reduced overheads and improved scalability of creating distributed arrays
* made significant additions and improvements to the 'IO' module
* added a new compilation error framework and improved several error messages
* improved choices made by procedure overload resolution to improve usability
* added an experimental 'weak pointer' type with the goal of getting user input
* added a prototype mode to capture the generated assembly for a given routine
* made numerous renamings, deprecations, and improvements to standard modules
* fixed a number of user-reported bugs

Packaging / Configuration Changes
---------------------------------
* made our 'Dockerfile' use the current source rather than a specific release
* LLVM 14 is now required when using the LLVM back-end on a Mac OS X  
  (see https://chapel-lang.org/docs/1.29/usingchapel/prereqs.html)

Semantic Changes / Changes to the Chapel Language
-------------------------------------------------
* zippered for-loops led by unbounded ranges are now considered infinite  
  (see https://chapel-lang.org/docs/1.29/language/spec/ranges.html#iterating-over-unbounded-ranges)
* untyped formals are now preferred to those requiring implicit conversions  
  (see https://chapel-lang.org/docs/1.29/language/spec/procedures.html#better-argument-mapping)
* unary negation of `uint` now results in a compilation error for all widths  
  (see https://chapel-lang.org/docs/1.29/language/spec/expressions.html#unary-minus-operators)

Syntactic / Naming Changes
--------------------------
* renamed `makeIndexBuffer()` on domains to `createIndexBuffer()`  
  (see https://chapel-lang.org/docs/1.29/language/spec/domains.html#ChapelDomain.createIndexBuffer)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* deprecated operator-based subtype comparisons in favor of `isSubtype()`  
  (e.g., `type1 <= type2`)
* deprecated `.alignedLow`/`alignedHigh` on ranges/domains (use `.low`/`.high`)
* deprecated support for `.sorted()` and `.reverse()` on arrays
* deprecated non-functional support for the `%=` operator on `real` values
* removed deprecated operators on rectangular domains: `|`, `&`, `^`
* removed deprecated queries `isRectangularDom()`, `isAssociativeDom()`, etc.
* removed deprecated formals in domain methods, `.contains()`, `.add()`, etc.
* removed deprecated domain methods `.isSuper()`, `.isSubset()`
* removed deprecated formals in `.find()`, `.split()` on `bytes`, strings, etc.
* removed deprecated methods `.search()`/`.match[es]()` on `string`/`bytes`
* removed support for the deprecated `<~>` operator

New Features
------------
* added an experimental `weakPointer` type and module for use with `shared`  
  (see https://chapel-lang.org/docs/1.29/builtins/WeakPointer.html)
* added new prototype support for first-class procedure types/values  
  (see https://chapel-lang.org/docs/1.29/technotes/firstClassFns.html)

Feature Improvements
--------------------
* improved type inference for array literals to consider type of all elements  
  (see https://chapel-lang.org/docs/1.29/language/spec/arrays.html#rectangular-array-literals)
* improved domain methods like `expand()` to accept any integer width  
  (see https://chapel-lang.org/docs/1.29/language/spec/domains.html#ChapelDomain.expand)
* improved support for routines with generic declared return types
* improved support for concrete procedure-scoped enums
* improved how atomic types are printed  
  (e.g., `atomic bool` rather than `AtomicT(bool)`)
* added support for `throw`ing errors from legacy first-class functions

Changes / Feature Improvements in Libraries
-------------------------------------------
* added flags to make 'IO' region arguments inclusive of their bounds  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.useNewSeekRegionBounds,  
   https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.useNewOpenReaderRegionBounds,  
   https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.useNewFileReaderRegionBounds,  
  https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.useNewLinesRegionBounds,  
  and https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.useNewFileWriterRegionBounds)

Name Changes in Libraries
-------------------------
* renamed the module 'Memory.Initialization' to 'MemMove'  
  (see https://chapel-lang.org/docs/1.29/modules/standard/MemMove.html)
* split the `channel` type into separate `fileReader` and `fileWriter` types  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.fileReader)
* renamed `opentmp()` to `openTempFile()` in the 'IO' module  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.openTempFile)
* renamed `FileSystem.isLink()` to `FileSystem.isSymLink()`  
  (see https://chapel-lang.org/docs/1.29/modules/standard/FileSystem.html#FileSystem.isSymlink)
* renamed several 'FileSystem' module symbols to follow naming conventions
* renamed the `Timer` type to `stopwatch` in the 'Time' module  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Time.html#Time.stopwatch)
* renamed several 'Time' module symbols to follow naming conventions
* renamed the `_file` type to `c_FILE` in the 'CTypes' module  
  (see https://chapel-lang.org/docs/1.29/modules/standard/CTypes.html#CTypes.c_FILE)
* renamed `sourceVersion` type to `versionValue` in the 'Version' module  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Version.html#Version.versionValue)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* deprecated 'file.localesForRegion()' in the 'IO' module  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.file.localesForRegion)
* deprecated `unicodeSupported` from 'IO' because it always returned `true`  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.unicodeSupported)
* deprecated `string`/`bytes` casts to `regex` in favor of `Regex.compile()`  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Regex.html#Regex.compile)
* deprecated `copyMode()`, `getMode()`, and `chmod()` from 'FileSystem'
* deprecated `createVersion()` in favor of `new versionValue()`  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Version.html#Version.createVersion)
* removed `"version "` prefix when casting a `sourceVersion` to string  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Version.html#Version.sourceVersion)
* deprecated the 'SysBasic' module including `EEOF`, `ESHORT`, `EFORMAT`
* marked 'GPU'/'GPUDiagnostics' modules as unstable (due to still being new)
* marked `iostringstyle`, `iostringformat` as unstable in the 'IO' module
* removed the deprecated 'SysError' module and some related deprecated symbols
* removed the deprecated 'DateTime' module
* removed deprecated support for `start`/`end` arguments from 'IO' routines
* removed `tryGetPath()`, `unlink()`, and `getchunk()` from 'IO'
* removed deprecated `iohint` type from the 'IO' module
* removed deprecated formals in channel methods `.search()`, `.match()`, etc.
* removed support for deprecated formals in `regex.compile()`
* removed deprecated class `BadRegexpError`
* removed deprecated fields `.offset`, `.size` in `regexMatch`
* removed deprecated `.indexOf()`, `match()` methods on `list`
* removed deprecated `map` operators

Standard Library Modules
------------------------
* added `readAll()` methods to read the entire contents of a `fileReader`  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.channel.readAll)
* added six new overloads of `readBinary()`|`writeBinary()` for various types  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.channel.readBinary  
   and https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.fileWriter.writeBinary)
* modified `file.path` to exclusively return absolute, not relative, paths  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.file.path)
* removed unused `bool` return values from various `write*()` routines
* added new `.reset()` and `.restart()` methods to the `stopwatch` type  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Time.html#Time.stopwatch.reset  
   and https://chapel-lang.org/docs/1.29/modules/standard/Time.html#Time.stopwatch.restart)
* added a new `version` type that can be constructed/modified at run-time  
  (see https://chapel-lang.org/docs/1.29/modules/standard/Version.html#Version.version)
* 'CommDiagnostics' no longer counts communications for tracking remote tasks

Package Modules
---------------
* optimized the flushing performed in the 'CopyAggregation' module
* improved 'LinearAlgebra' support for matrices of heterogeneous array literals

Tool Improvements
-----------------
* updated `--quiet` flag for `mason run` to hide `stderr` output
* updated `c2chapel` to reflect `c_`-prefixed renamings of `ssize_t`/`size_t`
* removed the legacy version of 'chpldoc' and the `--legacy` flag

Performance Optimizations / Improvements
----------------------------------------
* optimized the creation of distributed domains and arrays
* optimized the flushing performed in the 'CopyAggregation' module
* added prototype support for dedicating a core for AM handling with 'comm=ofi'

Compilation-Time / Generated Code Improvements
----------------------------------------------
* made the compiler default to 'jemalloc' on most platforms, improving perf.  
  (see https://chapel-lang.org/docs/1.29/usingchapel/chplenv.html#chpl-host-mem)
* reduced compile time and code generated for homogeneous array literals

Documentation
-------------
* updated the sample installation commands in `prereqs.rst`  
  (see https://chapel-lang.org/docs/1.29/usingchapel/prereqs.html)
* improved the spec's rationale for, and presentation of, abstract intents  
  (see https://chapel-lang.org/docs/1.29/language/spec/procedures.html#abstract-intents)
* unified spec to use 'zippered iteration' rather than 'zipper iteration'
* merged the `owned` and `shared` API docs into the language specification  
  (see https://chapel-lang.org/docs/1.29/language/spec/classes.html#owned-objects  
   and https://chapel-lang.org/docs/1.29/language/spec/classes.html#shared-objects)
* improved uses of 'IO' features in the 'fileIO' primer  
  (see https://chapel-lang.org/docs/1.29/primers/fileIO.html)
* updated primer examples w.r.t. changes to array literals, zippering, channels
* clarified the documentation of 'AutoMath.round()'  
  (see https://chapel-lang.org/docs/1.29/modules/standard/AutoMath.html#AutoMath.round)
* added more thrown `SystemError` subclasses to 'IO' procedure documentation  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.open,  
   https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.openreader,  
   and https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.openwriter)
* added description of `EofError` cases to `fileWriter.write/ln` docs  
  (see https://chapel-lang.org/docs/1.29/modules/standard/IO.html#IO.channel.write)
* added explicit return types to some 'BigInteger' operators  
  (see https://chapel-lang.org/docs/1.29/modules/standard/BigInteger.html)
* moved Mason documentation to 'Tools' section  
  (see https://chapel-lang.org/docs/1.29/tools/mason/mason.html)
* updated Docker README to reflect Dockerfile changes and clarify usage  
  (see https://hub.docker.com/r/chapel/chapel)
* fixed broken external hyperlinks in 'BLAS' documentation  
  (see https://chapel-lang.org/docs/1.29/modules/packages/BLAS.html#BLAS.gemm, e.g.)
* fixed outdated link in the 'NetCDF' module documentation  
  (see https://chapel-lang.org/docs/1.29/tools/mason/mason.html)

Example Codes
-------------
* updated released benchmarks to avoid the use of channels (now deprecated)

Portability / Platform-specific Improvements
--------------------------------------------
* expanded target architecture modules recognized on HPE Cray systems

GPU Computing
-------------
* added prototype support for generating and building AMD GPU binary files  
  (see https://chapel-lang.org/docs/1.29/technotes/gpu.html#prototypical-amd-gpu-support)
* added a `gpuClock()` procedure to time kernel codes
* added a `debugGPU` config constant rather than tying behavior to `--verbose`
* made calls to `extern` routines ineligible for GPU execution
* marked 'GPU'/'GPUDiagnostics' modules as unstable (due to still being new)

Compiler Improvements
---------------------
* introduced a new error-reporting framework supporting improved user messages
* improved internal error messages to avoid referring to nonexistent line #s
* improved error-checking for C code within `extern` blocks

Runtime Library Changes
-----------------------
* made 'binders' the default 'qthreads' topology module
* started binding 'qthreads' shepherds to specific cores

Error Messages / Semantic Checks
--------------------------------
* made several minor improvements to parser error messages
* added a warning when inheriting from a deprecated class

Bug Fixes
---------
* fixed a bug regarding remote accesses within `export` procedures
* `param`s storing infinity or NaN will now convert to a `real` of any width  
* fixed an internal error for `forall` statements containing conditionals
* fixed an internal error when using module-qualified types within loops
* tuples containing generic types now properly have a generic type
* fixed a bug involving virtual method calls with `ref` arguments
* fixed a bug involving virtual method calls with `ref` return intents
* improved the deprecation message for `init=` on `sync` variables

Bug Fixes for Build Issues
--------------------------
* fixed `make install` bug that installed the legacy version of `chpldoc`
* fixed support for building with `gmake` version 4.4

Bug Fixes for GPU Computing
---------------------------
* fixed some compiler bugs when compiling non-GPU code w/ the GPU locale model

Bug Fixes for Libraries
-----------------------
* fixed a bug that could cause `readLine()` to terminate strings incorrectly
* fixed a bug in which argument-less `readLine()` calls would not compile
* fixed a bug with respect to `.matches()` for `regex`/`channel` on empty input
* unified behavior of `.matches()` on `channel`/`regex` for empty string regex
* fixed a bug in 'UnitTest' regarding string comparisons

Bug Fixes for Tools
-------------------
* fixed checking of `MASON_OFFLINE` for `mason install`

Platform-specific Bug Fixes
---------------------------
* added a `void` argument to some C routines to fix compilation warnings

Third-Party Software Changes
----------------------------
* updated GASNet-EX to version 2022.9.0
* added a configuration option specifying how 'qthreads' gets 'hwloc' topology

Developer-oriented changes: Documentation
-----------------------------------------
* added more details to the style guide for standard library modules  
  (see https://chapel-lang.org/docs/1.29/developer/bestPractices/StandardModuleStyle.html)
* created a list of exceptions to the style guide's capitalization rules  
  (see https://chapel-lang.org/docs/1.29/developer/bestPractices/StandardModuleStyle.html#pascalcase-and-camelcase)
* removed repeated `https://chapel-lang.org/docs/` refs in docs-building tips  
  (see https://chapel-lang.org/docs/1.29/developer/bestPractices/buildingdocs.html)
* updated documentation for `tmbundle` updates to use supported tools

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* stopped 'chpldoc' sources from contributing to 'chpl's tags/ebrowse data
* added debugging flags for 'topo' and tasking runtime layers
* quieted `doxygen` output during docs builds
* doxygen 1.8.17 is now required to make the compiler developer documentation  

Developer-oriented changes: Compiler Flags
------------------------------------------
* added `--detailed-errors` to enable new verbose/helpful error message output
* added a flag to show the generated assembly for a given Chapel routine  
  (see https://chapel-lang.org/docs/1.29/technotes/llvm.html#inspecting-the-generated-code)

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* updated parser errors to use the new 'dyno' error-reporting framework
* made `--print-passes` group compilation timings into coarser pass groups  
  (e.g., 'front-end passes')

Developer-oriented changes: 'dyno' Compiler improvements/changes
----------------------------------------------------------------
* improved the directory structure of the 'dyno' source code
* generally improved integration with the production compiler
* adjusted the uAST representation for `try` to always include a body `Block`
* addressed an issue in which parser errors could be issued twice
* made numerous improvements to 'dyno's scope resolution capabilities:
  - added support for record and class fields
  - added support for secondary methods
  - added support for nested classes and nested procedures
  - added support for `sync` statements
  - fixed problems with `require` statements
  - added proper support for the `private` keyword
  - added support for modules being discovered twice through distinct `import`s
  - fixed "undefined variable" errors when a module is imported multiple times
  - fixed failures when looking up variables inside renamed modules
  - added support for scope-resolving interfaces
  - added support for errors indicating when a module is used as a variable
* updated 'dyno' errors in scope-resolver to use the new reporting framework
* made `use` statements transitively private by default, as expected
* fixed `public use` to not bring in the module's name itself
* added support for detecting conflicting imported symbol names properly
* improved scope resolution of `except` lists in 'dyno'
* added initial support for resolving initializers
* converted several resolution/type errors to use the new error framework
* added support for enforcing type query constraints in formal arguments
* added ability to resolve operator overloads
* added ability to toggle 'dyno' asserts w/ `CHPL_DEVELOPER` or `--[no-]devel`
* made `--ignore-errors` continue compilation after a 'dyno' assertion failure
* implemented draft versions of split initialization and copy elision analysis

Developer-oriented changes: Runtime improvements
------------------------------------------------
* replaced 'sprintf()' uses with 'snprintf()' in sources

Developer-oriented changes: Platform-specific bug fixes
-------------------------------------------------------
* removed a workaround for a problem with Homebrew libc++ based on upstream fix
* added a check for erroneous OOB information for `CHPL_COMM=ofi`

Developer-oriented changes: Testing System
------------------------------------------
* enabled the ability to have a custom environment per test run

Developer-oriented changes: Tool Improvements
---------------------------------------------
* factored code from `chpl2rst.py` into `literate_chapel.py`


version 1.28.0
==============

Thirty-first public release of Chapel, September 15, 2022

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* significantly improved behavior for numerical ops on small/mixed types
* added a new 'Communication' module for performing low-level puts/gets
* expanded the idioms that can run on GPUs and added a new 'GPU' utility module
* made a number of improvements to 'chpldoc' and 'mason'
* significantly simplified and improved selection between overloaded routines
* made a large number of stabilizing language and library improvements
* modestly reduced average compilation times by using the LLVM support library
* improved portability to ARM-based Macs (e.g., M1 Macs)

Packaging / Configuration Changes
---------------------------------
* `cmake` 3.13.4 or later is now required to build Chapel  
  (see https://chapel-lang.org/docs/1.28/usingchapel/prereqs.html#readme-prereqs)
* `chpl` now requires / makes use of the LLVM support library for compilation
* added `CHPL_LLVM_SUPPORT` to specify the source of the LLVM support library  
  (see https://chapel-lang.org/docs/1.28/usingchapel/chplenv.html#chpl-llvm-support)
* made quickstart scripts use `CHPL_LLVM=system` when a good system LLVM exists  
  (see https://chapel-lang.org/docs/1.28/usingchapel/QUICKSTART.html)
* made `CHPL_MEM` default to `cstdlib` on Arm-based Macs
* 'chpldoc' now requires Python 3.7 or later

Semantic Changes / Changes to the Chapel Language
-------------------------------------------------
* updated `.low`/`.high` on strided ranges/domains to return aligned bounds  
  (see https://chapel-lang.org/docs/1.28/language/spec/ranges.html#ChapelRange.range.low  
   and https://chapel-lang.org/docs/1.28/language/spec/ranges.html#ChapelRange.range.high)
* added support for `[u]int(64)` values to implicitly convert to `real(32)`  
  (see https://chapel-lang.org/docs/1.28/language/spec/conversions.html#implicit-numeric-and-bool-conversions)
* added support for `int(w)` values to implicitly convert to `uint(w)`  
  (see https://chapel-lang.org/docs/1.28/language/spec/conversions.html#implicit-numeric-and-bool-conversions)
* improved the behavior and result types for mixed-type/-size numerical ops  
  (see https://chapel-lang.org/docs/1.28/language/evolution.html#version-1-28-september-2022)
* made `param` numerical ops better match their `var`/`const` equivalents  
  (e.g., `1:int(8) + 2` now produces `int(64)` rather than `int(8)`)  
  (see https://chapel-lang.org/docs/1.28/language/evolution.html#version-1-28-september-2022)
* improved and simplified the rules for selecting the most specific overload  
  (see https://chapel-lang.org/docs/1.28/language/spec/procedures.html#determining-most-specific-functions)
* fields with the same name as a parent class field are now disallowed  
  (see https://chapel-lang.org/docs/1.28/language/spec/classes.html#shadowing-base-class-fields)
* paren-less methods overriding ancestor fields/methods now require `override`  
  (see https://chapel-lang.org/docs/1.28/language/spec/methods.html#methods-without-parentheses)
* paren-less methods returning `type`/`param` now accept any class management  
  (see https://chapel-lang.org/docs/1.28/language/spec/classes.html#class-methods)
* code following `return`, `throw`, or `halt()` statements is now ignored  
  (see https://chapel-lang.org/docs/1.28/language/spec/procedures.html#the-return-statement,  
   https://chapel-lang.org/docs/1.28/language/spec/error-handling.html#throwing-errors,  
   and https://chapel-lang.org/docs/1.28/modules/standard/Errors.html#Errors.halt)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* marked comparison operations between types as unstable for the time being  
  (e.g., `type1 <= type2` is currently considered unstable)
* made array methods `.count()`, `.find()`, `.reverse()`, `.sorted()` unstable
* marked `locale.numPUs()` as being unstable for the time being
* deprecated assignments/initializations of `shared` classes with `owned`
* deprecated support for directly creating new borrowed class instances  
  (i.e., `new borrowed Class()` is now deprecated)
* deprecated support for the `<~>` operator  
  (see https://chapel-lang.org/docs/1.28/language/spec/statements.html#the-i-o-statement)
* deprecated `locale.callStackSize()` with no intention to replace it
* deprecated the NUMA locale model and related methods on `locale` values
* deprecated the `alignedBoundsByDefault` `config param` which has no effect  
  (see https://chapel-lang.org/docs/1.28/language/spec/ranges.html#ChapelRange.alignedBoundsByDefault)
* removed the previously deprecated `arrayIndicesAlwaysLocal` `config param`
* removed the previously deprecated `sizeReturnsInt` `config param`

New Features
------------
* added a new `@unstable` annotation to flag symbols whose behavior may evolve  
  (see https://chapel-lang.org/docs/1.28/developer/bestPractices/Unstable.html#best-practices-unstable)

Feature Improvements
--------------------
* updated the `by`/`#` operators on ranges/domains to accept any integral type  
  (see https://chapel-lang.org/docs/1.28/language/spec/ranges.html#by-operator  
   and https://chapel-lang.org/docs/1.28/language/spec/ranges.html#count-operator)
* added support for task intents on `this`  
  (see https://chapel-lang.org/docs/1.28/language/spec/data-parallelism.html#forall-intents  
   and https://chapel-lang.org/docs/1.28/language/spec/task-parallelism-and-synchronization.html#task-intents)
* updated casts from `real` to `string` to use `nan`/`inf` for those values

Changes / Feature Improvements in Libraries
-------------------------------------------
* improved memory requirements of 'IO' channel buffers for large reads/writes

Name Changes in Libraries
-------------------------
* renamed `SysError.SystemError.fromSyserr()` to `OS.createSystemError()`  
  (see https://chapel-lang.org/docs/1.28/modules/standard/OS.html#OS.createSystemError)
* renamed `SystemError` class names to use CamelCase for acronyms  
  (e.g., see https://chapel-lang.org/docs/1.28/modules/standard/OS.html#OS.IoError)
* renamed `SysBasic.syserr` to `OS.errorCode`  
  (see https://chapel-lang.org/docs/1.28/modules/standard/OS.html#OS.errorCode)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* deprecated the 'DateTime' module, merging its contents into 'Time'  
  (see https://chapel-lang.org/docs/1.28/modules/standard/Time.html)
* deprecated the 'SysError' module, moving its contents to 'OS'  
  (see https://chapel-lang.org/docs/1.28/modules/standard/OS.html)
* deprecated the 'Sys' module, moving some of its key symbols to 'OS.POSIX'  
  (see https://chapel-lang.org/docs/1.28/modules/standard/OS/POSIX.html)
* deprecated the `isFloat*()` family of queries from the 'Types' module  
  (e.g., see https://chapel-lang.org/docs/1.28/modules/standard/Types.html#Types.isFloatType)
* marked the `iostyle` type and associated routines as unstable  
  (see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.iostyle)
* deprecated some 'IO' `start`/`end` arguments in favor of `region` ranges  
  (e.g., see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.channel.seek)
* deprecated the `start`/`end` arguments of `openwriter()` in the 'IO' module  
  (see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.openwriter)
* deprecated the `iohints` type/constants in favor of a new `ioHintSet` type  
  (see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.ioHintSet)
* deprecated methods using both `iostyle` and `iohints`  
  (e.g., see see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.open)
* deprecated the `file.tryGetPath()` and `file.getchunk()` methods  
  (see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.file.tryGetPath  
   and https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.file.getchunk)
* deprecated the `IO.unlink()` routine in favor of `FileSystem.remove()`  
  (see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.unlink)
* deprecated the `bigint.fits_*_p()` methods in favor of `bigint.fitsInto()`  
  (see https://chapel-lang.org/docs/1.28/modules/standard/BigInteger.html#BigInteger.bigint.fitsInto)
* deprecated `qio_err_t`, replacing its uses with `c_int`
* removed deprecated POSIX errors and types from 'Sys' and 'SysBasic' modules
* removed the deprecated `channel.readwrite()` and `.readWriteThis()` methods
* removed deprecated `channel.itemReader()` and `.itemWriter()` methods

Standard Library Modules
------------------------
* added a new 'Communication' module for low-level put/get operations  
  (see https://chapel-lang.org/docs/1.28/modules/standard/Communication.html)
* added a new 'GPU' module for GPU-related utility and debugging features  
  (see https://chapel-lang.org/docs/1.28/modules/standard/GPU.html)
* added new 'IO' methods supporting reading/writing literals and newlines  
  (e.g., see https://chapel-lang.org/docs/1.28/modules/standard/IO.html#IO.channel.readLiteral)
* made `min()`/`max()` for `int(w)`/`uint(w)` pairs preserve width and values  
  (see https://chapel-lang.org/docs/1.28/modules/standard/AutoMath.html#AutoMath.max)
* 'CommDiagnostics' now includes more detailed `--cache-remote` counters  
  (see https://chapel-lang.org/docs/1.28/modules/standard/CommDiagnostics.html#CommDiagnostics.chpl_commDiagnostics.cache_num_prefetches)

Tool Improvements
-----------------
* wrote a new version of 'chpldoc' that leverages the 'dyno' compiler library
* made 'chpldoc' generate documentation for `operator` declarations
* improved 'chpldoc' rendering of parent modules when documenting sub-modules
* added a `--legacy` flag to 'chpldoc' to revert to the old version if needed
* extended 'mason' to support three different usage modes  
  (see https://chapel-lang.org/docs/1.28/mason-packages/start/whymason.html#the-three-modes-of-mason)
* added support for adding git repositories as 'mason' dependencies  
  (see https://chapel-lang.org/docs/1.28/mason-packages/guide/gitdependencies.html)
* added a `mason modules` command to generate command-line flags
* simplified initialization of 'mason' packages
* added a check to ensure a 'mason' package exists before adding it
* improved `mason test` errors to display relative, rather than absolute, paths

Performance Optimizations / Improvements
----------------------------------------
* improved the performance of scan operations on `Block`-distributed arrays

Compilation-Time / Generated Code Improvements
----------------------------------------------
* improved average compilation time by using LLVM data structures

Memory Improvements
-------------------
* improved memory requirements of 'IO' channel buffers for large reads/writes
* addressed a memory leak in the 'TOML' module by switching to `shared` objects

Documentation
-------------
* reworked the documentation for 'mason' to simplify navigation and clarify it  
  (see https://chapel-lang.org/docs/1.28/mason-packages/)
* added platform-specific commands for dependencies to the prerequisites doc  
  (see https://chapel-lang.org/docs/1.28/usingchapel/prereqs.html#installation)
* updated the 'Chapel Prerequisites' document to show uses of `LLVM_VERSION`  
  (see https://chapel-lang.org/docs/1.28/usingchapel/prereqs.html)
* migrated bytes/string/tuple 'Built-in Types and Functions' content into spec  
  (see https://chapel-lang.org/docs/1.28/language/spec/bytes.html#bytes-methods,  
   https://chapel-lang.org/docs/1.28/language/spec/strings.html#string-methods,  
   and https://chapel-lang.org/docs/1.28/language/spec/tuples.html#predefined-functions-and-methods-on-tuples)
* refreshed the `range` API documentation in the language specification  
  (see https://chapel-lang.org/docs/1.28/language/spec/ranges.html#predefined-routines-on-ranges)
* refreshed the `locale` documentation to reflect stabilization improvements  
  (see https://chapel-lang.org/docs/1.28/language/spec/locales.html#locale-methods)
* clarified the behavior of generic formals with `out` intent in the spec  
  (see https://chapel-lang.org/docs/1.28/language/spec/procedures.html#the-out-intent)
* fixed a bug in the 'ArgumentParser' documentation where a flag was missing  
  (see https://chapel-lang.org/docs/1.28/modules/packages/ArgumentParser.html#quickstart-example)

Example Codes
-------------
* updated `benchmarks/hpcc/ptrans.chpl` to work with small element types
* updated several example codes to use `ioHintSet`s rather than `iohints`
* updated `primers/fileIO.chpl` to replace `unlink()` with `remove()`
* updated `primers/fileIO.chpl` to use the new `region` argument for readers
* updated `EofError` capitalization in `benchmarks/shootout/revcomp-fast.chpl`
* updated `primers/classes.chpl` to avoid the use of `new borrowed C(...)`
* updated `benchmarks/shootout/knucleotide.chpl` to avoid `array.sorted()`
* specialized operator signatures in `benchmarks/shootout/mandelbrot-fast.chpl`

Portability / Platform-specific Improvements
--------------------------------------------
* generally improved Chapel portability to M1/Arm-based Macs
* improved `chplvis` such that it can run on an M1 Mac
* `chpl` now links dynamically with system LLVM and Clang libraries on Mac OS X
* improved portability to configurations using GCC 12
* worked around a known ICC bug resulting in "unknown attribute" warnings
* improved detection of system-installed Clang for Amazon Linux 2022
* removed remaining specialized support for SunOS platforms

GPU Computing
-------------
* added a new 'GPU' module for GPU-related utility and debugging features  
  (see https://chapel-lang.org/docs/1.28/technotes/gpu.html#diagnostics-and-utilities  
   and https://chapel-lang.org/docs/1.28/modules/standard/GPU.html)
* added a `gpuWrite()` routine for console output from a GPU kernel  
  (see https://chapel-lang.org/docs/1.28/modules/standard/GPU.html#GPU.gpuWrite)
* added an `assertOnGpu()` routine to ensure code is running on GPU as expected  
  (see https://chapel-lang.org/docs/1.28/modules/standard/GPU.html#GPU.assertOnGpu)
* enabled new code patterns to be eligible for execution on GPUs:
  - loops over multidimensional arrays and domains
  - 'BitOps' routines and most 'Math' routines
  - certain conditional statements
  - field accesses
* added a primitive to set the block size for a GPU kernel
* added pragmas to mark functions that should not generate/be called by kernels
* added GPU memory strategy options for `unified_memory` and `array_on_device`

Compiler Improvements
---------------------
* simplified the code generated in the C back-end for if-then-else-if chains
* raised the default generic instantiation limit from 256 to 512

Error Messages / Semantic Checks
--------------------------------
* added a new unstable warning for implicit `int`->`uint` conversions
* added an error when attempting to define methods on values rather than types  
  (e.g., `var r: R; proc r.foo() ...` now generates an error as it should have)
* added an error when using non-type expressions as formal argument types  
  (e.g., `var x: int; proc foo(y: x) ...` now generates an error as intended)
* added a warning for misleading uses of `new`  
  (e.g., `var x: borrowed MyClass = new owned MyClass();`)
* added an error when fields with runtime types cannot be default-initialized

Bug Fixes
---------
* fixed a bug in which iterating over a range yielded the wrong index type
* fixed a bug when incorrectly applying parentheses to a paren-less routine
* fixed an internal error for certain invalid `new` expressions
* fixed a bug when defining a lambda within a generic function
* fixed a bug with generic aggregate default initialization and runtime types
* fixed a bug causing compilation errors for arrays of `sortedSet`s
* fixed an inaccurate line number for errors involving method receivers
* fixed a misleading compilation error for problems running a subprocess

Bug Fixes for Build Issues
--------------------------
* fixed a bug in which `make CMAKE=...` did not impact the `cmake` command
* addressed a fragility in which the compiler build saved a path to a linker

Bug Fixes for GPU Computing
---------------------------
* fixed bugs for `locale.name`/`.numPUs` returning bad values on parent locales
* fixed a bug in which non-normalized CUDA paths were breaking certain flags

Bug Fixes for Tools
-------------------
* fixed a bug where 'chpldoc' messed up entries following `use`/`import` stmts
* fixed 'chpldoc' to render string and numerical literals as in source code
* fixed a bug in which 'chpldoc' was not rendering multi-symbol declarations
* fixed a 'chpldoc' bug in which nilable classes were mis-rendered
* fixed some 'chpldoc' bugs in which internal symbols were leaking into docs
* suppressed a `mason test` hint about using `--show` if was already in use

Platform-specific Bug Fixes
---------------------------
* fixed a bug with ABI support on Arm systems when using the LLVM back-end
* fixed `exit(0)` for `CHPL_COMM=ugni`
* fixed the memory registration address checks for `CHPL_COMM=ugni`

Third-Party Software Changes
----------------------------
* updated the bundled version of Qthreads to version 1.17
* updated the FLTK version from 1.3.5 to 1.3.8 for improved support on Mac M1
* updated the Python package versions used by 'chpldoc' as follows:
  - Babel: version 2.10.3
  - Jinja2: version 3.1.2
  - MarkupSafe: version 2.1.1
  - Pygments: version 2.12.0
  - Sphinx: version 4.5.0

Developer-oriented changes: Documentation
-----------------------------------------
* updated grep shortcuts documentation to reflect `greptests` expansion  
  (see https://chapel-lang.org/docs/1.28/developer/bestPractices/Potpourri.html#grep-shortcuts)

Developer-oriented changes: Module changes
------------------------------------------
* replaced hand-written instability warnings with the `@unstable` annotation

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* turned off LLVM assertions for `CHPL_DEVELOPER` builds
* adjusted generation of `chpl-env-gen.h` to better handle special characters

Developer-oriented changes: Compiler Flags
------------------------------------------
* updated `--dyno` to activate the 'dyno' scope resolver
* added `--warn-int-uint` to warn about implicit `int` to `uint` conversions
* added `--report-gpu-transform-time` to measure time for GPU transformations
* added `--library-cmakelists` to generate `cmake` files for a Chapel library

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* removed support for the old, pre-'dyno' parser

Developer-oriented changes: 'dyno' Compiler improvements/changes
----------------------------------------------------------------
* improved 'dyno's uAST representation
  - added `uast::ReduceIntent` for some cases that were `uast::Reduce`
  - added escaping for IDs that come from filenames
* made numerous improvements to 'dyno's scope resolution capabilities
  - added support for `this.` and `super.` in `use`/`import` statements
  - added support for `include` statements
  - added support for task intents and reduce intents
  - added support for try-catch statements
  - fixed problems when using `-M`/`--module-dir`
* made numerous improvements to 'dyno's type/call resolution capabilities
  - added support for resolving enums, conditional expressions, and ranges
  - added support for resolving loop index variables and param for-loops
  - added support for resolving varargs argument lists
  - added support for evaluating `==` and `!=` on types
  - improved support for evaluating `param` conditionals and expressions  
    (e.g., `1+1` is now resolved to be a `param` whose value is `2`)
  - significantly improved return type inference
  - improved support for rejecting invalid overload candidates
  - fixed problems when resolving declarations with both a type and initializer
  - fixed several problems with generic records with defaults
  - fixed a segmentation fault when resolving `extern` routines
* improved integration with the production compiler
  - can now convert from resolved uAST to production compiler `SymExpr`s
  - migrated many semantic checks from the production parser to 'dyno'
  - migrated file system capabilities to 'dyno' functions using LLVM libraries
  - migrated implicit module warnings to 'dyno'
* used LLVM data types to improve performance of parsing and scope resolution
* improved the query trace output format and filtering capabilities

Developer-oriented changes: Runtime improvements
------------------------------------------------
* removed setting of `LANG` variables in launchers via `env` (no longer needed)
* fixed support for `ofi`'s `FI_MR_PROV_KEY` registration mode to improve perf

Developer-oriented changes: Testing System
------------------------------------------
* refreshed the Python package versions used by `start_test`
* updated nightly testing jobs to display the Python version used


version 1.27.0
==============

Thirtieth public release of Chapel, June 30, 2022

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* improved GPU support, including enabling the use of multiple locales
* improved namespace behavior w.r.t. `import`, `use`, and shadowing
* the Chapel compiler now supports LLVM 14, in addition to 11, 12, and 13
* improved the performance and scalability of scan operations on `Block` arrays
* added new 'OS.POSIX' and 'GPUDiagnostics' modules
* restored support for Omni-Path networks
* the new 'dyno' parser and AST are now used by default when compiling
* introduced a Code of Conduct for Chapel developers
* made many changes, mostly minor, in support of stabilizing Chapel features
* many other bug fixes and improvements to error messages and documentation

Packaging / Configuration Changes
---------------------------------
* the compiler's LLVM back-end now supports version 14 as well as 11, 12, 13
* made Chapel available as an Arch Linux AUR package  
  (see https://aur.archlinux.org/packages/chapel)
* updated `configure` to create prefix directories if they don't already exist
* `make install` now installs `chpldoc` if it is built

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* made small integers prefer coercions to `real(32)` over `real(64)`  
  (see https://chapel-lang.org/docs/1.27/language/spec/conversions.html#implicit-numeric-and-bool-conversions)
* made `public use` and `import` statements no longer introduce a hidden scope  
  (see https://chapel-lang.org/docs/1.27/language/spec/modules.html#using-and-importing)
* made `public use M` no longer bring in the name `M` for qualified access  
  (see https://chapel-lang.org/docs/1.27/language/spec/modules.html#public-and-private-use-statements)
* changed methods such that they are no longer subject to shadowing  
  (see https://chapel-lang.org/docs/1.27/language/spec/procedures.html#determining-more-specific-functions)
* made loops over unbounded enum/bool ranges stop at their extreme values
* made serial loops over unbounded integer ranges terminate instead of spinning
* byte-based string slicing now throws when not aligned to codepoint boundaries

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* `.low`/`.high` on strided ranges now warn about pending behavioral changes  
  (see https://chapel-lang.org/docs/1.27/language/spec/ranges.html#ChapelRange.range.low)
* marked `.equals()` on arrays as being unstable
* removed deprecated support for `.front()`/`.back()` on arrays
* removed support for bracket-less anonymous associative domains

New Features
------------
* added new `.lowBound`/`.highBound` queries on ranges to get "pure" bounds  
  (e.g., `(1..10 by 2).highBound` returns `10`)  
  (see https://chapel-lang.org/docs/1.27/language/spec/ranges.html#ChapelRange.range.lowBound)
* added an `alignedBoundsByDefault` config to opt into new `.low`/`.high` defs  
  (see https://chapel-lang.org/docs/1.27/language/spec/ranges.html#ChapelRange.alignedBoundsByDefault)

Feature Improvements
--------------------
* `param` indexing of `string` and `bytes` values is now done at compile-time
* changed one-tuples to print out as `(10,)` rather than `(10)` by default

Namespace Changes
-----------------
* made internal module names not visible to Chapel programs by default

Changes / Feature Improvements in Libraries
-------------------------------------------
* updated `.mod()`/`%` behavior for `bigint`s to match `mod()`/`%` for `int`s  
  (see https://chapel-lang.org/docs/1.27/modules/standard/BigInteger.html#BigInteger.bigint.mod)
* improved `readLine` to return bytes read, throw errors, strip newlines, etc.  
  (see https://chapel-lang.org/docs/1.27/modules/standard/IO.html#IO.channel.readLine)

Name Changes in Libraries
-------------------------
* renamed `[channel.]readline()` to `[channel.]readLine()`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/IO.html#IO.channel.readLine)
* renamed `channel.isclosed()` to `channel.isClosed()`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/IO.html#IO.channel.isClosed)
* renamed `timedelta.total_seconds()` with `timedelta.totalSeconds()`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/DateTime.html#DateTime.timedelta.totalSeconds)
* renamed a number of other symbols in 'DateTime' to use preferred camelCasing
* renamed the `pattern` argument to `sep` in `.split()` on `string`/`bytes`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Regex.html#Regex.string.split)

Deprecated / Unstable / Removed Library Features
------------------------------------------------
* stopped making the contents of the 'Math' module available by default  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Math.html)
* deprecated support for `+`, `-`, `&`, `|`, and `^` on map
* deprecated `list.extend()` in favor of new `list.append()` overloads
* deprecated `.search()` on `string`/`bytes` in favor of `.find()  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Regex.html#Regex.string.find)
* deprecated `.matches()` on `string`/`bytes` in favor of `.startsWith()`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Regex.html#Regex.string.startsWith)
* deprecated `datetime.today()` in favor of `datetime.now()`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/DateTime.html#DateTime.datetime.now)
* deprecated `datetime.timeSinceEpoch()` in favor of `timeSinceEpoch()`  
  (see https://chapel-lang.org/docs/1.27/modules/standard/DateTime.html#DateTime.timeSinceEpoch)
* deprecated `datetime - date` in favor of `datetime - datetime`
* marked timezones as being unstable in the 'DateTime' module
* deprecated support for `.readWriteThis()` methods  
  (see https://chapel-lang.org/docs/1.27/modules/standard/ChapelIO.html#the-readthis-writethis-and-readwritethis-methods)
* deprecated the `channel.itemReader` and `channel.itemWriter` methods  
  (see https://chapel-lang.org/docs/1.27/modules/standard/IO.html#IO.ItemReader)
* deprecated `channel.write()`
* deprecated support for 'Sys'/'SysBasic' symbols now supported by 'OS.POSIX'
* deprecated the 'VectorizingIterator' module
* removed the deprecated 'ChapelEnv', 'CPtr', and 'SysCTypes' modules
* removed deprecated 'SysBasic' features
* removed deprecated `size_t`/`ssize_t` type aliases
* removed the deprecated `set.isIntersecting()` method
* removed deprecated set methods that used `x` as argument names

Standard Library Modules
------------------------
* added a new 'OS.POSIX' module that exposes POSIX capabilities  
  (see https://chapel-lang.org/docs/1.27/modules/standard/OS/POSIX.html)
* moved available-by-default math features into a new 'AutoMath' library  
  (see https://chapel-lang.org/docs/1.27/modules/standard/AutoMath.html and  
  https://chapel-lang.org/docs/1.27/modules/standard/Math.html)
* added a new 'GPUDiagnostics' module for tracking GPU kernel launches  
  (see https://chapel-lang.org/docs/1.27/modules/standard/GPUDiagnostics.html)
* added new `fillRandom()` routines to 'Random' that accept min/max bounds  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Random.html#Random.fillRandom  
   and https://chapel-lang.org/docs/1.27/modules/standard/Random/PCGRandom.html#PCGRandom.PCGRandomStream.fillRandom)
* ensured all types have separate `isXType`, `isXValue`, and `isX` routines  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Types.html)
* added a 'defaultHashTableResizeThreshold' config to affect hash table growth  
  (see https://chapel-lang.org/docs/1.27/language/spec/domains.html#ChapelDomain.defaultHashTableResizeThreshold)
* made `bigint.invert()` throw `InversionError` when an inverse is undefined  
  (see https://chapel-lang.org/docs/1.27/modules/standard/BigInteger.html#BigInteger.bigint.invert )

Tool Improvements
-----------------
* added a hint to use `--show` when `mason test` compilations fail
* fixed a bug in which `make install` was no longer installing `mason`

Performance Optimizations / Improvements
----------------------------------------
* improved the performance and scalability of scan operations on `Block` arrays
* optimized the swap operator for `string`/`bytes` types

Platform-specific Performance Optimizations / Improvements
----------------------------------------------------------
* reduced memory consistency overhead for `CHPL_COMM=ofi` w/ the 'cxi' provider

Documentation
-------------
* added a Chapel module index to the documentation sidebar  
  (see https://chapel-lang.org/docs/1.27/chpl-modindex.html)
* added documentation for getting started with `mason`  
  (see https://chapel-lang.org/docs/1.27/tools/mason/mason.html#using-a-mason-package)
* updated the installation instructions for `mason`  
  (see https://chapel-lang.org/docs/1.27/tools/mason/mason.html#installation-instructions)
* merged 'Built-in Types and Functions' docs for ranges into the language spec  
  (see https://chapel-lang.org/docs/1.27/language/spec/ranges.html#predefined-routines-on-ranges)
* clarified integer overflow in the language specification  
  (see https://chapel-lang.org/docs/1.27/language/spec/types.html#signed-and-unsigned-integral-types  
   and https://chapel-lang.org/docs/1.27/language/spec/ranges.html#iterating-over-ranges)
* made the spec recommend `c_array` for interoperating with fixed-size C arrays  
  (see https://chapel-lang.org/docs/1.27/language/spec/interoperability.html#referring-to-external-c-types)
* documented the 'protobuf' support package, 'ProtobufProtocolSupport'  
  (see https://chapel-lang.org/docs/1.27/modules/packages/ProtobufProtocolSupport.html)
* added missing return types to `.size`, `.sizeAs`, and `.shape` on arrays  
  (see https://chapel-lang.org/docs/1.27/language/spec/arrays.html#ChapelArray.size  
   and https://chapel-lang.org/docs/1.27/language/spec/arrays.html#ChapelArray.shape)
* fixed other typos, mistakes, and formatting throughout the documentation

Build System Improvements
-------------------------
* specialized build directories by LLVM version to keep from mixing versions
* improved checks and error messages for missing LLVM dependencies

Portability
-----------
* restored support for Omni-Path (OPA) networks  
  (see https://chapel-lang.org/docs/1.27/platforms/omnipath.html)
* improved portability to Alpine Linux
* renamed internal type to support compatibility with AMD's math library
* improved support for packaging scenarios that delete libtool's `.la` files
* fixed link problems when clang defaults to position-independent executables
* improved code portability with respect to gcc 12 and clang 14 warnings

GPU Computing
-------------
* enabled GPU computing using multiple locales  
  (see https://chapel-lang.org/docs/1.27/technotes/gpu.html#multi-locale-support)
* added a new 'GPUDiagnostics' module for tracking kernel launches  
  (see https://chapel-lang.org/docs/1.27/modules/standard/GPUDiagnostics.html)
* extended 'Memory.Diagnostics' to support tracking GPU-based allocations  
  (see https://chapel-lang.org/docs/1.27/modules/standard/Memory/Diagnostics.html)
* nested block statements and tuples are now supported for GPU kernels
* removed support for the CPU sublocale, relying on the locale itself for that
* addressed a number of GPU portability / stability issues  
  (see 'Bug Fixes for GPU Computing' below)

Compiler Improvements
---------------------
* updated the compiler to support LLVM version 14 (in addition to 11, 12, 13)
* switched the compiler's front-end to use the 'dyno' parser/uAST by default

Launchers
---------
* added prototype support for overriding launcher job names

Error Messages / Semantic Checks
--------------------------------
* improved the order and number of resolution candidates printed in errors
* added an error about `foreach` loops not supporting task intents yet
* improved the printing of call stacks with operator methods in errors
* improved the error message for unrecognized `this` types on initializers
* added a warning when a module path for `import` starts with `super.this`
* added an error message for certain illegal generic class coercions
* stabilized an error message when calling an otherwise unused module

Bug Fixes
---------
* fixed a bug in which certain returned expressions were evaluated twice
* fixed a parse-time memory bug for deeply nested `if`-`then`-`else` loops
* fixed an internal error with respect to generic nilable classes
* fixed a bug where EOF errors were not thrown for `channel.read()` methods
* fixed a bug where qualified accesses failed to trigger deprecation warnings
* fixed a bug preventing `import super.super` or similar `import` statements
* fixed a bug where private submodules were incorrectly treated as candidates
* fixed bugs relating to function shadowing and/or point-of-instantiation
* fixed a bug with `var x = nil;`
* fixed a bug preventing `try!` expressions in `yield` statements
* fixed a bug in which scans of default slices of Block arrays didn't compile
* fixed a bug in which `--version` wasn't printing BUILD_VERSION when non-zero

Bug Fixes for Build Issues
--------------------------
* fixed a path error for `CHPL_LLVM=bundled` when `CC` is set

Bug Fixes for GPU Computing
---------------------------
* fixed a bug preventing GPU compilation with LLVM versions greater than 13
* fixed a bug with CUDA 10.1 that prevented GPU initialization
* fixed a bug causing an 'unresolved extern' warning during compilation
* fixed a bug with iterating over associative domains
* suppressed CUDA version warnings for those that are newer than clang supports

Bug Fixes for Tools
-------------------
* fixed a `mason test` error when code output includes a line ending with `)`
* fixed a bug where the `build` flag had no effect on `mason run --example`

Platform-specific Bug Fixes
---------------------------
* fixed an initialization race with `CHPL_COMM=ofi` on InfiniBand systems

Third-Party Software Changes
----------------------------
* updated the bundled version of LLVM to version 14
* updated GASNet-EX to version 2022.3.0
* updated the Sphinx Chapel domain version used for `chpldoc`

Developer-oriented changes: Process
-----------------------------------
* introduced a Code of Conduct for Chapel developers  
  (see https://github.com/chapel-lang/chapel/blob/main/CODE_OF_CONDUCT.md)

Developer-oriented changes: Documentation
-----------------------------------------
* extended the documentation of the `deprecated` keyword with examples  
  (see https://chapel-lang.org/docs/1.27/developer/bestPractices/Deprecation.html#examples)
* changed a few 'compiler/next' references to 'compiler/dyno'

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* added new error messages when building an invalid runtime configuration
* reduced the reliance on `CHPL_HOME` when running `make docs`

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* added a pragma to exempt specific functions from the instantiation limit

Developer-oriented changes: 'dyno' Compiler improvements/changes
----------------------------------------------------------------
* made numerous fixes to 'dyno' to get the parser to pass all of our tests
* migrated setting of 'config' variables to be handled entirely within 'dyno'
* added token counting and code size statistics to 'dyno'
* significantly improved resolution, including support for fields
* added a prototype capability to use the 'dyno' resolver when running `chpl`
* added indentation and formatting to CHPL_SYNTAX-style uAST node dumps
* removed support for recursive queries in favor of simply detecting recursion
* enabled 'dyno' to find internal modules
* made 'dyno' now automatically add `use ChapelStandard`
* removed `uast::Expression` and improved the spelling of several type names
* fixed problems running `make test-dyno` on Mac OS X


version 1.26.0.1
================

This version is a slight variation on the 1.26.0 release containing a
late-breaking bug fix that is specific to `CHPL_COMM=ofi` when using the
'cxi' provider.


version 1.26.0
==============

Twenty-ninth public release of Chapel, March 31, 2022

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* updated the Chapel compiler to support LLVM versions 11, 12, and 13
* added a prototype ability to resize arrays of elements without default values
* made stabilizing improvements to methods on ranges, domains, and arrays
* added new 'CopyAggregation', 'Socket', and 'Channel' package modules
* made stabilizing improvements to several standard library module interfaces
* improved the portability, robustness, and performance of `ofi` communication
* expanded the generality of Chapel's ability to generate code for GPUs
* added a new script for displaying available runtime configurations
* many other bug fixes and improvements to error messages and documentation

Packaging / Configuration Changes
---------------------------------
* the Chapel compiler's LLVM back-end now supports versions 11, 12, and 13
* when multiple supported LLVM versions are found, the latest one is chosen
* updated error message when unable to find LLVM to list the supported versions
* UTF-8 support no longer depends on the `LANG` environment variable  
  (see https://chapel-lang.org/docs/1.26/usingchapel/chplenv.html#character-set)
* removed support for the deprecated `CHPL_REGEXP` environment variable
* added an error when using `CHPL_LLVM=none` with `CHPL_TARGET_COMPILER=llvm`
* `CHPL_LLVM_GCC_PREFIX` can now be set in a `chplconfig` file  
  (see https://chapel-lang.org/docs/1.26/usingchapel/chplenv.html#chpl-llvm)

Syntactic / Naming Changes
--------------------------
* extended the set of statement types to which `try`/`try!` can be applied

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* top-level modules defined in files on `chpl`'s command-line are now init'ed  
  (see https://chapel-lang.org/docs/1.26/language/spec/modules.html#module-initialization)
* enabled implicit conversions from non-nilable to nilable for type arguments  
  (see https://chapel-lang.org/docs/1.26/language/spec/procedures.html#legal-argument-mapping)
* `.indices` queries on rectangular arrays now return a local domain of indices  
  (see https://chapel-lang.org/docs/1.26/language/spec/arrays.html#ChapelArray.indices)
* `.size`/`.shape` queries on ranges, domains, arrays now return `int` values  
  (see https://chapel-lang.org/docs/1.26/builtins/ChapelRange.html#ChapelRange.range.size,  
   https://chapel-lang.org/docs/1.26/language/spec/domains.html#ChapelDomain.size, and  
   https://chapel-lang.org/docs/1.26/language/spec/domains.html#ChapelDomain.shape, etc.)
* stopped auto-creating `hash()` methods for records w/ custom `==`/`!=` ops  
  (see https://chapel-lang.org/docs/1.26/language/spec/records.html#hashing-a-record)
* made it an error to overload return intents for the `enterThis()` method  
  (see https://chapel-lang.org/docs/1.26/language/spec/statements.html#the-manage-statement)

New Features
------------
* added support for listing operators in `only`, `except`, and `import`  
  (see https://chapel-lang.org/docs/1.26/language/spec/modules.html#using-modules  
   and https://chapel-lang.org/docs/1.26/language/spec/modules.html#importing-modules)
* added an `unsafeAssign()` method and context manager to domains  
  (see https://chapel-lang.org/docs/1.26/language/spec/domains.html#ChapelDomain.unsafeAssignManager)
* added support for renaming `extern type` declarations  
  (e.g., `extern "c_name" type chpl_name = ...;`  
   see also https://chapel-lang.org/docs/1.26/language/spec/interoperability.html#referring-to-external-c-types)

Feature Improvements
--------------------
* extended hash-based collections to support values of range/array type
* improved support for core operations across rectangular array implementations

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* deprecated support for `|`, `&`, and `^` on rectangular domains
* deprecated `domain.isSuper()` and `.isSubset()` for `domain.contains()`
* deprecated support for arrays over brace-less anonymous associative domains  
  (e.g., in `var A: ["red", "green", "blue"] real;`, braces are now required)
* deprecated support for `ChapelEnv`/`ChplConfig.CHPL_AUX_FILESYS`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/ChplConfig.html#ChplConfig.CHPL_AUX_FILESYS)
* removed deprecated support for `use <Mod> except *;`
* removed deprecated support for operators declared using the `proc` keyword
* removed all remaining vestiges of the `atomic` statement

Name Changes in Libraries
-------------------------
* renamed C type aliases `size_t`/`ssize_t` to `c_size_t`/`c_ssize_t`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/CTypes.html#CTypes.c_size_t)
* renamed search arguments `needle`->`pattern` and `region`->`indices`  
  (see https://chapel-lang.org/docs/1.26/builtins/Bytes.html,  
   https://chapel-lang.org/docs/1.26/builtins/String.html,  
   and https://chapel-lang.org/docs/1.26/modules/standard/Regex.html)
* renamed `regexMatch.offset` to `.byteOffset` and `.size` to `.numBytes`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Regex.html#Regex.regexMatch)
* renamed `captures`/`maxmatches` args in 'Regex' to `numCaptures`/`maxMatches`
* renamed the `list.indexOf()` method to `list.find()`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/List.html#List.list.indexOf)
* renamed several `set` method arguments from `x` to `element`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Set.html)
* changed the formal names in the `Reflection.getField()` family of functions  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Reflection.html#Reflection.getFieldName)
* renamed `Subprocess.send_signal()` to `Subprocess.sendPosixSignal()`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Subprocess.html#Subprocess.subprocess.sendPosixSignal)
* changed 'Subprocess' pipe styles from a set of constants to an `enum`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Subprocess.html#Subprocess.pipeStyle)
* improved the names of many routines and arguments in the 'BigInteger' module  
  (see https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html)
  - renamed `bigint.mpzStruct()` to `bigint.getImpl()`
  - renamed `bigint.get_d_2exp()` to `bigint.getD2Exp()`
  - renamed `bigint.divisible_p()` to `bigint.isDivisible()`
  - renamed `bigint.divisible_2exp_p()` to `bigint.isDivisibleBy2Pow()`
  - renamed `bigint.congruent_p()` to `bigint.isCongruent()`
  - renamed `bigint.congruent_2exp_p()` to `bigint.isCongruentBy2Pow()`
  - renamed `bigint.perfect_power_p()` to `bigint.isPerfectPower()`
  - renamed `bigint.perfect_square_p()` to `bigint.isPerfectSquare()`
  - renamed `bigint.probab_prime_p()` to `bigint.probablyPrime()`
  - renamed `bigint.gcdext()` to new `bigint.gcd()` overload
  - renamed `bigint.remove()` to `bigint.removeFactor()`
  - renamed `bigint.even_p()` to `bigint.isEven()`
  - renamed `bigint.odd_p()` to `bigint.isOdd()`
  - renamed arguments of `bigint.divexact()` to `numer` and `denom`
  - renamed argument of `bigint.isDivisible()` from `d` to `div`
  - renamed argument of `bigint.isDivisibleBy2Pow()` from `b` to `exp`
  - renamed arguments of `bigint.isCongruent()` to `con` and `mod`
  - renamed arguments of `bigint.isCongruentBy2Pow()` to `con` and `modExp`
  - renamed argument of `bigint.scan0()` and `bigint.scan1()` to `startBitIdx`

Deprecated / Removed Library Features
-------------------------------------
* deprecated the automatic 'ChapelEnv' module for 'ChplConfig'  
  (see https://chapel-lang.org/docs/1.26/modules/standard/ChplConfig.html)
* deprecated C type aliases defined in modules other than 'CTypes'  
  (see https://chapel-lang.org/docs/1.26/modules/standard/SysCTypes.html,  
   and https://chapel-lang.org/docs/1.26/modules/standard/CPtr.html)
* deprecated `set.isIntersecting()`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Set.html#Set.set.isIntersecting)
* deprecated binary conversion format strings in `FormattedIO.readf`/`writef`
* deprecated the `iostyle` record in the 'IO' module
* deprecated the `stringStyle*()` family of routines in the 'IO' module
* deprecated `defaultIOStyle()` in 'IO' module
* deprecated `style: iostyle` arguments from routines in 'IO', 'URL', 'Path'
* deprecated `Error` subclass `BadRegexpError` from the 'Regex' module
* deprecated support for the `vectorizeOnly()` iterator  
  (see https://chapel-lang.org/docs/1.26/modules/standard/VectorizingIterator.html#VectorizingIterator.vectorizeOnly)
* removed non-working `string.search()`/`bytes.search()` routines from 'Regex'
* removed deprecated methods on the `file` type from the 'Path' module
* removed deprecated 'Regexp' module
* removed deprecated `regexp` type from the 'Regex' module
* removed deprecated `RecordReader` initializer with `mRegexp` argument
* removed deprecated `RecordReader.createRegexp()` method from 'RecordParser'
* removed deprecated `CHPL_REGEXP` param from 'ChplConfig' module
* removed support for the previously deprecated `range.ident()` method
* removed deprecated forms of `warning()` and `halt()`

Standard Library Modules
------------------------
* added a new 'CTypes' module that defines Chapel aliases for C types  
  (see https://chapel-lang.org/docs/1.26/modules/standard/CTypes.html)
* added optional arguments to `set` initializers for more control over resizing  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Set.html#Set.set)
* added an overload of `map.getValue()` that accepts a sentinel value  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Map.html#Map.map.getValue)
* changed `map.getValue()` to `throw` rather than halting  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Map.html#Map.map.getValue)
* enabled casts from integral types to `c_void_ptr`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/CTypes.html#CTypes.c_void_ptr)
* enabled `min()`/`max()` routines to be promoted using array arguments
* added `subprocess.abort()` and `subprocess.alarm()` to 'Subprocess'  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Subprocess.html#Subprocess.subprocess.abort  
   and https://chapel-lang.org/docs/1.26/modules/standard/Subprocess.html#Subprocess.subprocess.alarm)
* updated `Math.cproj()` to return a `complex` rather than `real` value  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Math.html#Math.cproj)
* added support for a standalone (channel-less) `IO.readline()` routine  
  (see https://chapel-lang.org/docs/1.26/modules/standard/IO.html#IO.readline)
* updated `bigint.probablyPrime()` to return a new enum `BigInteger.primality`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.primality  
  and https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint.probablyPrime)
* swapped the order of the values returned from `bigint.getD2Exp()`  
  (see https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint.getD2Exp)

Package Modules
---------------
* added a new 'CopyAggregation' module supporting aggregated copies  
  (see https://chapel-lang.org/docs/1.26/modules/packages/CopyAggregation.html)
* added a new 'Socket' package module to support network programming  
  (see https://chapel-lang.org/docs/1.26/modules/packages/Socket.html)
* added a new 'Channel' package module to support communicating between tasks  
  (see https://chapel-lang.org/docs/1.26/modules/packages/Channel.html)
* changed the 'TOML' package to sort keys when writing them out  
  (see https://chapel-lang.org/docs/1.26/modules/packages/TOML.html)

Tool Improvements
-----------------
* added a new script for displaying available runtime configurations  
  (see `$CHPL_HOME/util/chplenv/printchplbuilds.py`)

Performance Optimizations / Improvements
----------------------------------------
* significantly improved fine-grained communication on Slingshot-11 networks
* made promotions with slices more efficient with `-schpl_serializeSlices=true`

Memory Improvements
-------------------
* fixed a memory leak for `set.add()` in the 'Set' module
* eliminated a minor amount of memory allocated/freed when iterating over types

Documentation
-------------
* added documentation to the language specification for the `manage` statement  
  (see https://chapel-lang.org/docs/1.26/language/spec/statements.html#the-manage-statement)
* merged domain/array 'Built-in Types and Functions' content into language spec  
  (see https://chapel-lang.org/docs/1.26/language/spec/domains.html#module-ChapelDomain  
   and https://chapel-lang.org/docs/1.26/language/spec/arrays.html#module-ChapelArray)
* improved the definition of 'subtype' in the language specification  
  (see https://chapel-lang.org/docs/1.26/language/spec/conversions.html#implicit-subtype-conversions
* updated GPU technote to expand on currently known limitations  
  (see https://chapel-lang.org/docs/1.26/technotes/gpu.html)
* added chapter groupings to the language specification  
  (see https://chapel-lang.org/docs/1.26/language/spec/)
* grouped package modules by topic  
  (see https://chapel-lang.org/docs/1.26/modules/packages.html)
* added documentation for many methods in the 'BigInteger' module  
  (see https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html)
* stopped documenting the `bigint.mpz` field  
  (see https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint)
* improved the description of `c_void_ptr` in the 'Ctypes' documentation  
  (see https://chapel-lang.org/docs/1.26/modules/standard/CTypes.html#CTypes.c_void_ptr)
* documented which elements are preserved in `set` operations with overlap  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Set.html)
* added a link to the online documentation index at the bottom of its sidebar  
  (see https://chapel-lang.org/docs/1.26/)
* added documentation for the `CHPL_LLVM_GCC_PREFIX` environment variable  
  (see https://chapel-lang.org/docs/1.26/usingchapel/chplenv.html#chpl-llvm)

Example Codes
-------------
* updated the special methods primer to reflect when `hash()` methods are added  
  (see https://chapel-lang.org/docs/1.26/primers/specialMethods.html)
* updated the interoperability primer to make use of the new 'CTypes' module  
  (see https://chapel-lang.org/docs/1.26/primers/interopWithC.html)
* updated the list primer to reflect the new `.find()` method  
  (see https://chapel-lang.org/docs/1.26/primers/listOps.html)
* updated various `benchmarks` codes to use the new 'ChplConfig' module
* updated `benchmarks/lcals/` to reduce usage of `vectorizeOnly()` (deprecated)
* removed `benchmarks/ssca2/` due to its use of old styles and lack of upkeep
* removed `patterns/recordio.chpl` due to its use of `iostyle` (now deprecated)

Portability
-----------
* fixed problems finding a system library when a bundled one was requested
* improved portability of Chapel on FreeBSD and Alpine Linux
* addressed issues on a variety of platforms when using `system` LLVM packages
* enabled pip dependencies to be built from source with `CHPL_PIP_FROM_SOURCE`
* made `chpldoc` compatible with Python 3.10
* improved integration of `CHPL_COMM=ofi` with HPE Cray EX workload managers
* implemented several other portability improvements for `CHPL_COMM=ofi`

GPU Computing
-------------
* enabled calls to simple functions from GPU kernels  
  (see https://chapel-lang.org/docs/1.26/technotes/gpu.html#overview)
* added support for executing promoted expressions on GPUs
* added support for using multiple GPUs in one node
* added primitive to synchronize GPU threads
* added primitive to statically allocate GPU block shared memory
* fixed sporadic issue causing illegal memory access
* fixed bug where `forall` loops executed serially for the GPU locale model
* fixed a bug with 0-size allocations in GPU memory
* fixed a bug with repeatedly-used symbols in loop bodies executed on GPUs
* added an error when `CHPL_LOCALE_MODEL=gpu` and `CHPL_COMM!=none`
* added warnings for using an incompatible target compiler

Compiler Improvements
---------------------
* updated the compiler to support LLVM versions 12 and 13 (in addition to 11)  
  (see https://chapel-lang.org/docs/1.26/usingchapel/prereqs.html#chapel-prerequisites  
   and https://chapel-lang.org/docs/1.26/usingchapel/chplenv.html#readme-chplenv-chpl-llvm)

Runtime Library Changes
-----------------------
* made several portability and robustness improvements to `CHPL_COMM=ofi`
* stopped `ofi` from making a fixed heap when no provider could use it

Error Messages / Semantic Checks
--------------------------------
* added an error when applying `override` to a non-method
* added single quotes around values and types in overflow errors for ints/bytes
* improved error messages for `|=`, `&=`, and `^=` on rectangular domains
* added an error when trying to create sparse non-rectangular domains
* added an error for `==` and `!=` between domains of differing kinds
* improved error messages for certain unsupported domain operations
* improved error messages for calling `min`/`max(type t)` on unsupported types
* updated error message in `realPath()` to better reflect its interface  
  (see https://chapel-lang.org/docs/1.26/modules/standard/Path.html#Path.realPath)
* added checks for division by 0 to `bigint` division methods  
  (see https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint.divexact,  
  https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint.divQ,  
  https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint.divR,  
  https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint.divQR,  
  https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint./,  
  and https://chapel-lang.org/docs/1.26/modules/standard/BigInteger.html#BigInteger.bigint./=)

Bug Fixes
---------
* fixed a compiler bug causing incorrect results for dynamic dispatch
* fixed several problems with error handling in the context of parallel loops
* fixed a bug preventing `const in` task intents from being used with arrays
* fixed a bug when calling `.localSlice()` on a slice of a default array
* fixed a bug in which `require "M.chpl";` was ignored within implicit modules 
* fixed a potential issue with arbitrary shell commands in `require` statements
* fixed a bug in which first-class functions failed to retain return intents
* fixed a problem with combinations of `const ref`, `owned`, and `coforall`
* fixed the naming of `CHPL_` variables in the output of `chpl --help-env`
* fixed a bug that caused sporadic problems  with the `--memLog` flag
* added a remote cache fence to barrier calls
* fixed a bug with overload sets and operators

Bug Fixes for Build Issues
--------------------------
* enabled building with GPU support for host compilers other than `clang`

Bug Fixes for Libraries
-----------------------
* fixed a bug with `bigint.removeFactor()` when `fac` is `0`

Third-Party Software Changes
----------------------------
* updated the bundled copy of LLVM and clang to version 13
* updated the bundled copy of `libfabric` to version 1.13.2
* updated the version of Sphinx used for `chpldoc` to 4.3.2
* updated the Sphinx Chapel domain version used for `chpldoc` to 0.0.21
* updated the breathe version used for `chpldoc` to 4.31.0

Developer-oriented changes: Process
-----------------------------------
* trailing whitespace is now flagged in CI using GitHub actions

Developer-oriented changes: Documentation
-----------------------------------------
* removed references to outdated files from the `chplspell` documentation
* fixed the path to 'ChapelIO' in 'How To Generate Warnings And Error Messages'

Developer-oriented changes: Naming Changes
------------------------------------------
* coined the name 'dyno' to refer to aspects of the compiler rewrite effort

Developer-oriented changes: Module changes
------------------------------------------
* simplified the barrier used to initialize locales
* added `iostyleInternal` type for use when `iostyle` is required by developers

Developer-oriented changes: Makefile / Build-time changes
---------------------------------------------------------
* adjusted the unique build paths for `hwloc` and `re2`
* stopped inappropriately building the bundled GMP when `CHPL_GMP=system`
* improved ordering of `-I`/`-L` arguments for bundled vs. system versions
* non-debug builds of `chpl` now use `-DNDEBUG` to disable asserts in C++ code
* removed the `make third-party` target
* a 'dyno'-specific C++ linter now checks some class methods
* stopped relying on `distutils`, which is deprecated in Python 3.10

Developer-oriented changes: Compiler Flags
------------------------------------------
* added support for a `-j`/`--parallel-make` flag for the C back-end
* renamed the `--compiler-library-parser` flag to `--dyno`
* added `--dyno-debug-trace`/`--dyno-break-on-hash` for debugging 'dyno'

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* updated `--incremental` to compile each module's `.c` file independently
* enabled support for `make -j` using the C back-end via `-j` / `--incremental`
* added internal modules to the output of `--devel --print-callstack-on-error`
* stopped relying on `distutils`, which is deprecated in Python 3.10

Developer-oriented changes: 'dyno' Compiler improvements/changes
----------------------------------------------------------------
* the 'dyno' front-end can now parse all primers and modules
* improved `--dyno` to the point that 96% of our tests now pass
* improved `--dyno` error messages in terms of formatting and clarity
* added an ability to dump uAST nodes from 'dyno' using Chapel-like syntax
* significantly improved the prototype incremental resolver to support:
  - tuple types
  - implicit conversions
  - function disambiguation
  - type queries like `proc f(arg: ?t)`
  - generic types passed as type arguments
  - construction for recursive types (e.g., linked lists)
  - multi-variable and tuple-style declarations
* began the process of restructuring compiler passes to use a pass manager

Developer-oriented changes: Runtime improvements
------------------------------------------------
* implemented several improvements for `CHPL_COMM=ofi`
  - changed fetching AMOs to return the result via an active message (AM)
  - refactored code for blocking AM creation to ease maintainability
  - implemented completion counters
  - added support for per-endpoint address vectors
  - added the device name to a Chapel executable's `--verbose` output
  - started using the hybrid memory registration mode with the `cxi` provider
  - added environment variables to control the use of `fi_inject()`
* adjusted comm domain IDs for `ugni` to allow multiple locales per node
* tightened up `ugni` address checking against memory registrations
* added a warning for `CHPL_RT_NUM_THREADS_PER_LOCALE` with `CHPL_TASKS=fifo`
* cleaned up `pthread_once()` usage in the runtime

Developer-oriented changes: Platform-specific bug fixes
-------------------------------------------------------
* implemented various portability improvements for `CHPL_COMM=ofi`:
  - ensured that AM receive endpoints progress while transmitting in `ofi`
  - cleared `FI_INJECT` in `wrap_fi_writemsg()` for large messages
  - fixed the type of the second argument to `wrap_fi_writemsg()`

Developer-oriented changes: Tool Improvements
---------------------------------------------
* mason `.toml` files have sorted keys as a result of update to TOML package  
  (see https://chapel-lang.org/docs/1.26/modules/packages/TOML.html)


version 1.25.1
==============

Update to the twenty-eighth public release of Chapel, December 2021  
(see also changes below for 1.25.0)

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* generally improved the portability and robustness of the LLVM-based back-end
* added an option to build the compiler with 'jemalloc' to reduce compile times
* improved the performance and flexibility of types that use hash tables
* generalized support for `sync` and `single` types to include classes/records
* improved the initialization behaviors of variables of external types
* added a new 'ConcurrentMap' package module
* further improved the 'ArgumentParser' package and `mason`'s use of it
* improved several names and features in support of stabilizing libraries
* many other bug fixes and improvements to error messages and documentation

Packaging / Configuration Changes
---------------------------------
* improved the compiler's configuration when the LLVM back-end is enabled:
  - setting `CC`/`CXX` no longer disables the LLVM back-end  
    (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html)
  - `CHPL_LLVM=system` on linux now uses the more common `clang-cpp` library  
    (see https://chapel-lang.org/docs/1.25/usingchapel/prereqs.html)
  - building the compiler no longer stores paths to system compiler resources
  - improved the robustness of `CHPL_LLVM=bundled` builds
* added an option to build the compiler with 'jemalloc' to reduce compile-times  
  (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-host-mem)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* variables of `extern` types without initializers are now zero-initialized  
  (see https://chapel-lang.org/docs/1.25/language/spec/interoperability.html#variable-initialization)
* `param` `c_string`<->`string` conversions are now considered to be narrowing  
  (see https://chapel-lang.org/docs/1.25/language/spec/procedures.html#determining-more-specific-functions)

New Features
------------
* added support for `sync` and `single` records and classes  
  (see https://chapel-lang.org/docs/1.25/language/spec/task-parallelism-and-synchronization.html#synchronization-variables)
* added support for coercions when writing to `sync` and `single` variables
* `extern` records can now define initializers to opt into Chapel initialization  
  (see https://chapel-lang.org/docs/1.25/language/spec/interoperability.html#variable-initialization)
* added support for specifying user-defined hash functions via a `hash()` method
* enabled implicit conversions from `imag(32)` to `imag(64)`  
  (see https://chapel-lang.org/docs/1.25/language/spec/conversions.html#implicit-numeric-and-bool-conversions)

Name Changes in Libraries
-------------------------
* deprecated the standard module 'Spawn', renaming it to 'Subprocess'  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Subprocess.html)
* deprecated the 'Ordered[Set|Map]' modules, renaming them to 'Sorted[Set|Map]'  
  (see https://chapel-lang.org/docs/1.25/modules/packages/SortedMap.html  
   and https://chapel-lang.org/docs/1.25/modules/packages/SortedSet.html)
* deprecated `.front()`/`.back()` on arrays, renaming them to `.first`/`.last`  
  (see https://chapel-lang.org/docs/1.25/builtins/ChapelArray.html#ChapelArray.back)

Deprecated / Removed Library Features
-------------------------------------
* removed deprecated methods with `out` error arguments from `subprocess`
* removed deprecated method `exit_status()` from `subprocess`

Standard Library Modules
------------------------
* added optional arguments to `map` initializers for more control over resizing  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Map.html#Map.map.init)
* added support for hashing `bigint` values
* improved support for sets of arrays and maps with array keys
* converted standalone domain/array type queries into methods  
  (e.g., `isRectangularDom()` -> `Domain.isRectangular()`)

Package Modules
---------------
* added a new 'ConcurrentMap' package module  
  (see https://chapel-lang.org/docs/1.25/modules/packages/ConcurrentMap.html)
* added automatic help handling and message generation to 'ArgumentParser'  
  (see https://chapel-lang.org/docs/1.25/modules/packages/ArgumentParser.html#customizing-help-output)

Tool Improvements
-----------------
* improved `c2chapel` to reflect whether a C type has been `typedef`d
* refactored `mason` to use 'ArgumentParser' for all command-line parsing

Performance Optimizations / Improvements
----------------------------------------
* optimized the hash tables used by 'Set', 'Map', and associative domains/arrays
* fixed a bug in which `sort()` had stopped using insertionSort at small sizes
* `regex` values are now eagerly localized, reducing overheads

Compilation-Time / Generated Code Improvements
----------------------------------------------
* reduced compilation time by ~10-20% when opting into `CHPL_HOST_MEM=jemalloc`  
  (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-host-mem)
* modestly improved the time spent in the 'buildDefaultFunctions' pass

Memory Improvements
-------------------
* optimized memory tracking when `memThreshold` is set

Documentation
-------------
* merged module-based docs for atomic, complex, and locale types into the spec  
  (see https://chapel-lang.org/docs/1.25/language/spec/task-parallelism-and-synchronization.html#functions-on-atomic-variables,  
   https://chapel-lang.org/docs/1.25/language/spec/types.html#module-ChapelComplex_forDocs,  
   and https://chapel-lang.org/docs/1.25/language/spec/locales.html#locale-methods)
* added contributor documentation, such as best practices, to the online docs  
  (see https://chapel-lang.org/docs/1.25/developer/)
* added contributor documentation for the new compiler front-end  
  (see https://chapel-lang.org/docs/1.25/developer/compiler-internals/)
* improved the description of the prerequisites for documentation builds  
  (see https://chapel-lang.org/docs/1.25/usingchapel/prereqs.html)
* documented `CHPL_RT_UNWIND`  
  (see https://chapel-lang.org/docs/1.25/usingchapel/executing.html)
* improved the description of default initialization for records  
  (see https://chapel-lang.org/docs/1.25/language/spec/records.html#record-initialization)
* improved documentation for standard distributions  
  (see https://chapel-lang.org/docs/1.25/modules/layoutdist.html#standard-distributions)
* added documentation for `bigint.pow()` to the 'BigInteger' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.pow)
* added `throws` documentation to some methods in the 'Subprocess' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Subprocess.html#Subprocess.subprocess.poll,  
  https://chapel-lang.org/docs/1.25/modules/standard/Subprocess.html#Subprocess.subprocess.wait,  
  and https://chapel-lang.org/docs/1.25/modules/standard/Subprocess.html#Subprocess.subprocess.communicate)
* removed out-of-date note about whole-domain assignments being serialized  
  (see https://chapel-lang.org/docs/1.25/language/spec/domains.html#associative-domain-values)
* fixed various typos in documentation

Syntax Highlighting
-------------------
* added `operator` to various highlighters
* added highlighting of `lambda` to `vim` and `emacs`

Portability
-----------
* fixed an error building the compiler with GCC 11.2
* addressed a problem building the compiler on OpenBSD 7.0
* enabled `CHPL_TARGET_CPU=native` when using the LLVM back-end on ARM systems
* fixed the `chplvis` build w.r.t. C++11
* fixed a warning when building the compiler with clang++ 13

GPU Computing
-------------
* bundled generated kernel code into the executable, instead of a `.fatbin` file

Compiler Improvements
---------------------
* improved the LLVM back-end's support for clang arguments via `--ccflags`
* the LLVM back-end now generates structure sizes as simpler constants
* reduced the amount of memory allocated within the compiler
* reduced memory leaks within the compiler, such as for string literals

Launchers
---------
* made `slurm-gasnetrun*` respect `CHPL_LAUNCHER_ACCOUNT` more consistently

Error Messages / Semantic Checks
--------------------------------
* added an error when a non-operator is declared with the `operator` keyword
* added a warning when using `extern` and `inline` together on a declaration
* added a user error when indexing into an enumerated type
* added a user error when trying to `import` a bad expression type
* improved error messages for indexing into heterogeneous tuples w/ non-`param`s

Bug Fixes
---------
* fixed a bug with limitation clauses naming symbols via private `use`/`import`
* fixed default-initialization for `param` strings
* fixed a bug with concatenating `param` strings with escape sequences
* fixed a bug in `.join()` on `string`/`bytes` with single-element tuples
* fixed a bug related to remote references to module-scope `bytes` values
* fixed a problem with formals whose default value is `none`
* fixed intermittent corrupted packets when using GASNet over `udp`
* fixed a bug with unresolved defaulted formals in overridden methods
* fixed certain optimization errors involving virtual method calls
* fixed an internal error related to the `_wide_make` primitive and references

Bug Fixes for Build Issues
--------------------------
* fixed a problem when using a custom GCC with the bundled LLVM and clang
* `make clobber` no longer prints errors for `CHPL_LLVM=bundled`

Bug Fixes for Libraries
-----------------------
* fixed a bug in `bigint.pow()` for negative exponents
* fixed an infinite loop bug when using an empty `regex` pattern
* fixed buggy `regex` behaviors when a pattern contained a null byte
* fixed bugs when using `regex` values from remote locales
* fixed a bug related to custom comparators in 'sortedSet'

Bug Fixes for Tools
-------------------
* made minor fixes to `mason`'s command-line parsing

Platform-specific Bug Fixes
---------------------------
* fixed sporadic `GNI_PostRdma` errors for the `ugni` communication layer
* increased the default number of PMI KVS entries to have enough on HPE Cray EX

Third-Party Software Changes
----------------------------
* updated GASNet-EX to version 2021.9.0
* updated libunwind to version 1.5.0, which fixed certain build issues

Developer-oriented changes: Documentation
-----------------------------------------
* documented the automatic chpldoc text generated for `deprecated` symbols  
  (see https://chapel-lang.org/docs/1.25/developer/bestPractices/Deprecation.html)
* filtered deprecation warnings to remove inline markup used for `chpldoc` pages
* added a note about passing environment variables to `paratest`  
  (see https://chapel-lang.org/docs/1.25/developer/bestPractices/Sanitizers.html)
* `make docs` now includes compiler docs if `doxygen` and `cmake` are available  
  (see https://chapel-lang.org/docs/1.25/developer/compiler-internals/)
* combined the docs for `.join()` on `string`/`bytes` for arrays and tuples
* updated `ofi` communication layer developer documentation

Developer-oriented changes: Module changes
------------------------------------------
* refactored 'ChapelHashtable' to use 'Memory.Initialization'
* removed a trivial/pointless utility routine `shouldReturnRvalueByConstRef()`
* removed some unnecessary helper functions related to enumerating `enum` types
* removed unnecessary explicit `this.complete()` call in `_shared` initializer
* removed old comments referencing constructors

Developer-oriented changes: Build-time changes
----------------------------------------------
* on Cray systems, simplified integration between PrgEnvs and the LLVM back-end

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* added auto-deprecation documentation to symbols with `deprecated` keyword
* increased the number of primers and modules that the new front-end can parse
* continued improving the new prototype compiler front-end's resolution logic
* migrated some code from the production compiler to the new compiler front-end
* updated compiler code for compatibility with LLVM-12
* removed some un-needed compiler-generated iterators for traversing enums
* made the `--incremental` flag more robust w.r.t. large numbers of modules

Developer-oriented changes: Runtime improvements
------------------------------------------------
* `CHPL_RT_COMM_OFI_DEBUG_FNAME` can now redirect debug output to stdout/stderr

Developer-oriented changes: Tool Improvements
---------------------------------------------
* updated the `spack` back-end version to 0.15.4 for `mason external` commands


version 1.25.0
==============

Twenty-eighth public release of Chapel, September 23, 2021

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* implementation and configuration highlights:
  - made the LLVM-based back-end the default over the C-based back-end
  - added support for a new platform setting for HPE Apollo systems
  - reduced memory fragmentation for configurations that use a fixed heap
  - improved the portability, robustness, and performance of `ofi`-based comm
  - dramatically improved prototypical support for targeting GPUs with Chapel
* language and library highlights:
  - added a prototypical new `manage` statement for context management
  - added a new `foreach` loop to indicate task-less parallel loops
  - added new prototypical 'ArgumentParser' and 'OrderedMap' package modules
  - improved support for the `operator` feature and deprecated `proc`-based ops
* performance highlights:
  - improved performance on InfiniBand systems
  - reduced communication during `Block` array creation
  - reduced task creation overheads for zippered `coforall`s with known sizes
  - expanded the applicability of the `--auto-aggregation` flag
* tool highlights:
  - extended `c2chapel` to support GNU-specific features in headers

Packaging / Configuration Changes
---------------------------------
* LLVM is now the preferred compiler back-end, replacing the C-based back-end  
  (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-llvm)
* added a new default value of `unset` for the `CHPL_LLVM` env. variable  
  (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-llvm)
* `CHPL_TARGET_COMPILER` can now be used to select LLVM vs. C-based back-end  
  (see https://chapel-lang.org/docs/1.25/technotes/llvm.html  
   and https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-compiler)
* new variables `CC`/`CXX` support specifying the paths to C/C++ compilers  
  (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-compiler)
* added support for a new platform setting for HPE Apollo systems  
  (see https://chapel-lang.org/docs/1.25/platforms/infiniband.html)
* a C++14 compiler is now required to build the Chapel compiler  
  (see https://chapel-lang.org/docs/1.25/usingchapel/prereqs.html)
* Python 3.7 is now required by tools like `c2chapel`, `chpldoc`, etc.  
  (see https://chapel-lang.org/docs/1.25/usingchapel/prereqs.html)
* default to `fifo` tasking on arm-based (M1) Macs
* replaced `CHPL_REGEXP=re2|none` with `CHPL_RE2=bundled|none`  
  (see https://chapel-lang.org/docs/1.25/usingchapel/chplenv.html#chpl-re2)
* removed previously deprecated `CHPL_` env. settings that `bundled` replaced

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* began changing `.size` on ranges/domains/arrays to return `int` by default  
  (see https://chapel-lang.org/docs/1.25/builtins/ChapelRange.html#ChapelRange.range.size  
   and https://chapel-lang.org/docs/1.25/builtins/ChapelArray.html#ChapelArray.size)
* began changing `.indices` queries on arrays to differentiate from `.domain`  
  (see https://chapel-lang.org/docs/1.25/builtins/ChapelArray.html#ChapelArray.indices)

New Features
------------
* added a prototypical new `manage` statement for context management  
  (see https://chapel-lang.org/docs/1.25/technotes/manage.html)
* added a `foreach` loop for task-less parallel loops  
  (see https://chapel-lang.org/docs/1.25/technotes/foreach.html)
* added support for `extern union` to refer to external unions in C  
  (see https://chapel-lang.org/docs/1.25/language/spec/interoperability.html#referring-to-external-c-structs-and-unions)
* added `.sizeAs()` to query range/domain/array sizes using a specific type  
  (see https://chapel-lang.org/docs/1.25/builtins/ChapelRange.html#ChapelRange.range.sizeAs,  
   and https://chapel-lang.org/docs/1.25/builtins/ChapelArray.html#ChapelArray.sizeAs)

Feature Improvements
--------------------
* added support for slicing an associative array by an associative domain
* added support for ranges, domains, and arrays over 1-element enumerations  
  (e.g., `enum color { red }; var r: range(idxType=color);` now works)
* added support for operators on scalar/tuple pairs in which coercion occurs  
  (e.g., `2 * (1.0, 2.0, 3.0)` now works, resulting in `(2.0, 4.0, 6.0)`)
* improved the current prototypical support for interfaces:
  - disabled automatic inference of `implements` statements
  - added support for interface methods
  - added support for calling functions defined within an interface
  - added support for required functions to be interface-constrained
  - added support for invoking required functions via associated constraints
  - added support for passing arguments of associated types
* applying `*` between integers and `string`/`bytes` is now commutative
* added support for new `.dim()` and `.dims()` queries to arrays  
  (see https://chapel-lang.org/docs/1.25/builtins/ChapelArray.html#ChapelArray.dims)
* adjusted default operators to be generated as operator methods  
  (see https://chapel-lang.org/docs/1.25/technotes/operatorMethods.html)

Deprecated / Removed Language Features
--------------------------------------
* deprecated declaring operators without the `operator` keyword
* deprecated support for `use Mod except *;` in favor of `use Mod only;`
* deprecated the `ident()` comparison routine on ranges
* removed the deprecated assignment from `c_string` to `string`

Namespace Changes
-----------------
* made operations on `c_fn_ptr` types automatically available for now

Name Changes in Libraries
-------------------------
* renamed regular expression features from `Regexp`/`regexp` to `Regex`/`regex`
* renamed the `reMatch` type in favor of `regexMatch` in the 'Regex' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Regex.html#Regex.regexMatch)
* name changes in the 'BigInteger' module:
  - renamed enumerated type `Round` in favor of `round`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.round)
  - renamed `bigint.div_q()` in favor of `bigint.divQ()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.divQ)
  - renamed `bigint.div_r()` in favor of `bigint.divR()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.divR)
  - renamed `bigint.div_qr()` in favor of `bigint.divQR()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.divQR)
  - renamed `bigint.div_q_2exp()` in favor of `bigint.divQ2Exp()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.divQ2Exp)
  - renamed `bigint.div_r_2exp()` in favor of `bigint.divR2Exp()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.divR2Exp)
  - renamed `bigint.powm()` in favor of `bigint.powMod()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.powMod)
  - renamed `bigint.sizeinbase()` in favor of `bigint.sizeInBase()`  
    (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html#BigInteger.bigint.sizeInBase)
* replaced `subprocess.exit_status` with `subprocess.exitCode`  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Spawn.html#Spawn.subprocess.exitCode)

Deprecated / Removed Library Features
-------------------------------------
* deprecated the `bigint.size()` method in the 'BigInteger' module
* deprecated tertiary methods on the `file` type in the 'Path' module
* removed previously deprecated 'Path' module functions
* removed the deprecated 'Norm' module
* removed the deprecated version of `map.update()`
* removed deprecated functions and types from the `Memory` module
* removed deprecated methods on channels used to get and set error codes

Standard Library Modules
------------------------
* added a new 'Errors' standard module combining a few automatic modules  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Errors.html)
* enabled enumerated value 'IO' reads that include the `enum` type name  
  (e.g., `color.red` can now be read in addition to simply `red`)
* added support for JSON input and output for `list` and `map` in 'IO'  
  (see https://chapel-lang.org/docs/1.25/modules/standard/IO/FormattedIO.html#general-conversions)
* added a `datetime.timeSinceEpoch()` method to the 'DateTime' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/DateTime.html#DateTime.datetime.timeSinceEpoch)
* added a `-` operator between `datetime` and `date` values to 'DateTime'
* added new overloads with `file` arguments in some 'Path' module functions  
* added functions for replacing parts of a path in the 'Path' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Path.html#Path.replaceBasename)
* added a `regex.fullMatch()` method for regex matches anchored at both ends  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Regex.html#Regex.regex.fullMatch)
* added `const` and `const ref` overloads of `list.first()` and `list.last()`
* added `isNothing()` to the 'Types' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Types.html#Types.isNothing)
* made `is*Value` functions in the 'Types' module user-facing  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Types.html#Types.isBoolValue)
* improved support for socket programming in the 'Sys' module  
* updated many standalone operator declarations to be operator methods

Package Modules
---------------
* added a new 'ArgumentParser' module to aid with processing args to main()  
  (see https://chapel-lang.org/docs/1.25/modules/packages/ArgumentParser.html)
* added a new 'OrderedMap' module for maps that maintain ordering  
  (see https://chapel-lang.org/docs/1.25/modules/packages/OrderedMap.html)
* improved the 'LinearAlgebra' module:
  - added `sinm`, `cosm`, `sincos` to compute sines/cosines of square matrices  
    (see https://chapel-lang.org/docs/1.25/modules/packages/LinearAlgebra.html#LinearAlgebra.sinm,  
     https://chapel-lang.org/docs/1.25/modules/packages/LinearAlgebra.html#LinearAlgebra.cosm,  
     and https://chapel-lang.org/docs/1.25/modules/packages/LinearAlgebra.html#LinearAlgebra.sincos)
  - added `expm` to compute exponential of square matrices  
    (see https://chapel-lang.org/docs/1.25/modules/packages/LinearAlgebra.html#LinearAlgebra.expm)
  - extended `dot` to support sparse-dense matrix products  
    (see https://chapel-lang.org/docs/1.25/modules/packages/LinearAlgebra.html#LinearAlgebra.dot)
* updated many standalone operator declarations to be operator methods

Tool Improvements
-----------------
* tools like `chpldoc` and `c2chapel` now require Python 3.7
* added a `--gnu-extensions` flag to `c2chapel` to handle GNU-specific features
* improved `c2chapel` support for C unions, named structs, and other types
* improved error-checking for `mason` command-line arguments
* improved `chpldoc` formatting of binary operators with respect to spacing

Performance Optimizations / Improvements
----------------------------------------
* improved performance on InfiniBand systems by upgrading GASNet-EX versions
* reduced communication during `Block` array creation
* reduced task creation overheads for zippered `coforall`s with known sizes
* improved `--auto-aggregation` to make decisions based on `localAccess` calls
* improved `--auto-aggregation` to leverage accesses to non-distributed arrays
* optimized `allLocalesBarrier()`, particularly for InfiniBand systems
* parallelized assignments of large `bytes` copies in the 'ZMQ' module
* optimized performance of `string` operations when `--checks` are not enabled
* optimized the performance of the 'Sort' module's quicksort, used by `sort()`
* improved fabric selection in `ofi` by defaulting to a large fixed heap
* added data segment, heap, and stack memory to standard `ofi` registrations

Compilation-Time / Generated Code Improvements
----------------------------------------------
* generally speaking, compilation times improved due to the default use of LLVM
* reduced the amount of code generated for `forall` loops due to fast-followers

Memory Improvements
-------------------
* reduced memory fragmentation for configurations that require a fixed heap

Documentation
-------------
* added a primer example on C interoperability  
  (see https://chapel-lang.org/docs/1.25/primers/interopWithC.html)
* refreshed the Quickstart and 'Building Chapel' documents for clarity  
  (see https://chapel-lang.org/docs/1.25/usingchapel/QUICKSTART.html  
   and https://chapel-lang.org/docs/1.25/usingchapel/building.html)
* added documentation for how to define operator methods for inheritance  
  (see https://chapel-lang.org/docs/1.25/technotes/operatorMethods.html#operator-methods-and-classes)
* added `try...catch` and open-interval ranges to the Quick Reference document
* documented `locale.runningTasks()`  
  (see https://chapel-lang.org/docs/1.25/builtins/ChapelLocale.html#ChapelLocale.locale.runningTasks)
* added new documentation for several symbols in the 'BigInteger' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/BigInteger.html)
* documented the 'CommDiagnostics' fields related to `--cache-remote`  
  (see https://chapel-lang.org/docs/1.25/modules/standard/CommDiagnostics.html#CommDiagnostics.chpl_commDiagnostics.cache_get_hits)
* improved the docs regarding which types can be used with `sync`/`single`  
  (see https://chapel-lang.org/docs/1.25/language/spec/task-parallelism-and-synchronization.html#synchronization-variables)
* added `throws` documentation to `compile()` in the 'Regex' module  
  (see https://chapel-lang.org/docs/1.25/modules/standard/Regex.html#Regex.compile)
* fixed the formatting of double-dash arguments on the online `chpl` man page  
  (see https://chapel-lang.org/docs/1.25/usingchapel/man.html)
* clarified our requirements for using the LLVM back-end  
  (see https://chapel-lang.org/docs/1.25/usingchapel/prereqs.html#readme-prereqs)
* described the `make check` target in the 'Building Chapel' documentation  
  (see https://chapel-lang.org/docs/1.25/usingchapel/building.html#makefile-targets)
* improved the language specification's formatting of reserved keywords  
  (see https://chapel-lang.org/docs/1.25/language/spec/lexical-structure.html#keywords)
* updated the language spec to refer to a user-defined reduction example  
  (see https://chapel-lang.org/docs/1.25/language/spec/user-defined-reductions-and-scans.html)
* modestly improved the documentation for the 'IO' module
* fixed the formatting of a list in the 'classes' primer
* improved the docs for various library routines to reflect return types
* fixed various typos in the documentation

Syntax Highlighting
-------------------
* added `manage` to `vim` highlighting as a statement-level keyword

Example Codes
-------------
* added an example program demonstrating how to read CSV files in Chapel  
  (see `$CHPL_HOME/examples/patterns/readcsv.chpl`)
* updated example programs w.r.t. renamings and deprecated features
* fixed 'primers' Makefile to not build `interopWithC` helper on `make clean`

Portability
-----------
* improved the detection of pre-installed LLVMs to check for required headers
* improved the portability of the LLVM back-end for Mac OS X Mojave users
* improved the portability of the LLVM back-end for multi-locale ARM systems
* improved the portability of the LLVM back-end for various other platforms
* improved `make install` to better handle Python support scripts
* fixed a problem compiling the 'AtomicObjects' package with some C compilers
* adjusted the 'Crypto' module to require at least OpenSSL 1.1
* improved the portability of the squashing of some conservative gcc warnings

GPU Computing
-------------
* dramatically improved prototypical support for targeting GPUs with Chapel  
  (see https://chapel-lang.org/docs/1.25/technotes/gpu.html)
* added the ability to convert `forall` loops into GPU kernels
* added a new compiler analysis to determine eligible loops for running on GPUs
* enabled support for allocating data using CUDA's unified memory
* added loop cloning to enable loops to run on both CPUs and GPUs
* added runtime GPU diagnostics enabled with the `--verbose` flag

Compiler Improvements
---------------------
* added support for compiling multi-locale libraries using the LLVM back-end
* generally improved the robustness and completeness of the LLVM back-end

Compiler Flags
--------------
* renamed the `--regexp` flag to `--re2`
* deprecated `--[no]-llvm` in favor of `--target-compiler`  
  (e.g. `chpl --target-compiler=gnu` selects the C back-end using `gcc`)

Generated Executable Flags
--------------------------
* replaced the '-t'/'--taskreport' flags with `CHPL_RT_ENABLE_TASK_REPORTING`  
  (see https://chapel-lang.org/docs/1.25/usingchapel/debugging.html#tracking-and-reporting-on-tasks)
* removed the '-b'/'--blockreport' flag

Runtime Library Changes
-----------------------
* improved default runtime behavior when running in an oversubscribed manner

Launchers
---------
* added support for a `--nodelist` option to the `slurm-gasnetrun` launchers  
  (see https://chapel-lang.org/docs/1.25/usingchapel/launcher.html#using-slurm)

Error Messages / Semantic Checks
--------------------------------
* added a new build-time error if `CHPL_LLVM` is detected to be `unset`
* added errors for zippered `forall`s in which the first expression is larger
* improved error messages when zippering between rank-mismatched ranges/arrays
* improved the error message for applying `dmapped` to an illegal expression
* enabled `In module M:` annotations for errors when `M` is not the filename
* added an error when reading/writing a multidim array in Chapel syntax style  
  (e.g., `var A:[1..2, 1..2] string = "hi"; writef("%ht\n", A);`)
* added an error when exporting a symbol that contains illegal characters
* added an error when the LLVM back-end fails to find an external record field
* improved the error message emitted when `moveInitialize()` would copy
* added a syntax error for formal argument lists starting with a comma  
  (e.g., `proc foo(, x: int) { ... }`)
* added an error for filenames that are longer than the compiler can handle
* added a stopgap error for overridden methods with `param` defaults

Bug Fixes
---------
* LLVM back-end bug fixes:
  - improved handling of basic macros
  - fixed a bug with `nothing`/`void` fields
  - fixed an error that occurred when disabling inlining
  - fixed a problem cleaning up the temporary directory
  - fixed a bug when using opaque C structs
  - fixed an internal compiler error
  - fixed a bug with ABI support when a record was returned through an argument
* fixed a bug w.r.t. compiler-generated comparisons of records w/ array fields
* fixed a few bugs relating to using default arguments in overridden methods
* fixed an inconsistency with inherited type methods depending on call scopes
* fixed a race condition in initializing memory tracking
* fixed a bug with respecting the privacy of standalone operator definitions
* fixed a bug in which non-`bool` conditionals were fragile w.r.t. `import`s
* fixed bugs related to slicing local arrays with distributed domains
* fixed a bug with primary and secondary operator method visibility
* fixed a bug with searching for binary operator methods
* fixed a bug with promotion and types that define operator methods
* fixed a bug with cast operator method calls in initializers
* fixed a bug with visibility of tertiary operators methods with `use`/`import`
* fixed a bug where assignment operator methods resulted in extra assignments
* fixed a bug where `where` clauses were skipped if an argument was too generic
* fixed a bug where some `nil` assignment checks to records were thwarted
* fixed a bug where some `param` multiple assignment checks were thwarted
* fixed a bug with conversion-based error messages and operator methods
* improved support for `extern` records that contain C anonymous unions
* fixed a problem with variable initialization from a return intent overload
* fixed a compiler crash with certain recursive types
* fixed problems with nested classes used with `cobegin`
* fixed a compiler segfault relating to array fields and task intents
* fixed a compiler crash when parsing standalone `[]` expressions
* fixed a bug where declared types were ignored when initializing via tuples  
  (e.g., in `var x: t = (e1, e2);`, type `t` had been getting ignored)
* fixed a bug in which simple paren-less functions were misformatted in errors
* fixed a bug where aligned bounds queries didn't halt for unaligned ranges  
  (e.g., `(..10 by 2).alignedLow` returned a value rather than erroring)
* fixed a bug when using C header files with the GPU locale model
* fixed several problems when mixing interfaces with other language features

Bug Fixes for Libraries
-----------------------
* fixed a bug with `isSubtype()` and equally generic child/parent types
* fixed a bug with assignment operator methods and `isConstAssignable()`
* fixed a leak/crash when calling `set.add()` remotely on serializable types
* fixed several bugs for `map` binary operators when `parSafe=true`
* fixed a bug in `regex.subn()` caused by null bytes
* fixed a bug when passing a column slice to `BLAS.gemv()` in 'LinearAlgebra'
* fixed a bug when `SystemError.fromSyserr()` was passed a negative argument

Bug Fixes for Tools
-------------------
* fixed a bug in which `c2chapel` failed to `use` appropriate standard modules
* fixed a bug in `c2chapel` with respect to `void` type declarations
* fixed a bug w.r.t. how `c2chapel` handled `__extension__` in C header files
* fixed a bug with the display of some strings in `chpldoc`
* fixed a bug with displaying types in `type`/`var` declarations in `chpldoc`
* fixed a bug with leaving stray temporary files in `chpldoc` error cases
* fixed `mason` help to indicate that `--` rather than `-` passes args through
* fixed a bug in `printchplenv` when a system LLVM was not in the user's path

Platform-specific Bug Fixes
---------------------------
* portability improvements for the `ofi` communication layer:
  - ignored unusable T2 coprocessor provider on Mac OS X
  - ignored broken sockets/IPv6 provider
  - ignored broken verbs/IB provider
* fixed memory reallocation bugs for the `ugni` communication layer
* fixed a `--cache-remote` read-ahead bug for the `ugni` communication layer

Third-Party Software Changes
----------------------------
* updated GASNet-EX to the version 2021.8.0 snapshot
* updated the bundled version of 'libfabric' to version 1.12.1
* added a prefix to the bundled 'hwloc' to prevent use by third-party libraries
* updated Python packages used by `chpldoc` to their latest versions

Developer-oriented changes: Naming Changes
------------------------------------------
* renamed the GitHub development branch from `master` to `main`

Developer-oriented changes: Documentation
-----------------------------------------
* added a draft style guide for standard modules  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/StandardModuleStyle.rst)
* added notes about how Chapel web documentation is built  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/buildingdocs.rst)
* added information about how to test PRs in the contributor guidelines  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/ContributorInfo.rst#reviewer-responsibilities)
* generally cleaned up and streamlined the contributor guidelines  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/ContributorInfo.rst)
* improved the layout of documentation generated for the new compiler
* moved documents in `compilerOverview/` to `implementation/compilerOverview/`  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/implementation/compilerOverview/)
* documented the implementation of interfaces and a proposed new approach  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/implementation/Interfaces.md  
   and https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/implementation/Interfaces-new.md)

Developer-oriented changes: Module changes
------------------------------------------
* improved the string implementation to avoid redundant `localize()` calls
* deprecated undocumented routines for counting tasks and threads per locale

Developer-oriented changes: Makefiles
-------------------------------------
* fixed a Makefile bug that caused errors when `gcc`/`g++` versions differed
* fixed a bug where the `config` toolchain discarded `stderr` then printed it

Developer-oriented changes: Compiler Flags
------------------------------------------
* added experimental `--compiler-library-parser` to use new parser
* added `--gpu-arch` to control the CUDA architecture for GPU compilation
* added `--gpu-block-size` to control the block size for GPU kernel launches
* added `--interleave-memory` to reduce performance hit of poor NUMA affinity

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* added a new (disabled by default) front-end in support of incr. compilation
* added prototypical deprecation of any symbol using a `deprecated` keyword
* improved the representation of unique strings in the compiler
* renamed source files to avoid the same filename in different directories
* replaced a homegrown temporary directory creation with a standard solution
* cleaned up the printing of arg intents in `list_view()` output
* adjusted the compiler to generate heap allocation for string literals
* removed support for old-style `_cast` operators from the compiler
* changed C++ compiler sources to include `cmath` instead of `math.h`
* removed a non-deterministic behavior during compilation
* refactored gpu transformation code into a separate source file

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added internal oversubscription detection for `ofi` and `ugni` communication
* regularized how `ofi` matches fabrics to Chapel's memory consistency model
* simplified and improved PMI-based out-of-band support in `ofi` communication
* allowed for `ofi` to connect endpoints early instead of dynamically
* reduced network endpoint and resource requirements in `ofi` communication
* refactored and significantly simplified the task creation interface
* added the ability to get a file descriptor from a `qio_file_t*`
* fixed a problem with spurious assertion failures from `--cache-remote`

Developer-oriented changes: Testing System
------------------------------------------
* enabled `start_test` to run C++ tests
* made memory leak testing report leaks as failures
* added the ability to respect `.skipif`/`SKIPIF` files via `-respect-skipifs`
* improved filtering out Slurm system-oriented messages in testing
* removed overheads in lightweight communication-oriented micro-benchmarks
* updated Python packages used for `start_test` to their latest version

Developer-oriented changes: Tool Improvements
---------------------------------------------
* refactored most of `mason` to make use of the new 'ArgumentParser' module

Developer-oriented changes: Utilities
-------------------------------------
* added `util/devel/updateGITLOG` to create a `GITLOG` file of PR merges
* extended `greptest` to search through test helper files
* added new scripts to `util/buildRelease` to help with version number updates
* improved `lookForBadRTCalls` script to suggest preferred functions
* specialized `doc/util/chpl2rst.py` in support of `learnChapelInYMinutes.chpl`


version 1.24.1
==============

Update to the twenty-seventh public release of Chapel, April 2021  
(see also changes below for 1.24.0)

Highlights
----------
* significant performance improvements for InfiniBand systems
* improved support for computing with `enum` ranges
* closed all known memory leaks

Feature Improvements
--------------------
* extended `param` for-loops to support `enum` ranges
* added support for open-interval `enum` ranges

Performance Optimizations / Improvements
----------------------------------------
* improved performance on InfiniBand systems by upgrading GASNet-EX
* improved NUMA affinity and startup times when using a fixed heap

Memory Improvements
-------------------
* closed a memory leak related to tuple coercions
* closed a memory leak in `list.insert()`
* closed a memory leak in constrained generic interfaces

Third-Party Software Changes
----------------------------
* upgraded GASNet-EX to version 2021.3.0

Portability
-----------
* improved the portability of the code base to HPE Cray EX

Bug Fixes for Libraries
-----------------------
* fixed a bug in which `indexOf()` on an empty list halted
* fixed bugs in binary operations for sets with `parSafe=true`

Developer-oriented changes: Runtime improvements
------------------------------------------------
* improved our approach to polling when communicating using GASNet over `ucx`


version 1.24.0
==============

Twenty-seventh public release of Chapel, March 18, 2021

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* language:
  - significantly improved the syntax and semantics of operator overloads
  - clarified the relationship between various type conversion mechanisms
  - improved ergonomics for using nilable classes within conditionals and loops
  - improved the definition and handling of tertiary methods
  - unified the handling of `out` intents and `return` statements
  - added initial support for constrained generic interfaces
* performance:
  - improved the performance of `--cache-remote` and enabled it by default
  - added a new optimization that automatically aggregates communications
  - improved the generality and reporting of the auto-local-access optimization
  - dramatically reduced the overheads of tracking a domain's arrays
  - improved performance for various scan operations on 1D arrays
  - improved compile times for programs using zippered `forall` loops
* libraries:
  - refactored the 'Memory' module and added a new 'Initialization' sub-module
  - added a new 'UnrolledLinkedList' module
  - improved the flexibility of initializing lists
  - added support for 'PrivateDist' arrays of non-nilable classes
  - updated the 'LinearAlgebra' module to use 0-based indexing
  - improved the generality of `sort()` in the 'Sort' module
  - refactored the documentation and organization of the standard libraries
* misc:
  - added syntax highlighting for 'geany' and LaTeX
  - significantly improved `ofi` portability, performance, and selection
  - significantly improved the readiness of the LLVM-based compiler back-end
  - closed the vast majority of known memory leaks
  - removed Python 2 dependences in favor of Python 3
  - improved several launcher choices and options

Packaging / Configuration Changes
---------------------------------
* a C++11 compiler is now required to build the Chapel compiler
* added `bundled` options for several `CHPL_*` environment variables
* added a Lua/Lmod module file for Chapel on HPE Cray XC and EX systems
* expanded support for HPE Cray EX systems  
  (see https://chapel-lang.org/docs/1.24/platforms/cray.html#getting-started-with-chapel-on-cray-xc-or-hpe-cray-ex-systems)

Syntactic / Naming Changes
--------------------------
* `operator` is now reserved for defining operator overloads
* `interface`/`implements` are now reserved keywords for constrained generics
* `foreach` is now reserved as a keyword for future use  
  (see https://chapel-lang.org/docs/1.24/language/spec/lexical-structure.html#keywords)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* added errors for missing conversions between types  
  (e.g. if `=` is provided then `init=` and `:` must be as well)  
  (see https://chapel-lang.org/docs/1.24/language/spec/conversions.html#implicit-conversions-for-initialization-and-assignment)
* changed type inference for `out` intent to be more similar to `return`  
  (see https://chapel-lang.org/docs/1.24/language/spec/procedures.html#the-out-intent)
* made `out` argument types no longer impact function resolution  
  (see https://chapel-lang.org/docs/1.24/language/spec/procedures.html#function-resolution)
* updated copy elision and split initialization to apply within `local` blocks  
  (e.g., `var x; local { x = 1; }` now works for `--no-local` compilations)  
  (see https://chapel-lang.org/docs/1.24/language/spec/variables.html#split-initialization  
   and https://chapel-lang.org/docs/1.24/language/spec/variables.html#copy-elision)
* method calls now respect privacy and limitation clauses of `use`/`import`  
  (see https://chapel-lang.org/docs/1.24/language/spec/modules.html#except-and-only-lists  
   and https://chapel-lang.org/docs/1.24/language/spec/modules.html#importing-modules)

Namespace Changes
-----------------
* `c_void_ptr` is no longer automatically available, but defined in 'CPtr'  
  (e.g., use `import CPtr.c_void_ptr;`/`use CPtr;` to refer to `c_void_ptr`)

New Features
------------
* added an `operator` keyword for defining operator overloads  
  (see https://chapel-lang.org/docs/1.24/language/spec/procedures.html#procedure-definitions)
* added the ability to define operator overloads as methods on a type  
  (see https://chapel-lang.org/docs/1.24/technotes/operatorMethods.html)
* added user-defined cast operations via `operator :`  
  (see https://chapel-lang.org/docs/1.24/language/spec/conversions.html#user-defined-casts)
* added support for non-nilable declarations to `if` and `while` statements  
  (e.g., `if const obj = foo() then obj.bar();` ensures `obj` is non-nilable)  
  (see https://chapel-lang.org/docs/1.24/language/spec/statements.html#the-conditional-statement  
   and https://chapel-lang.org/docs/1.24/language/spec/statements.html#the-while-do-and-do-while-loops)
* added initial support for constrained generic interfaces  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/chips/2.rst)
* added support for directly indexing `string` and `bytes` literals  
  (e.g., `var s = "Chapel"[0];` and `var b = b"is great!"[0];` now work)
* added `domain.orderToIndex(i)` to get the `i`th index in a rectangular domain  
  (see https://chapel-lang.org/docs/1.24/builtins/ChapelArray.html#ChapelArray.orderToIndex)

Feature Improvements
--------------------
* improved handling of methods with respect to `use` and `import` statements  
  (see https://chapel-lang.org/docs/1.24/language/spec/modules.html#except-and-only-lists  
   and https://chapel-lang.org/docs/1.24/language/spec/modules.html#importing-modules)
* tightened up methods for modifying domains to give errors for `const` domains
* added support for fixed-size arrays of tuples of non-nilable classes
* improved array literal creation to use moves rather than default-init and `=`
* extended tuples to support indexing by boolean expressions  
  (e.g., `("hi", "there")[myBoolExpr]` is now supported)
* extended copy elision to support local variables within `if`/`else` blocks
* adjusted `.targetLocales` on arrays and domains to return by reference  
  (see https://chapel-lang.org/docs/1.24/builtins/ChapelArray.html#ChapelArray.targetLocales)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* deprecated support for implicit reads and writes of `sync`/`single` variables
* deprecated assignments to `string` from `c_string`
* removed support for casts from `c_void_ptr` to non-nilable `class` types
* removed support for `domain.member` and `range.member`
* removed an old warning about the transition from constructors to initializers

Deprecated / Removed Library Features
-------------------------------------
* deprecated `regexp.ok` and `regexp.error()` in favor of thrown errors
* deprecated the `dotnl` option in `Regexp.compile()`, replaced by `dotAll`
* removed support for `Replicated` arrays of non-default-initializable elements
* removed features that had previously been deprecated from 'Regexp'
* removed the deprecated 'Assert' module

Standard Library Modules
------------------------
* moved the contents of the 'Memory' module into 'Memory.Diagnostics'  
  (see https://chapel-lang.org/docs/1.24/modules/standard/Memory/Diagnostics.html)
* added a new 'Memory.Initialization' module for low-level moves, deinits  
  (see https://chapel-lang.org/docs/1.24/modules/standard/Memory/Initialization.html)
* added support for initializing a `list` with no declared element type  
  (e.g., `var x: list = 1..2;` is now supported)
* added support for initializing a `list` using an iterator expression  
  (e.g., `var x: list(int) = for i in 1..10 do i;` is now supported)
* `isSubtype()` and related functions now appear in the 'Types' module  
  (see https://chapel-lang.org/docs/1.24/modules/standard/Types.html#Types.isSubtype)
* added support for `%f` formatting to `datetime.strftime()` in 'DateTime'
* added a new `splitExt()` routine to the 'Path' module  
  (see https://chapel-lang.org/docs/1.24/modules/standard/Path.html#Path.splitExt)
* added counters for `--cache-remote` hits and misses to 'CommDiagnostics'  
  (see https://chapel-lang.org/docs/1.24/modules/standard/CommDiagnostics.html#CommDiagnostics.chpl_commDiagnostics.cache_get_hits)

Package Modules
---------------
* added a new 'UnrolledLinkedList' module  
  (see https://chapel-lang.org/docs/1.24/modules/packages/UnrolledLinkedList.html)
* extended `sort()` to work with arrays with indices other than default `int`
* explicitly restricted `sort()` to only support 1D rectangular arrays  
  (see https://chapel-lang.org/docs/1.24/modules/packages/Sort.html#Sort.sort)
* updated the 'LinearAlgebra' module to default to 0-based indexing

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added support for `PrivateDist` arrays of non-nilable classes

Performance Optimizations / Improvements
----------------------------------------
* improved the scalability and performance of the `--cache-remote` option  
  (see `--[no-]cache-remote` in https://chapel-lang.org/docs/1.24/usingchapel/man.html)
* enabled `--cache-remote` by default, reducing communication in many programs
* added a new copy aggregation optimization, enabled by `--auto-aggregation`  
  (e.g. `forall i in A.domain { A[i] = A[foo(i)]; }` will use aggregation)
* expanded the auto-local-access optimization to support additional cases:  
  - array slices (rank-preserving or changing)  
    (e.g. `forall i in ASlice.domain { ASlice[i] = 5; }` will be optimized)  
  - indices yielded from follower iterators  
    (e.g. `forall (a,i) in zip(A, A.domain) { A[i] = 5; }` will be optimized)
* reduced overheads for managing arrays declared over `var` domains
* improved the performance of scans on 1D local and `Block` arrays
* parallelized scan operations on 1D `Replicated` arrays

Compilation-Time / Generated Code Improvements
----------------------------------------------
* reduced the compilation time of zippered `forall` loops
* improved generated code for `--llvm` to reduce communication for `+=` ops
* set `CHPL_OPTIMIZE`/`CHPL_DEBUG` based on user settings, not the runtime's

Memory Improvements
-------------------
* closed a memory leak for type aliases of arrays of arrays  
  (e.g. `type arrOfArr = [1..2][100..200] int;`)
* closed a memory leak for unnamed array type expressions
* closed a memory leak for arrays returned from empty `for` expressions
* closed a memory leak for `owned` values that are not captured in a variable
* closed a memory leak for `forall` loops that throw errors
* closed a memory leak for `defer` statements that contain initializations
* closed a memory leak that happened when `Regexp.compile()` fails and throws
* closed a memory leak in `ReplicatedDist`
* closed a memory leak when combining `out` intents and array returns

Documentation
-------------
* restored the 'Syntax' section of the language spec, summarizing productions  
  (see https://chapel-lang.org/docs/1.24/language/spec/syntax.html)
* documented the concept of tertiary methods  
  (see https://chapel-lang.org/docs/1.24/language/spec/methods.html)
* documented the ability to interact with `extern` C unions  
  (see https://chapel-lang.org/docs/1.24/language/spec/interoperability.html#referring-to-external-c-structs-and-unions)
* other general fixes and improvements to the language specification
* reorganized the list of standard Chapel modules into categories  
  (see https://chapel-lang.org/docs/1.24/modules/standard.html)
* added mason packages landing page to documentation hierarchy  
  (see https://chapel-lang.org/docs/1.24/mason-packages.html)
* added documentation for `min` and `max` to the 'Math' module documentation  
  (see https://chapel-lang.org/docs/1.24/modules/standard/Math.html#Math.max)
* added documentation for `sys_getenv()`  
  (see https://chapel-lang.org/docs/1.24/modules/standard/Sys.html#Sys.sys_getenv)
* `vectorizeOnly()` is now documented in its own page 'VectorizingIterator'  
  (see https://chapel-lang.org/docs/1.24/modules/standard/VectorizingIterator.html)
* moved several modules out of the 'Built-in Types and Functions' category  
  (see https://chapel-lang.org/docs/1.24/modules/standard/ChapelEnv.html,  
       https://chapel-lang.org/docs/1.24/modules/standard/ChapelIO.html,  
   and https://chapel-lang.org/docs/1.24/modules/standard/VectorizingIterator.html)
* improved some of the explanations in the 'Path' module documentation
* improved the formatting of code blocks in the 'CommDiagnostics' module  
  (see https://chapel-lang.org/docs/1.24/modules/standard/CommDiagnostics.html)
* updated the Quickstart instructions to no longer reference its old location  
  (see https://chapel-lang.org/docs/1.24/usingchapel/QUICKSTART.html)
* fixed some broken cross-references in the `chpldoc` documentation

Syntax Highlighting
-------------------
* added Chapel syntax highlighting support for the 'geany' editor  
  (see `$CHPL_HOME/highlight/geany/README.md`)
* added LaTeX syntax highlighting for Chapel via the `lstlisting` package  
  (see `$CHPL_HOME/highlight/latex/`)

Example Codes
-------------
* added a new primer for `forall` loops  
  (see https://chapel-lang.org/docs/1.24/primers/forallLoops.html)
* added a description of task intents to the 'Task Parallelism' primer  
  (see https://chapel-lang.org/docs/1.24/primers/taskParallel.html#task-intents)
* refreshed the 'Parallel Iterators' primer with respect to content and order  
  (see https://chapel-lang.org/docs/1.24/primers/parIters.html)
* updated the example codes to use explicit reads/writes on `sync`/`single`
* updated the example codes to reflect other minor changes since Chapel 1.23

Portability
-----------
* added support for Python 3 in cases where we'd previously relied on Python 2
  - updated Python support scripts to work on systems with only `python3`
  - improved compatibility of support scripts with Python 3
  - `chpldoc` and `c2chapel` now require Python 3
  - migrated Python dependencies from `virtualenv` to a Python application

Compiler Flags
--------------
* added a new `--[no-]auto-aggregation` flag to control a new optimization  
  (see its entry at https://chapel-lang.org/docs/1.24/usingchapel/man.html)

Runtime Library Changes
-----------------------
* significantly improved `ofi` portability and performance
* improved detection of a system libfabric for use with `ofi` communication

Launchers
---------
* added a `lsf-gasnetrun_ibv` launcher for running on LSF over InfiniBand  
  (see https://chapel-lang.org/docs/1.24/usingchapel/launcher.html#currently-supported-launchers)
* improved launcher auto-detection on Cray CS systems  
  (see https://chapel-lang.org/docs/1.24/usingchapel/launcher.html#currently-supported-launchers)
* improved `slurm-srun` support for AWS auto-scaling
* improved auto-detection to always use `amudprun` for GASNet's `udp` substrate

Error Messages / Semantic Checks
--------------------------------
* improved the callstack for error messages with respect to `inline` functions
* improved the callstack for error messages occurring later in compilation
* improved the error when a `type` actual is passed to a value varargs formal
* improved the wording and formatting of resolution-oriented error messages
* squashed method vs. standalone mismatches when printing function candidates
* improved the error message for passing a coercion value to a `ref` formal
* improved error messages for illegal uses of `void`, such as `void` variables
* improved errors for assignment between `nothing` and non-`nothing` variables
* improved the error message when split initialization is used with `noinit`  
  (e.g. `var x; x = noinit;`)
* improved error messages to better distinguish initialization and assignment
* report an error for default initialization of a record with typeless fields
* added a clearer compiler error when the 'SysCTypes' module is missing
* added a compilation error in the HDF5 package for unsupported types
* added an error for record fields that would be misaligned for `--llvm`

Bug Fixes
---------
* fixed a bug in generic functions that `import` non-module symbols
* fixed several bugs due to missing `use` and `import` statements
* fixed an internal error with certain sparse subdomain declarations
* fixed a bug in which the array swap optimization was applied too broadly
* fixed a bug that caused crashes when `begin` was used in exported functions
* fixed a bug involving incorrect sign extensions on `uint`s with `--llvm`
* fixed a bug in debugging support for programs compiled with `--llvm`
* fixed a bug where a nested function call in a type alias was invoked twice
* fixed a bug when `compilerError()` appeared in an unused copy initializer
* fixed a problem with stack allocation for aligned types with `--llvm`
* fixed a bug where non-POD `in` formals failed to compile in some scenarios
* fixed a problem passing an array slice to an `inout` formal argument
* fixed an internal error when `cobegin` statements contained syntax errors
* fixed an internal error related to casting arrays to borrowed classes

Bug Fixes for Libraries
-----------------------
* fixed an error that occurred when printing out certain `real` numbers
* fixed several problems with I/O of `owned` and `shared` classes
* fixed a bug handling end-of-file when matching a regular expression
* fixed a bug in which `set.add()` segfaulted when called remotely
* fixed a potential deadlock in `map.toArray()` methods
* fixed a bug where `FileSystem.copyTree()` failed for files not owned by user
* fixed the implementation of `DistBag.clear()` in the 'DistributedBag' package

Bug Fixes for Tools
-------------------
* fixed a bug in which `chpldoc` dropped parentheses, changing code's meaning
* fixed several bugs relating to how `chpldoc` renders initializing expressions
* fixed a bug in `chpldoc` with `nil` default values
* fixed a bug in `chpldoc` with generic type instantiations
* fixed the rendering of 1-tuples in `chpldoc`
* fixed a bug in which `chpldoc` would output an extra space after `.type`
* fixed a bug where `mason update` failed if no `[dependencies]` table exists

Platform-specific bug fixes
---------------------------
* fixed the `protobuf` plug-in to build on OSX
* fixed a race under GASNet's `ibv` substrate on PowerPC

Third-Party Software Changes
----------------------------
* upgraded GASNet-EX to version 2020.10.0
* upgraded Qthreads to version 1.16
* upgraded LLVM to version 11.0.1
* upgraded GMP to version 6.2.1
* upgraded RE2 to version 2021-02-02
* updated Python packages used for `chpldoc` to Python 3-compatible versions
* returned to downloading Chapel's Sphinx domain from PyPI rather than bundling

Developer-oriented changes: Process
-----------------------------------
* switched from having developers sign CLAs to using DCO-based commits  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/DCO.rst)

Developer-oriented changes: Documentation
-----------------------------------------
* updated the docs to reflect our use of Discourse rather than mailing lists
* refreshed the information in our 'GettingStarted' documentation  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/GettingStarted.rst)
* refactored our 'ContributorInfo' documentation w.r.t. DCOs, git tips, etc.  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/ContributorInfo.rst,
   https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/DCO.rst,  
   and https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/git.rst)
* switched to a non-Cray version of the Chapel logo in the project's README
* created an improved and independently-maintained pygments highlighter  
  (see https://github.com/chapel-lang/sphinxcontrib-chapeldomain)

Developer-oriented changes: Module changes
------------------------------------------
* improved the performance of the undocumented two-array radix sorts
* added a private 'TimSort' module and `timSort()` implementation to `Sort`
* reduced reliance on, and removed, many functions from 'ChapelIteratorSupport'
* fixed a bug where `chpl_nodeID` wasn't generating shadow variables properly
* refactored 'Regexp' module methods to avoid code duplication
* removed `inline` from some nontrivial 'IO' module routines

Developer-oriented changes: Makefiles
-------------------------------------
* adjusted `make docs` to do an incremental build in most cases
* updated `make docs` to create the `chpl` man page
* updated Makefiles to use Python 3 where possible, or fall back on Python 2

Developer-oriented changes: Compiler Flags
------------------------------------------
* added a `--[no-]report-auto-aggregation` flag for auto-aggr. opt. reports
* added a `--[no-]infer-implements-decls` flag for inferring `implements`
* added a `--print-additional-errors` flag for post-`compilerError()` errors
* improved the output of the `--report-auto-local-access` flag
* removed previously deprecated `--[no-]legacy-classes` flag

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* C++11 features can now be used within the compiler source code
* stopped using tuples for `zip` clauses in `forall` loops
* type conversions no longer fall back on default-init and then assign
* added a pragma to allow a function to exist only for `chpldoc`
* added a pragma to indicate to `chpldoc` when a module is included by default
* adjusted the code generator to add initial support for targeting GPUs
* made use of virtual destructors and `= default` constructors/destructors

Developer-oriented changes: Performance improvements
----------------------------------------------------
* extended `-sserialize_slices` to support array slices within `zip()` exprs  
  (e.g. `forall (a,b) in zip(A[2..5], B[2..5])` is optimized with the flag)

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added initial support for GASNet's `ucx` substrate
* fixed a race in counting running tasks
* adjusted the runtime headers to compile as C++
* switched the runtime shim for RE2 to use C++11 `thread_local` over pthreads

Developer-oriented changes: Testing System
------------------------------------------
* updated testing system to rely on, and be compatible with, Python 3
* added a `-python2` flag to `nightly` to run with Python 2
* fixed issue with including additional binary files when comparing test output
* fixed a bug in nightly memory leak testing


version 1.23.0
==============

Twenty-sixth public release of Chapel, October 15, 2020

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* language: hardened several core language features, including:
  - point-of-instantiation (POI) rules and method resolution
  - namespaces and visibility through `use` and `import`
  - split initialization and array initialization
  - behavior of `in`, `out`, `inout` intents
* library:
  - added new 'Heap' and 'OrderedSet' modules
  - added a new 'Version' module for reasoning about `chpl` and code versions
  - made numerous improvements to the `LinearAlgebra` module
  - improved orthogonality and interfaces of collection types
* the `mason` package manager:
  - interactive modes for `mason new` and `mason init`
  - improved ergonomics for `mason search`, `test`, `build`, and `publish`
  - `bash` completion support
* performance:
  - optimized accesses to distributed arrays for provably local indices
  - parallelized assignments and initializations for large local arrays
  - reduced overheads for managing arrays, particularly over `const` domains
  - improved performance for associative domains/arrays, `map`, and `set`
  - significant improvements to compilation time for certain patterns
* additional highlights:
  - added initial support for Google Protocol Buffers
  - significant improvements to the LLVM back-end
  - significant improvements to the `ofi`-based communication option
  - improvements to memory fragmentation and leaks
  - minor improvements to Python interoperability

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* improved the Point of Instantiation (POI) rule to avoid surprising behaviors  
  (see https://chapel-lang.org/docs/1.23/language/spec/generics.html#function-visibility-in-generic-functions)
* array copy initialization now copy initializes the array elements as intended  
  (see https://chapel-lang.org/docs/1.23/language/spec/variables.html#copy-and-move-initialization)
* iterator expressions can now be passed to `in` array arguments  
  (see https://chapel-lang.org/docs/1.23/language/spec/iterators.html#iterators-as-arrays)
* improved `inout` intent operations to interleave well with `in` and `out`  
  (see https://chapel-lang.org/docs/1.23/language/spec/procedures.html#the-inout-intent)
* module-scope variables are now deinitialized in reverse initialization order  
  (see https://chapel-lang.org/docs/1.23/language/spec/modules.html#module-deinitialization)
* certain arguments no longer infer runtime types from their default values  
  (see https://chapel-lang.org/docs/1.23/language/spec/procedures.html#default-values)
* improved method resolution to always look at the type's definition point

New Features
------------
* added `noinit` to avoid default initialization of array elements  
  (see https://chapel-lang.org/docs/1.23/technotes/noinit.html)
* added support for `import` statements that support multiple subexpressions  
  (e.g., `import Mod1; import Mod2;` can now be written `import Mod1, Mod2;`)  
  (see https://chapel-lang.org/docs/1.23/language/spec/modules.html#importing-modules)
* added support for `use` statements that require qualified access  
  (e.g., `use Foo as _;` requires typing `Foo.xyz` rather than simply `xyz`)  
  (see https://chapel-lang.org/docs/1.23/language/spec/modules.html#disabling-qualified)
* added `string.dedent()` and `bytes.dedent()` for removing common indentation  
  (see https://chapel-lang.org/docs/1.23/builtins/String.html#String.string.dedent  
   and https://chapel-lang.org/docs/1.23/builtins/Bytes.html#Bytes.bytes.dedent)
* added support for defining methods on type aliases or paren-less functions  
  (e.g., `type myAlias=int; proc myAlias.myMethod() {}; 5.myMethod();`)
* added a `range.isBounded()` query  
  (see https://chapel-lang.org/docs/1.23/builtins/ChapelRange.html#ChapelRange.range.isBounded)

Feature Improvements
--------------------
* extended `import super...` to support non-module symbols  
  (e.g., `import super.foo;` is now supported for variable/function/... `foo`)
* added support for qualified access to re-exported symbols accessed via `use`  
  (e.g., given `module M { public use N; }` `use M;` now supports writing `M.N`)
* extended `param` for-loops to support ranges formed using the `#` operator  
  (e.g., `for param i in 0..#10` is now supported)
* improved `string`/`bytes` factory functions to accept `c_ptr(c_char)` buffers  
  (see https://chapel-lang.org/docs/1.23/builtins/String.html#String.createStringWithBorrowedBuffer  
   and https://chapel-lang.org/docs/1.23/builtins/Bytes.html#Bytes.createBytesWithBorrowedBuffer)
* split initialization no longer considers nested function declarations  
  (see https://chapel-lang.org/docs/1.23/language/spec/variables.html#split-initialization)

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* removed `.length`, `.numIndices`, and `.numElements`; use `.size` instead
* removed support for spaces in query expressions  
  (e.g. `proc foo(arg: ? t)` and `proc foo(args... ? n)` no longer parse)
* removed postfix-`!` on class types in favor of using casts
* removed `new owned/shared(c)` in favor of `owned/shared.create(c)`
* removed `string` vs. `bytes` comparisons
* removed `decodePolicy.ignore` in favor of new `decodePolicy.drop`  
  (see https://chapel-lang.org/docs/1.23/builtins/Bytes.html#Bytes.bytes.decode)
* removed `enumerated`, which was deprecated previously; use `enum` instead
* removed support for C++-style deinitializer names e.g. `proc ~C()`
* removed support for vectorization hinting to the C backend
* removed support for deprecated meaning of `CHPL_TARGET_ARCH`
* removed support for deprecated path to `chpl` within `bin`

Deprecated / Removed Library Features
-------------------------------------
* deprecated use of `this()` for lists and maps for which `parSafe=true`  
  (e.g. `myList[i]` is not allowed if `myList.parSafe == true`)
* deprecated use of `getReference()` for maps initialized with `parSafe=true`
* removed deprecation warnings for symbols in the 'IO' module

Standard Library Modules
------------------------
* added a 'Builtins' module containing general auto-available symbols  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Builtins.html)
* added a 'Version' module for reasoning about version numbers including 'chpl's  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Version.html)  
* added a 'Heap' module implementing the `heap` datatype  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Heap.html)
* made 'CPtr' a standard user-facing module requiring `use`/`import`  
  (see https://chapel-lang.org/docs/1.23/modules/standard/CPtr.html)
* certain other standard libraries now also require explicit `use`/`import`  
  (e.g., 'Sys', 'SysBasic', 'CPtr', 'HaltWrappers' and 'DSIUtil')
* significantly improved support for lists, maps, sets of arbitrary class types
* added `update()`, `getBorrowed()`, `getValue()` methods to list  
  (see https://chapel-lang.org/docs/1.23/modules/standard/List.html#List.list.update,  
       https://chapel-lang.org/docs/1.23/modules/standard/List.html#List.list.getBorrowed,  
  and https://chapel-lang.org/docs/1.23/modules/standard/List.html#List.list.getValue)
* enabled lifetime checking for lists of borrowed classes
* adjusted `map.items()` iterator to return by value  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Map.html#Map.map.items)
* redefined `update()` on maps and renamed prior behavior to `extend()`  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Map.html#Map.map.extend  
   and see https://chapel-lang.org/docs/1.23/modules/standard/Map.html#Map.map.update)
* added a new routine to print 'CommDiagnostics' in tabular form  
  (see https://chapel-lang.org/docs/1.23/modules/standard/CommDiagnostics.html#CommDiagnostics.printCommDiagnosticsTable)
* added the ability to get stack traces in verbose output for 'CommDiagnostics'  
  (see https://chapel-lang.org/docs/1.23/modules/standard/CommDiagnostics.html#CommDiagnostics.commDiagsStacktrace)
* made `c_ptrTo()` generate a compile-time error for distributed arrays  
  (see https://chapel-lang.org/docs/1.23/modules/standard/CPtr.html#CPtr.c_ptrTo)
* added domain and range overloads to `choice()` in the 'Random' module  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Random.html#Random.RandomStreamInterface.choice)
* made 'Random.PCGRandomLib' no longer auto-available  
  (see https://chapel-lang.org/docs/1.23/modules/standard/Random/PCGRandomLib.html)

Package Modules
---------------
* added an 'OrderedSet' module supporting sets that maintain ordering  
  (see https://chapel-lang.org/docs/1.23/modules/packages/OrderedSet.html)
* added `leastSquares()` to the 'LinearAlgebra' module  
  (see https://chapel-lang.org/docs/1.23/modules/packages/LinearAlgebra.html#LinearAlgebra.leastSquares)
* added `eigh()` and `eigvalsh()` to the 'LinearAlgebra' module  
  (see https://chapel-lang.org/docs/1.23/modules/packages/LinearAlgebra.html#LinearAlgebra.eigvalsh)
* added support for strided/offset domains in `LinearAlgebra.diag()`  
  (see https://chapel-lang.org/docs/1.23/modules/packages/LinearAlgebra.html#LinearAlgebra.diag)
* merged the `Norm` module into 'LinearAlgebra' and deprecated `Norm`  
  (see https://chapel-lang.org/docs/1.23/modules/packages/LinearAlgebra.html#LinearAlgebra.norm)
* `LinearAlgebra.cholesky()` now halts if matrix is symmetric positive definite
* added a `blockCyclicChunks()` iterator to the 'RangeChunk' module  
  (see https://chapel-lang.org/docs/1.23/modules/packages/RangeChunk.html#RangeChunk.blockCyclicChunks)
* updated the 'Sort' module to number parts in `keyPart()` calls from 0  
  (see https://chapel-lang.org/docs/1.23/modules/packages/Sort.html#the-keypart-method)
* moved 'LinkedLists' from the standard modules to the package modules  
  (see https://chapel-lang.org/docs/1.23/modules/packages/LinkedLists.html)
* fixed problems with compiling the 'Crypto' module with `--llvm`

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added support for `localAccess()` to `BlockCyclic` and `Cyclic` arrays

Mason Improvements
------------------
* added `bash` completion for `mason`
* added interactive modes to `mason new` and `mason init`  
  (see https://chapel-lang.org/docs/1.23/tools/mason/mason.html#starting-a-new-package)
* added `mason publish --create-registry` to more easily create a registry  
  (see https://chapel-lang.org/docs/1.23/tools/mason/mason.html#local-registries)
* added license field to the mason manifest file format  
  (see https://chapel-lang.org/docs/1.23/tools/mason/mason.html#the-manifest-file)
* `mason search` output now places partial matches at the top
* `mason test` now supports substring matching for running tests  
  (see https://chapel-lang.org/docs/1.23/tools/mason/mason.html#testing-your-package)
* `mason build` now skips the registry update if a package has no dependencies
* `mason` key-value flags now all support `--key value` and `--key=value` styles
* `mason external --setup` is now significantly faster
* added second Spack clone in `mason external --setup` to get latest packages  
  (see https://chapel-lang.org/docs/1.23/tools/mason/mason.html#using-spack-dependencies)
* updated `mason` to work with Spack's new GitHub structure
* removed `mason --list` due to similarity with `mason --help`
* `mason publish --ci-check` now checks tests, examples, git tags, and manifest
* added ability for `mason search` to utilize a registry cache

New Tools / Tool Changes
------------------------
* added initial support for Google Protocol Buffers  
  (see https://chapel-lang.org/docs/1.23/tools/protoc-gen-chpl/protoc-gen-chpl.html)
* updated `c2chapel` to use the `in` intent by default for struct arguments  
  (see https://chapel-lang.org/docs/1.23/tools/c2chapel/c2chapel.html)

Interoperability Improvements
-----------------------------
* added support for exporting functions to Python returning `string` or `bytes`
* made `--library-python` defaults more user-friendly  
  (see https://chapel-lang.org/docs/1.23/technotes/libraries.html#python-init-file)
* added checks to prevent passing distributed arrays to `extern` array arguments  
  (see https://chapel-lang.org/docs/1.23/technotes/extern.html#array-arguments)
* restricted types and intents for `extern`/`export` functions to working cases  
  (see https://chapel-lang.org/docs/1.23/technotes/extern.html#allowed-intents-and-types)
* added implicit uses of 'CPtr', 'SysCTypes', and 'SysBasic' to `extern` blocks  
  (see https://chapel-lang.org/docs/1.23/technotes/extern.html#support-for-extern-blocks)
* improved `--llvm` and `extern` block support for macros to include shifts

Performance Optimizations / Improvements
----------------------------------------
* parallelized assignments between large local arrays
* extended parallel array initialization to all eltTypes, not just numeric ones
* added an optimization that reduces overheads for provably local array accesses  
  (e.g. `forall i in A.domain { A[i] = 5; }` now executes much more quickly)
* optimized how domains track the arrays that they govern at execution-time
* optimized local single iteration `coforall` loops
* improved on-clause optimization to no longer trigger when loops are present
* reduced the overheads for creating/destroying arrays with constant domains  
  (e.g. `var arr: [1..1_000_000][1..3] int;` now executes much faster)
* improved performance of associative domains/arrays, `map`, and `set`
* optimized the `-=` operation on maps
* improved performance of local matrix-matrix multiplication in 'LinearAlgebra'
* improved compiler vectorization hinting to LLVM optimization with `--llvm`
* optimized several `string` operations for ASCII-only strings
* made `string.size` an O(1) operation
* eliminated an extra task-private variable for iterators w/out top-level yields

Compilation-Time / Generated Code Improvements
----------------------------------------------
* reduced the compilation time of several `string`/`bytes` operations
* reduced the compilation time for repeated calls to `writef()` and `.format()`
* reduced the amount of code generated for `forall` loops due to fast-followers
* reduced the amount of code generated for common parallel iterators
* removed unnecessary instantiations for certain generic functions
* stopped the compiler from generating (unused) `writeThis()` methods for arrays
* removed unnecessary array temporaries for arrays-of-arrays

Memory Improvements
-------------------
* reduced fragmentation for large allocations
* closed a memory leak in distributed promoted expressions
* closed a memory leak in remote-value-forwarded array views
* closed a memory leak in `shared` variable assignment
* closed a memory leak in `string`/`bytes` multilocale interoperability
* closed memory leaks in the `SparseBlock`, `Hashed` and `Private` distributions

Documentation
-------------
* improved the 'Modules' chapter of the language spec for `use` and `import`  
  (see https://chapel-lang.org/docs/1.23/language/spec/modules.html#access-of-module-contents)
* updated the language specification to discuss `.type` and runtime types  
  (see https://chapel-lang.org/docs/1.23/language/spec/types.html#querying-the-type-of-an-expression)
* updated the description of initializing `sync` variables in the language spec  
  (see https://chapel-lang.org/docs/1.23/language/spec/task-parallelism-and-synchronization.html#synchronization-variables)
* added a section on conflicts to the 'Variables' chapter of the language spec  
  (see https://chapel-lang.org/docs/1.23/language/spec/variables.html#variable-conflicts)
* adjusted spec to make it clearer how loops interact with split initialization  
  (see https://chapel-lang.org/docs/1.23/language/spec/variables.html#split-initialization)
* added an example to the spec to clarify the `defer` statement  
  (see https://chapel-lang.org/docs/1.23/language/spec/statements.html#the-defer-statement)
* fixed function signatures, futures, and notes in HTML render of language spec  
  (e.g., see https://chapel-lang.org/docs/1.23/language/spec/arrays.html#rectangular-array-literals  
   and https://chapel-lang.org/docs/1.23/language/spec/arrays.html#Array.eltType)
* improved links between various documentation of atomic variables  
  (see https://chapel-lang.org/docs/1.23/primers/atomics.html)
* added documentation for (unstable) compiler-defined global variables  
  (see https://chapel-lang.org/docs/1.23/technotes/globalvars.html)
* corrected `blasImpl` and `lapackImpl` values in `LinearAlgebra` documentation  
  (see https://chapel-lang.org/docs/1.23/modules/packages/LinearAlgebra.html#compiling-with-linear-algebra)
* removed `List._checkType()` from public documentation
* added a note to the 'cygwin' docs indicating it's not intended for performance  
  (see https://chapel-lang.org/docs/1.23/platforms/cygwin.html)
* clarified that Mac 'homebrew' users need not build from source  
  (see https://chapel-lang.org/install-mac.html and  
   https://chapel-lang.org/docs/1.23/platforms/macosx.html)

Example Codes
-------------
* updated examples w.r.t. library and namespace changes, array init, and POI

Portability
-----------
* significantly improved portability of `--llvm` to different architectures
* improved checking for supported LLVM version when using `CHPL_LLVM=system`
* fixed a build system bug to better support non-English terminals

HPE-specific Changes and Bug Fixes
----------------------------------
* added support for the 'Lmod' module system in the HPE Cray modules
* expanded the configurations available in the pre-built HPE Cray EX module
* improved the `--cache-remote` operation for `ugni`

Compiler Flags
--------------
* extended `--no-checks` to support `--checks` to re-enable default checks  
  (see https://chapel-lang.org/docs/1.23/usingchapel/man.html)
* made the `--version` flag print whether LLVM was built into the compiler

Runtime Library Changes
-----------------------
* significantly improved `ofi` portability and performance

Launchers
---------
* made launchers more reliably able to find the binary to launch
* added support for arbitrarily long executable names

Generated Executable Flags
--------------------------
* changed `--memLeaks` to avoid emitting any output if there is no leak

Error Messages / Semantic Checks
--------------------------------
* many compilation errors now include a callstack
* compilation errors now use bold when outputting to a compatible terminal
* added const checking for elements of tuple formals
* improved checking for passing a non-`param` value to a `param` argument 
* added an error message for sparse arrays of non-nilable classes
* improved the error message when an `init=` fails to resolve
* added an error message when repeating a module in a `use`/`import` statement  
  (e.g., for `module M { module N {} }`, `use M.N.N.N;` now generates an error)
* improved error messages when modules are used as variables or functions
* added an error message when using qualified access to capture a function ref
* improved error messages for symbol conflicts involving re-exported symbols
* added an error for default init-ing tuples whose elements don't have defaults
* improved checking for invalid changes to an instantiated generic field  
  (see https://chapel-lang.org/docs/1.23/language/spec/generics.html#user-defined-initializers)

Execution-time Checks
---------------------
* improved bounds checking for `string` slicing with `byteIndex` ranges  
  (e.g. `myStr[..(-1):byteIndex]` correctly halts, rather than returning `""`)
* improved checking for casting strings with underscores to real
* made `c_ptrTo()` generate an execution-time error for a remote array  
  (see https://chapel-lang.org/docs/1.23/modules/standard/CPtr.html#CPtr.c_ptrTo)

Bug Fixes
---------
* fixed a bug in which a `return` in a `serial` block squashed parallelism
* fixed a bug in which certain standard module symbols were auto-available
* fixed a problem with `new t` when `t` is a `borrowed class?` type
* fixed an internal error with nilable `shared` field declarations
* fixed a bug with using and importing private parent symbols
* fixed a bug when re-exporting multiple functions with the same name
* fixed a bug with failing to find iterators on a type when importing it
* fixed a bug with accessing a used submodule in an `import` statement
* fixed bugs with accessing an imported module in another `import` statement
* fixed a bug with importing or using nested symbols by default
* fixed bugs where some package modules were missing uses of their parents
* fixed a bug with re-exporting subsymbols from a separate file
* fixed a bug that had enabled `use` to access sibling modules without `super`
* fixed a bug with qualified naming of functions conflicting with local symbols
* fixed a bug with package modules inappropriately accessing parent symbols
* fixed a bug in which loop expressions dropped `param`ness of formal arguments
* fixed several problems with split initialization through `out` arguments
* fixed a bug preventing split initialization for multi-var decls in functions
* fixed an internal error for multiple instantiations of a generic field
* made `string` and `bytes` slices respect the range's alignment
* fixed an off-by-one error in multilocale `string`/`bytes` interoperability
* fixed a problem with sizes of string literals containing escapes
* fixed a bug in associative domain `^=` operator
* fixed a bug in `map` `-=` and `&=` operators
* fixed deinit of remote `sync` variables
* fixed a bug in 'DistIterators' in which 2-locale runs used the wrong locale
* fixed several problems with `isDefaultInitializable()`
* fixed a race in `domain.contains()`
* fixed a bug in `DateTime.now()` that was assuming 1-based tuple indexing
* fixed a race-y OOB error in some of the 'Sort' routines
* fixed some bugs in the `dynamic()` iterator relating to integer overflow
* removed redundant control flow in `LinearAlgebra.transpose()`
* fixed a bug in which restarting 'VisualDebug' silently overwrote its data
* fixed a bug in which some 'NetCDF' routines were missing their `use` clauses
* fixed a bug with the 'TOML' `parseLoop` method
* fixed a bug in 'TOML' parser where line numbers in errors were incorrect
* fixed the rendering of several expression types in `chpldoc`
* fixed an internal error encountered with certain `lifetime` clauses
* fixed problems with initializing a channel from another channel
* fixed a bug where `mason test` tried to run programs that failed to compile
* fixed a bug in which 1-character filenames generated an error in `mason`
* added help output for `mason init --help`
* fixed a bug where `mason update --help` ran `mason update`

Platform-specific bug fixes
---------------------------
* resolved deadlocks from `sync` variables on ARM systems

Packaging / Configuration Changes
---------------------------------
* added a docker image that uses GASNet's `smp` conduit for faster execution
* switched from supporting cce-classic to clang-based cce
* changed 'Shasta' to 'HPE Cray EX', reflecting product branding  
  (see https://chapel-lang.org/docs/1.23/platforms/cray.html#getting-started-with-chapel-on-hpe-cray-ex-systems)
* removed support for Cray XE
* removed the KNL locale model
* removed the old `PERFORMANCE.md` file in favor of using the website  
  (see https://chapel-lang.org/performance.html)
* made the `make check` step no longer use `--cc-warnings`

Third-Party Software Changes
----------------------------
* added a bundled copy of `libfabric`, version 1.10
* added the `whereami` library for portably locating the current binary's path  
  (see https://github.com/gpakosz/whereami)
* upgraded GMP to version 6.2.0
* upgraded LLVM to version 10.0.1
* simplified the third-party linking support scripts

Developer-oriented changes: Documentation improvements
------------------------------------------------------
* fixed the alphabetization of packages in LICENSE and third-party/README
* adjusted module documentation generation to avoid deprecation warning

Developer-oriented changes: Module changes
------------------------------------------
* extended support for split-initialization to internal and standard modules
* updated `map` to use a hash table instead of an associative array
* remove a superfluous `ref` intent from methods in 'List'
* removed a workaround in the 'FileSystem' module now that `import` is done

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* made the Makefiles remove `chpl-env-gen.h` on `make clean`
* squashed backend warnings about string operation overflows for GCC 9
* only try to build compiler once with `make mason`

Developer-oriented changes: Compiler Flags
------------------------------------------
* added flags to control the automatic `localAccess` optimization  
  (see `--[no-][dynamic-]auto-local-access` in `man chpl` for disabling it)  
  (see `--[no-]report-auto-local-access` in `man chpl` for verbose output)

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* made `use` within internal modules private-by-default, as elsewhere
* added support for `INT_ASSERT()` to take an optional AST as its first argument
* enabled `%` format argument checking for `INT_FATAL`/`USR_FATAL`-style calls
* added "get visible symbols" primitive to print symbols visible at its callsite
* extended AST traversal patterns to print out missing ImportStmt functionality
* extended `gdb` and `lldb lview` command for Chapel AST nodes to accept consts
* added the ability to apply pragmas to `forwarding` declarations
* increased code reuse in the `import` statement implementation
* asserted that `gBoundsChecking` is a `param` within the compiler

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added a `CHPL_RT_MD_MLI_DATA` descriptor for multilocale interop allocations

Developer-oriented changes: Testing System
------------------------------------------
* added scripts to support nightly testing with AddressSanitizer
* made multilocale and examples memory leak testing report leaks as failures
* added a new `-valgrindexe` flag to the `nightly` testing script
* removed `CHPL_APP_LAUNCH_CMD` in favor of `CHPL_TEST_LAUNCHCMD`
* added nightly testing of the HDF5 module
* fixed a bug about name conflicts between the executable and output file
* `-memleaks` and `-memleakslog` in scripts now correspond to executable flags
* updated test scripts to be ready for Discourse-based mailing lists
* rephrased filtered error messages to express greater confidence in them
* wipe mason git submodules at the beginning of nightly testing
* made various improvements to reduce noise in mason testing


version 1.22.1
==============

Update to twenty-fifth public release of Chapel, June 2020  
(see also changes below for 1.22.0)

Portability
-----------
* fixed portability issues in our code w.r.t. gcc 10.x


version 1.22.0
==============

Twenty-fifth public release of Chapel, April 16, 2020  
Second release candidate for Chapel 2.0 (RC2)

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* converted major instances of implicit indexing to be 0- rather than 1-based:
  - tuples
  - varargs arguments
  - `string` and `bytes`
  - array literals
  - type-inferred captures of iterator expressions
  - random number streams
  - field numbering
  - related library routines

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* changed tuples to use 0-based indexing rather than 1-based  
  (e.g., `(1.2, 3.4)[1]` now returns `3.4` where it used to return `1.2`)
* similarly, varargs arguments now use 0-based indexing rather than 1-based  
  (e.g., in `foo(1,2); proc foo(xs...) {}`, `xs(1)` is `2` where it was `1`)
* dimensional queries on multidimensional domains and arrays are now 0-based  
  (e.g., in `var A: [1..5, 0..2] int;`, `A.dim(1)` is now `0..2`, not `1..5`)
* changed the `string` and `bytes` types to be 0-based by default  
  (e.g., `"Chapel"[1]` now returns `"h"` where it used to return `"C"`)
* changed `find()` and `rfind()` on `string`/`bytes` to return -1 on failure  
  (e.g., see https://chapel-lang.org/docs/1.22/builtins/String.html#String.string.find)
* changed array literals to have 0-based domains by default  
  (e.g., `[1.2, 3.4]` now has type `[0..1] real` rather than `[1..2] real`)
* changed inferred-type captures of iterator expressions to use 0-based arrays  
  (e.g., in `var A = myIter();` A's domain is now `[0..]` rather than `[1..]`)

Standard Library Modules
------------------------
* changed the 'List' module to use 0-based indexing of the `list` type  
  (see https://chapel-lang.org/docs/1.22/modules/standard/List.html#List.list)
* 'Map' module methods that return arrays now return 0-based arrays  
  (e.g., see https://chapel-lang.org/docs/1.22/modules/standard/Map.html#Map.map.toArray)
* streams in 'Random' module now count from 0 rather than 1  
  (e.g., see https://chapel-lang.org/docs/1.22/modules/standard/Random.html#Random.RandomStreamInterface.skipToNth)
* field-based queries in 'Reflection' now count fields from 0 rather than 1  
  (e.g., see https://chapel-lang.org/docs/1.22/modules/standard/Reflection.html#Reflection.getField)
* `getFieldIndex()` in 'Reflection' now returns -1 when a field is not found  
  (see https://chapel-lang.org/docs/1.22/modules/standard/Reflection.html#Reflection.getFieldIndex)

Memory Improvements
-------------------
* closed leaks in strings and bytes for certain multi-locale executions

Documentation
-------------
* added `import` statements to the modules primer and language specification  
  (see https://chapel-lang.org/docs/1.22/primers/modules.html  
   and https://chapel-lang.org/docs/1.22/language/spec/modules.html#importing-modules)
* documented module renaming via `use` in the modules primer and language spec  
  (see https://chapel-lang.org/docs/1.22/primers/modules.html  
   and https://chapel-lang.org/docs/1.22/language/spec/modules.html#using-modules)
* moved the description of `use` statements to the 'Modules' spec chapter  
  (see https://chapel-lang.org/docs/1.22/language/spec/modules.html#using-modules)
* added `import` pattern to each documented module's 'usage' section  
  (e.g., see https://chapel-lang.org/docs/1.22/modules/standard/DateTime.html)

Syntax Highlighting
-------------------
* added the `import` keyword to various syntax highlighters

Error Messages / Semantic Checks
--------------------------------
* improved several error messages related to out-of-bounds indexing

Bug Fixes
---------
* fixed a bug in the mason spack spec parser and simplified its implementation
* fixed a bug in `mason add --external` where some versions were not allowed
* updated some stale code in the 'HDF5' module


version 1.21.0
==============

Twenty-fourth public release of Chapel, April 9, 2020

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* namespace/module improvements:
  - added support for `import` statements as a precise way of accessing modules
  - added support for relative `import`/`use` chains via `this` and `super`
  - implemented prototypical support for storing submodules in different files
  - made `use` private by default and added support for renaming modules
  - sub-modules no longer have lexical visibility into their parent modules
  - reduced the degree to which standard module symbols leak into user code
* language:
  - the `locale` type now has value semantics
  - strings are now validated to ensure they are UTF8
  - significantly improved the `bytes` type, making it on par with `string`
  - added support for split-initialization of variables, types, params, refs
  - improved the compiler's support for copy elision and deinitialization
  - made `Error` classes store strings and preserve line numbers
  - added several features in support of index-neutral programming
  - improved numerous core features related to backwards-breaking changes
* performance:
  - improved the performance/scalability of creating distributed arrays/domains
  - improved the compiler's unordered operation optimization
  - extended `unorderedCopy()` to all trivially copyable types
  - improved the performance of `on`-statements for Infiniband networks
  - improved the performance and correctness of misaligned `ugni` transfers
  - optimized more cases involving zippered loops over distributed arrays
  - optimized 1D array re-allocations to be in-place when possible
  - improved the performance of serial I/O
* additional highlights:
  - converted the language specification from PDF to HTML
  - made several usability improvements to the `mason` package manager
  - improved support for Python-Chapel interoperability
  - significantly improved `ofi` functionality, portability, and performance
  - added a routine for writing arrays to HDF5 files in parallel across locales
  - closed a number of memory leaks

Syntactic / Naming Changes
--------------------------
* `private config`s must now be fully qualified when set on the command-line
* made minor adjustments to the argument names of `string` and `bytes` methods

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* made `use` private by default  
  (see https://chapel-lang.org/docs/1.21/language/spec/statements.html#the-use-statement)
* sub-modules no longer have lexical visibility into their parent modules  
  (see https://chapel-lang.org/docs/1.21/language/spec/modules.html#nested-modules)
* the `locale` type now has value semantics and a default value of `Locales[0]`
* strings are now validated to ensure they are UTF8
* `bytes.this` and `bytes.these` now return/yield `uint(8)` instead of `bytes`  
  (see https://chapel-lang.org/docs/1.21/builtins/Bytes.html)
* stopped generating `init=` functions for records with a user-defined `init=`
* an `init=` containing compilerError() now indicates the type is not copyable  
  (see https://chapel-lang.org/docs/1.21/technotes/initequals.html#disabling-copyability)
* added support for split initialization of variables, refs, types, and params  
  (see https://chapel-lang.org/docs/1.21/language/spec/variables.html#split-initialization  
   and https://chapel-lang.org/docs/1.21/language/evolution.html#split-initialization)
* added support for copy elision transformations  
  (see https://chapel-lang.org/docs/1.21/language/evolution.html#copy-elision  
   and https://chapel-lang.org/docs/1.21/language/spec/variables.html#copy-elision)
* improved `out` intents to support split initialization and to reduce copies  
  (see https://chapel-lang.org/docs/1.21/language/spec/procedures.html#the-out-intent)
* `record` temporaries may now be deinitialized at the end of a statement  
  (see https://chapel-lang.org/docs/1.21/language/evolution.html#deinitialization-point-of-nested-call-expressions  
   and https://chapel-lang.org/docs/1.21/language/spec/variables.html#deinit-points)
* compile-time (`type`, `param`) methods now require `override` when overridden  
  (see https://chapel-lang.org/docs/1.21/language/spec/classes.html#overriding-base-class-methods)
* made `enum` casts that may fail throw an error rather than halt  
  (see https://chapel-lang.org/docs/1.21/language/spec/conversions.html#explicit-enumeration-conversions)
* prototype modules are no longer treated specially with respect to nilability
* added an execution-time check to guard against resizing arrays of non-nilable  
  (see https://chapel-lang.org/docs/1.21/language/spec/classes.html#class-values)
* assignment overloads for classes are no longer permitted

New Features
------------
* added support for `import` statements as a more precise way of using modules
* added support for renaming a module in its `use` statement
* added explicit relative `import` and `use` chains via `this` and `super`  
  (see https://chapel-lang.org/docs/1.21/language/spec/statements.html#the-use-statement)
* implemented prototypical support for storing submodules in different files  
  (see https://chapel-lang.org/docs/1.21/technotes/module_include.html)
* added atomic `compareExchange()` that matches the semantics of C++  
  (see https://chapel-lang.org/docs/1.21/builtins/Atomics.html#Atomics.compareExchange)
* added support for changing the memory management policy of a class object  
  (see https://chapel-lang.org/docs/1.21/builtins/OwnedObject.html#OwnedObject.owned.create  
   and https://chapel-lang.org/docs/1.21/builtins/SharedObject.html#SharedObject.shared.create)
* added support for looping directly over heterogeneous tuples  
  (see https://chapel-lang.org/docs/1.21/language/spec/tuples.html#iteration-over-tuples)
* added a `.indices` query for tuples, strings, bytes, arrays, and lists  
  (see https://chapel-lang.org/docs/1.21/builtins/ChapelTuple.html#ChapelTuple.tuple.indices,  
   https://chapel-lang.org/docs/1.21/builtins/Bytes.html#Bytes.bytes.indices,  
   https://chapel-lang.org/docs/1.21/builtins/String.html#String.string.indices,  
   https://chapel-lang.org/docs/1.21/builtins/ChapelArray.html#ChapelArray.indices,  
   and https://chapel-lang.org/docs/1.21/modules/standard/List.html#List.list.indices)
* added support for `.first` and `.last` queries on an `enum` type  
  (see https://chapel-lang.org/docs/1.21/language/spec/types.html#enum.first)
* added support for (upper) open-interval ranges  
  (e.g., `lo..<hi` represents 'lo, lo+1, lo+2, ..., hi-2, hi-1')  
  (see https://chapel-lang.org/docs/1.21/language/spec/ranges.html#range-literals)
* records now support lexicographical comparison with `<`, `<=`, `>`, `>=`  
  (see https://chapel-lang.org/docs/1.21/language/spec/records.html#default-comparison-operators)
* added a `.hostname` method to locales  
  (see https://chapel-lang.org/docs/1.21/builtins/ChapelLocale.html#ChapelLocale.locale.hostname)
* added `string.encode()` to convert strings with escaped data to `bytes`  
  (see https://chapel-lang.org/docs/1.21/builtins/String.html#String.string.encode)
* added support for `enum` serving as an "any enumerated type" type constraint  
  (e.g., `proc foo(e: enum) ...` can take any enum as an argument)

Feature Improvements
--------------------
* improvements to the `bytes` type:
  - `bytes` now supports `param` values
  - `bytes` now supports `toByte()`  
    (see https://chapel-lang.org/docs/1.21/builtins/Bytes.html#Bytes.bytes.toByte)
  - `bytes` now supports comparison operations
  - added `bytes.format()`, similar to `string.format()`
  - `bytes` can now be cast to `enum`
  - `bytes` can now be indexed with `byteIndex`
  - `bytes` can now be used as the index type for associative domains
* added a `policy` argument to some `string` factories to escape non-UTF8 data
* made all `Error` classes store a string to describe the error
* made thrown errors preserve the original line number when rethrown
* made postfix-`!` no longer required to access `param` and `type` fields
* improved resolution of methods and fields, particularly for private types
* non-nilable classes are now considered subtypes of their nilable counterparts
* improved the implementation of left shift (`<<`) on integers  
  (see https://chapel-lang.org/docs/1.21/language/spec/expressions.html#shift-operators)
* made `extern` blocks automatically generate an implicit `use SysCTypes`

Deprecated / Unstable / Removed Language Features
-------------------------------------------------
* disabled associative arrays of non-nilable classes
* deprecated `.length`/`.numIndices`/`.numElements` queries in favor of `.size`
* deprecated `new owned/shared(c)` in favor of `owned/shared.create(c)`
* deprecated postfix-`!` on class types in favor of using casts
* deprecated `string` vs. `bytes` comparisons
* deprecated `decodePolicy.ignore` in favor of new `decodePolicy.drop`  
  (see https://chapel-lang.org/docs/1.21/builtins/Bytes.html#Bytes.bytes.decode)
* deprecated support for spaces in query expressions  
  (e.g. `proc foo(arg: ? t)` or `proc foo(args... ? n)`)
* deprecated C++-style deinitializer names e.g. `proc ~C()`
* deprecated the use of `enumerated` as a way of saying "any `enum`"
* added an unstable warning for `new borrowed C()`
* added an unstable warning for semi-concrete enums
* added an unstable warning for enums with repeated values
* added an unstable warning for arrays with negative strides
* added an unstable warning for identifiers beginning with `chpl_` or `_`
* added an unstable warning for using first-class functions
* added an unstable warning for the `union` type
* removed deprecated "array-as-vector", "array-as-map/set" capabilities
* removed overloads of `+` between strings and non-string values
* removed previously deprecated `string` initializers
* removed `ascii()` and `asciiToString()`
* removed support for deprecated `init` copy initializers
* removed opaque domains and arrays
* removed comparison operators for `imag` values
* removed the temporary `enableParScan` configuration parameter

Deprecated / Removed Library Features
-------------------------------------
* deprecated `makeRandomStream()` in favor of `createRandomStream()`  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Random.html#Random.createRandomStream)
* deprecated `regexp` in favor of `regexp(string)`
* deprecated methods on `channel` used to get, set, or clear error codes
* removed deprecated sort functions
* removed deprecated versions of `open()` from 'IO'
* removed `LINGER`, `SUBSCRIBE`, `UNSUBSCRIBE` and `setsockopt` from 'ZMQ'

Standard Library Modules
------------------------
* adjusted I/O routines to support non-UTF8 paths/filenames via escaped strings
* stopped including most 'IO' symbols by default  
  (see https://chapel-lang.org/docs/1.21/builtins/ChapelIO.html  
   and https://chapel-lang.org/docs/1.21/modules/standard/IO.html)
* enabled special methods for I/O such as `readThis` or `writeThis` to `throw`  
  (see https://chapel-lang.org/docs/1.21/builtins/ChapelIO.html#readthis-writethis-readwritethis  
   and https://chapel-lang.org/docs/1.21/primers/specialMethods.html#io-methods)
* adjusted several `channel` methods in the 'IO' module to `throw`  
  (see https://chapel-lang.org/docs/1.21/modules/standard/IO.html)
* added `channel.readbytes` and updated `channel.readline` to support `bytes`  
  (see https://chapel-lang.org/docs/1.21/modules/standard/IO.html#IO.channel.readbytes  
   and https://chapel-lang.org/docs/1.21/modules/standard/IO.html#IO.channel.readline)
* the regular expression type `regexp` is now generic and supports `bytes`  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Regexp.html#Regexp.regexp)
* updated `map` to work with nilable `owned` and non-nilable `shared` classes  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Map.html#Map.map.getBorrowed)
* added a `map.keys()` iterator  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Map.html#Map.map.keys)
* moved the `parSafe` field in `map` to be after `keyType` and `valType`  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Map.html#Map.map)
* added an initializer to the `Error` base class that accepts a string message  
  (see https://chapel-lang.org/docs/1.21/builtins/ChapelError.html#ChapelError.Error)
* added `math.isclose()` for approximate equality checking  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Math.html#Math.isclose)
* updated `canResolve()` to return `false` when encountering a `compilerError`  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Reflection.html#Reflection.canResolve)
* added `isCopyable()`, `isAssignable()`, `isDefaultInitializable()` to 'Types'  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Types.html#Types.isCopyable)
* added `c_aligned_alloc()` to the 'CPtr' module  
  (see https://chapel-lang.org/docs/1.21/builtins/CPtr.html#CPtr.c_aligned_alloc)
* `defaultRNG` can now be used to select the default random number generator  
  (see https://chapel-lang.org/docs/1.21/modules/standard/Random.html#Random.defaultRNG)
* stopped including the 'CommDiagnostics' module by default

Package Modules
---------------
* added a routine to write a single HDF5 file in parallel with multiple locales  
  (see https://chapel-lang.org/docs/1.21/modules/packages/HDF5/IOusingMPI.html#IOusingMPI.hdf5WriteDistributedArray)
* moved `hdf5ReadDistributedArray() into a sub-module named 'HDF5.IOusingMPI'  
  (see https://chapel-lang.org/docs/1.21/modules/packages/HDF5/IOusingMPI.html#IOusingMPI.hdf5ReadDistributedArray)
* added additional HDF5 symbols to the 'C_HDF5' module  
  (see https://chapel-lang.org/docs/1.21/modules/packages/HDF5/C_HDF5.html)
* extended `LinearAlgebra.eig()` to support `complex` types  
  (see https://chapel-lang.org/docs/1.21/modules/packages/LinearAlgebra.html#LinearAlgebra.eig)
* added support for `bytes` messages to the 'ZMQ' module
* improved comparison sort to better handle arrays containing `owned` classes
* improved the performance of `mergeSort()`
* improved the performance of the 'EpochManager' by removing a counter
* enabled remote value forwarding for `DistributedDeque` and `DistributedBag`

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* parallelized scan operations for `PrivateDist`
* implemented `.localSlice()` for `Replicated` arrays
* optimized distributions for when nil-checks are enabled

New Tools / Tool Changes
------------------------
* added `mason init` subcommand for creating a package in an existing directory  
  (see https://chapel-lang.org/docs/1.21/tools/mason/mason.html#starting-a-new-package)
* added `mason new --name` flag to differentiate package name from directory  
  (see https://chapel-lang.org/docs/1.21/tools/mason/mason.html#starting-a-new-package)
* added a feature to run a subset of tests in a mason package with `mason test`  
  (see https://chapel-lang.org/docs/1.21/tools/mason/mason.html#testing-your-package)
* improved the output for `mason update` with multiple registries
* improved the error message when `mason run` is used without building first
* added a `--project-version` flag to `chpldoc`  
  (see https://chapel-lang.org/docs/1.21/tools/chpldoc/man.html)
* fixed copyright formatting bugs in `chpldoc` when run without an author
* fixed a bug in `chpldoc` with intervening single line comments
* improved syntax highlighting for `highlight`

Interoperability Improvements
-----------------------------
* added support for passing strings with embedded null bytes externally
* mapped Chapel strings to Python strings instead of Python bytes
* added support for the `bytes` type to Python interoperability

Performance Optimizations / Improvements
----------------------------------------
* improved the performance and scalability of distributed array/domain creation
* improved the unordered compiler optimization to optimize more cases  
  (see `--optimize-forall-unordered-ops` in `man chpl`)
* extended `unorderedCopy()` to all trivially copyable types
* increased cases where zippered distributed array iteration can be optimized
* significantly improved the performance and correctness of `--cache-remote`
* improved the performance of `on`-statements for InfiniBand networks
* optimized 1D array re-allocations to be in-place when possible
* added short-circuiting for array reallocations whose indices didn't change
* improved the performance of serial I/O
* optimized sparse domain assignment between COO and CSR/CSC
* improved the performance of assigning an empty sparse domain
* improved the performance of comparison sorts
* enabled warming up the runtime before calling user-code

Cray-specific Performance Optimizations/Improvements
----------------------------------------------------
* improved the performance of misaligned GETs under `ugni` communication
* minimized memory pressure from short-lived tasks issuing bulk communications
* increased the default number of memory regions under `ugni` communication

Memory Improvements
-------------------
* closed memory leaks related to first-class functions
* closed a leak in array views
* closed leaks in `Cyclic` and `BlockCyclic` distributions
* closed a leak in functions with variadic string arguments
* closed a leak when returning a tuple from a paren-less function
* closed a leak in loop-based array initialization with throwing functions
* closed memory leaks in comparison sorts
* fixed problems with memory management of unions

Documentation
-------------
* converted the language specification from PDF (LaTeX) to HTML (rst)  
  (see https://chapel-lang.org/docs/1.21/language/spec/)
* generally updated documentation with respect to the changes in this release
* improved the documentation for `owned` and `shared` classes  
  (see https://chapel-lang.org/docs/1.21/builtins/OwnedObject.html  
   and https://chapel-lang.org/docs/1.21/builtins/SharedObject.html)
* improved the description of tuple semantics in the language specification  
  (see https://chapel-lang.org/docs/1.21/language/spec/tuples.html#value-tuples-and-referential-tuples)
* increased usage of the `:throws:` tag in library documentation
* added details about special I/O methods to the forwarding technote  
  (see https://chapel-lang.org/docs/1.21/technotes/forwarding.html#resolving-forwarded-methods)
* improved the documentation of the `UnitTest` module  
  (see https://chapel-lang.org/docs/1.21/modules/packages/UnitTest.html)

Example Codes
-------------
* updated `ra.chpl` to use `localAccess()` rather than a `local` block
* updated example codes to typically use `new C()` over `new owned C()`
* updated example codes to typically avoid using `new borrowed C()`
* updated examples to avoid `.length`, `.numElements`, `.numIndices`
* updated examples to add `throws` to `readThis()`/`writeThis()` routines
* updated example codes with respect to nilability changes
* updated example codes with respect to deinitialization and expiring values
* updated example codes with respect to required `use` statements
* updated `miniMD.chpl` with respect to split initialization changes

Portability
-----------
* reduced third-party linking support scripts' reliance on `libtool`
* increased user program linking consistency across configurations
* improved the portability of the HDFS and Curl modules for 32-bit platforms

Cray-specific Changes and Bug Fixes
-----------------------------------
* brought Cray Shasta support into the mainline Chapel module build system
* fixed several bugs related to misaligned transfers in `ugni` communication

Compiler Flags
--------------
* stopped printing blank flag suggestions for unrecognized flags
* deprecated the `--legacy-classes` flag

Runtime Library Changes
-----------------------
* significantly improved `ofi` functionality, portability, and performance

Launchers
---------
* fixed the CPU count for `slurm-srun` on systems with hyperthreading disabled

Generated Executable Flags
--------------------------
* added an `--lldb` flag to generated executables to aid with debugging

Error Messages / Semantic Checks
--------------------------------
* added a warning for potentially surprising implicit modules
* improved the error message for modules declared in function bodies
* added errors for most ownership transfers from non-nilable owned
* added an error for `new owned X`
* improved compile-time nil-checking to consider copy elision
* improved detection of unsound uses of nilable types
* improved lifetime checking to consider copy elision
* improved error messages for failed array bounds checks
* added an error for assigning an associative domain to a rectangular array
* added checking for uses of global variables before they are initialized
* added an error for mixing user- and compiler-generated `init=` and `=`
* added an error for copy initializers that do not have exactly one argument
* improved error messages for uninitialized variables
* improved error messages for unresolved calls due to missing parentheses
* added errors for certain confusing generic initialization patterns
* improved the error message for secondary methods that are missing their types
* improved error messages for bad var args input to `LinearAlgebra.Matrix()`  
  (see https://chapel-lang.org/docs/1.21/modules/packages/LinearAlgebra.html#LinearAlgebra.Matrix)
* improved error messages for unsupported element types in 'Set' and 'List'
* added safety checks for shift operations on integers by default
* improved checks for generic fields to include undecorated class types
* changed an internal error for unsupported type queries to a user-facing error
* eliminated spurious "this source location is a guess" in some warnings

Bug Fixes
---------
* fixed a bug in which domain-to-string casts were not working as intended
* fixed a bug in which user identifiers could conflict with internal ones
* fixed a bug preventing records with `owned` fields from being swapped (`<=>`)
* fixed a bug involving task-private variables and throwing initializers
* fixed `.localSlice` for `Block` and `Cyclic` arrays
* fixed several problems with type queries of class types
* fixed problems with casts between class types like `C: C?`
* fixed a problem with returning an array of non-nilable owned classes
* fixed a problem with tuples containing `owned` classes passed by `in` intent
* fixed a bug where comparing tuples of mismatched size caused a compiler error
* fixed a bug in which `list.sort()` did not support different comparator types
* fixed a problem with arguments of nested generic type such as `list(Error)`
* fixed compiler crashes for some uses of `numFields()` and `compilerWarning()`
* improved our running task counter for inlined functions with `on`-statements
* stopped considering network atomics as safe for fast-ons
* fixed some bugs in `bytes.decode()`
* fixed a bug with remote `bytes` copies
* fixed a bug with taking the `.type` of a first-class function
* fixed a bug in which 'UnitTest' methods expected 1-based arrays
* fixed a bug in which `RandomStream.choice()` failed for non-numeric types
* addressed two memory errors within the 'Futures' package module
* fixed a bug in which 'DistributedIters' still relied on string + value ops
* addressed problems with updating lists contained within a `map`

Packaging / Configuration Changes
---------------------------------
* updated copyrights to reflect HPE's acquisition of Cray Inc.
* recompute settings files used by `--llvm` in more `make` invocations
* removed GASNet support for Cray XE/XK

Third-Party Software Changes
----------------------------
* upgraded GASNet-EX to version 2020.3.0
* upgraded Qthreads to version 1.15
* updated `chpldoc` to use a bundled chapel domain
* updated the sphinx version used for `chpldoc`

Testing System
--------------
* adapted testing system to work more dependably on Slurm-based systems
* `start_test` can now be run simultaneously in different directories
* `start_test -memleaks` now deletes the existing log file

Developer-oriented changes: Documentation improvements
------------------------------------------------------
* added documentation for multilocale performance/communication count testing
* removed online documentation for some internal functions in the 'IO' module

Developer-oriented changes: Module changes
------------------------------------------
* `locale` is now implemented using a `record` type
* improved the statistical properties of hash functions for records and tuples
* made most uses of standard modules within internal modules `private`
* made most uses of 'ChapelStandard' in internal modules `private`
* replaced `use _ only;` with `import _;` in modules
* made the 'Bytes' module more index-neutral
* changed `_ddata` initialization to be param-controlled
* changed `MPI_Abort()` calls into `halt()`s in 'MPI' for cleaner teardowns

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* set nitpick flag to default to catch cross-reference errors in docs builds
* squashed back-end warnings about incompatible pointer types

Developer-oriented changes: Compiler Flags
------------------------------------------
* added a `--[no]-split-initialization` to disable/enable split initialization
* added a `--[no]-early-deinit` flag to disable/enable early deinitialization
* added a `--[no]-copy-elision` flag to disable/enable copy elision

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* improved debugging output for multilocale interop. marshalling routines
* started printing loop information and submodules in AST logs
* removed a bad optimization that was breaking internal module visibility rules
* simplified visible function determination of `use` statement visibility
* added a cache for determining if an actual's type is coercible
* only check visibility of symbols once per scope
* made the compiler munge internal module symbols and stopped munging fields
* improved resolution of calls performing string literal initialization
* dead-code eliminated unused calls to `chpl__convertValueToRuntimeType`
* removed `PRIM_TYPE_INIT`

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added `debug`/`nodbg` to runtime library paths, reducing the need to rebuild
* updated verbose communication output to include comm ID numbers
* optimized verbose comm diagnostics calls
* simplified and improved `ugni`'s processor atomic implementation
* added support for testing the `numa` locale model on non-NUMA systems

Developer-oriented changes: Testing System
------------------------------------------
* added current git branch/sha to `start_test` output
* improved testing error message when compilation fails
* nightly memory leak testing now reports errors if postprocessing fails
* fixed annotations for compiler performance graphs
* added support for `CHPL_LAUNCHER_REAL_WRAPPER` for slurm-gasnetrun launchers


version 1.20.0
==============

Twenty-third public release of Chapel, September 19, 2019  
First release candidate for Chapel 2.0 (RC1)

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* language:
  - completed the conversion of the `string` type from ASCII to UTF-8
  - added a new `bytes` type for representing arbitrary binary data
  - improved safety by distinguishing whether class types can store `nil`
  - improved managed class types w.r.t. generic management and argument passing
  - improved support for partial and complete instantiations of generic types
  - added `private use` and required `use` of top-level modules for name safety
  - improved the user-facing interfaces for `atomic` types
  - added the `nothing` type and `none` value to avoid dual meanings of `void`
* libraries and domain maps:
  - added `list`, `set`, `map` types to replace array-as-vector/-map features
  - added a new `UnitTest` module with support via `mason test`
  - added new `Reflection` routines to reason about source code locations
  - added a new `EpochManager` package for concurrent memory reclamation
  - made several improvements to the `LinearAlgebra` and `Sort` packages
* performance improvements:
  - improved the affinity and performance of parallel loops
  - optimized bulk transfers for Block-distributed arrays
  - enabled compiler-generated unordered operation optimizations by default
  - improved the performance and usability of unordered operations for users
  - enabled the parallel implementation of scans on 1D local and `Block` arrays
  - improved the performance of parallel-safe data structures
* additional highlights:
  - added support for creating multi-locale libraries callable from Python or C
  - added initial support for a pre-built Chapel module on Cray Shasta systems
  - improved compiler errors for failures in resolution and generic routines
  - improved `mason` w.r.t. testing, publishing, searching, and working offline
  - improved completeness/portability for libfabric providers via CHPL_COMM=ofi
  - improved the robustness of the LLVM back-end

Syntactic/Naming Changes
------------------------
* added new reserved keywords: `bytes`, `none`, `nothing`, `void`
* changed atomic memory orders to a new `memoryOrder` enum  
  (see https://chapel-lang.org/docs/1.20/builtins/Atomics.html#atomics)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* top-level modules must now be `use`d in order to be referenced  
  (see the `Using Modules` and `The Use Statement` sections of the Chapel spec)
* class types must now opt into being able to store `nil` using `?`  
  (e.g., `var myC: C = ...` cannot store `nil` but `var myC: C? = ...` can;  
   see https://chapel-lang.org/docs/1.20/language/evolution.html#nilability-changes)
* for a class `C`, `new C(...)` is now equivalent to `new owned C(...)`  
  (see https://chapel-lang.org/docs/1.20/language/evolution.html#new-c-is-owned)
* for a class `C`, un-decorated `C` now means non-nil and generic management  
  (see https://chapel-lang.org/docs/1.20/language/evolution.html#undecorated-classes-have-generic-management)
* passing owned/shared objects to untyped formals no longer changes their types  
  (see https://chapel-lang.org/docs/1.20/language/evolution.html#new-default-intent-for-owned-and-shared)
* arguments declared with owned/shared types now default to `const ref` intent  
  (see https://chapel-lang.org/docs/1.20/language/evolution.html#new-default-intent-for-owned-and-shared)
* string indexing, iteration, and lengths now use codepoint units by default  
  (see https://chapel-lang.org/docs/1.20/builtins/String.html#String.string.length)
* `string.find` now returns `byteIndex` values
* `void` is no longer allowed as the type of a variable (use `nothing` instead)  
  (see 'The Void Type' section in the 'Types' chapter of the spec)
* made `#0` preserve the given indices of a range or domain  
  (e.g., `5..#0` now returns `5..4` rather than `1..0`)
* disabled support for assigning from ranges to multidimensional arrays  
  (see 'Array Assignment' in the `Arrays` chapter of the language spec)
* made slice expressions be governed by their slicing domain  
  (e.g., in `ref B = A[D];` the domain of `B` is `D` rather than a copy of it)
* made `proc foo(x: bool(?))` generic across all bool sizes including `bool`
* `require` statements are now processed relative to the source file directory  
  (see https://chapel-lang.org/docs/1.20/technotes/extern.html#expressing-dependencies)
* class downcasts now throw `ClassCastError` for incompatible runtime types  
  (see 'Explicit Class Conversions' in the spec  
   and https://chapel-lang.org/docs/1.20/language/evolution.html#readme-evolution-nilability-and-casts)
* casts from a C pointer type to a class type now require a nilable class  
  (see https://chapel-lang.org/docs/1.20/language/evolution.html#readme-evolution-nilability-and-casts)
* `isSubtype()` and comparison operators on types no longer consider coercions  
  (see https://chapel-lang.org/docs/1.20/builtins/UtilMisc_forDocs.html#UtilMisc_forDocs.isSubtype)

New Features
------------
* added support for `private` and `public` `use` statements  
  (see 'The Use Statement' in the 'Statements' chapter of the language spec)
* added a built-in `bytes` type  
  (see https://chapel-lang.org/docs/1.20/builtins/Bytes.html)
* added bytes literals `b""`, `b''`, `b""" """`, and `b''' '''`  
  (see https://chapel-lang.org/docs/1.20/builtins/Bytes.html)
* added new postfix `?` and `!` operators to support nilable class features  
  (see https://chapel-lang.org/docs/1.20/language/evolution.html#nilability-changes)
* added support for partial instantiation of generic types  
  (see https://chapel-lang.org/docs/1.20/technotes/partialInstantiations.html)
* generic types can now be passed as `type` arguments and returned  
  (see https://chapel-lang.org/docs/1.20/technotes/partialInstantiations.html#passing-and-returning-generic-types)
* added factory functions for creating strings using existing buffers
* added support for slicing dense arrays using sparse domains
* added a `nothing` type with the singleton value `none`  
  (see 'The Nothing Type' section in the 'Types' chapter of the spec)
* `class`, `record`, and `enum` are now available as generic types  
  (see 'Built-in Generic Types' in the spec)
* added a `byteIndex` type for string indexing  
  (see https://chapel-lang.org/docs/1.20/builtins/String.html#String.byteIndex)
* added 'string.toByte()' and 'string.toCodepoint()'  
  (see https://chapel-lang.org/docs/1.20/builtins/String.html#String.string.toByte)
* added an atomic fence  
  (see https://chapel-lang.org/docs/1.20/builtins/Atomics.html#Atomics.atomicFence)

Feature Improvements
--------------------
* `isClass()` now returns `true` for `owned C` and `shared C`
* `min` and `max` on real values now propagate `NaN` values  
  (see https://chapel-lang.org/docs/1.20/builtins/UtilMisc_forDocs.html#UtilMisc_forDocs.min)
* casts on class types can now compute new types with specific management  
  (see 'Explicit Class Conversions' in the spec)
* added support for `yield`ing within `on`-clauses for inlined serial iterators
* task/forall intents in methods on records now operate on fields of `this`  
  (see 'Task Intents' and 'Forall Intents' in the spec)
* improved complex division to avoid underflow and overflow
* made string slicing more consistent with array slicing w.r.t. OOB errors
* disabled `string.toLower()`/`toUpper()` for codepoints that change byte size
* enabled `var myField: T = expr;` when `T` has no default initializer
* `dmapped` and `new dmap` can now accept an `owned` distribution
* the `ref` return intent is now supported for `extern` procedures
* added support for passing the `string` type to `extern` procedures
* improved how first-class functions print themselves out
* enabled `in`-intents of POD record types in follower iterators

Deprecated / Removed Language Features
--------------------------------------
* deprecated "array-as-vector" methods in favor of the new `list` type  
  (e.g., given `var A: [1..10] real;`, `A.push_back()` is no longer supported)
* deprecated "associative array-as-map" methods in favor of the new `map` type
* deprecated support for applying `+` to string/value pairs  
  (e.g., `"hello " + 1` is no longer supported by default)
* deprecated inequality comparisons on `imag`
* deprecated support for `init`-based copy-initializers; use `init=` instead  
  (see https://chapel-lang.org/docs/1.20/technotes/initequals.html)
* deprecated support for opaque domains and arrays
* deprecated atomic `compareExchange` in favor of `compareAndSwap`  
  (see https://chapel-lang.org/docs/1.20/builtins/Atomics.html#Atomics.compareAndSwap)
* made atomic `peek`/`poke` no longer available by default  
  (see https://chapel-lang.org/docs/1.20/modules/packages/PeekPoke.html)
* deprecated `string.ascii` and `asciiToString`
* deprecated string initializers in favor of new clearer factory functions
* replaced the undocumented `_void` value with `none`
* removed previously deprecated string features  
  (e.g., `string.ulength`, `string.uchars`, `string.codePointIndex`, ...)
* removed support for explicit task/forall intents on `this`

Deprecated / Removed Library Features
-------------------------------------
* repurposed previously deprecated `List` module for the new `list` type
* deprecated algorithm-specific sorts like `bubbleSort()` from `Sort` module
* deprecated `ZMQ.Socket.setsockopt()` in favor of specific setters and getters  
  (e.g., deprecated constant `LINGER` in favor of `Socket.[set|get]Linger()`;  
   see https://chapel-lang.org/docs/1.20/modules/packages/ZMQ.html#ZMQ.Socket.setsockopt)
* retired deprecated usage of `LinearAlgebra.eigvals()`
* removed previously deprecated functions with `out error` arguments from `IO`

Standard Library Modules
------------------------
* added new `list`, `set`, and `map` collection types  
  (see https://chapel-lang.org/docs/1.20/modules/standard/List.html,  
   https://chapel-lang.org/docs/1.20/modules/standard/Set.html,  
   and https://chapel-lang.org/docs/1.20/modules/standard/Map.html)
* added `Reflection` functions to get module/routine/file name and line number  
  (see https://chapel-lang.org/docs/1.20/modules/standard/Reflection.html#Reflection.getLineNumber)
* added a `seek()` method on channels to the `IO` module  
  (see https://chapel-lang.org/docs/1.20/modules/standard/IO.html#IO.channel.seek)
* `channel.mark` now returns the marked offset and throws if there is an error  
  (see https://chapel-lang.org/docs/1.20/modules/standard/IO.html#IO.channel.mark)
* added `signbit` to the `Math` module  
  (see https://chapel-lang.org/docs/1.20/modules/standard/Math.html#Math.signbit)
* added `isNilableClass()` and `isNonNilableClass()` to the `Types` module  
  (see https://chapel-lang.org/docs/1.20/modules/standard/Types.html#Types.isNilableClass)
* added `isGeneric()` to the `Types` module  
  (see https://chapel-lang.org/docs/1.20/modules/standard/Types.html#Types.isGeneric)
* added `isCoercible()` to the `Types` module  
  (see https://chapel-lang.org/docs/1.20/builtins/UtilMisc_forDocs.html#UtilMisc_forDocs.isCoercible)
* made the `CommDiagnostics` module count atomic memory operations  
  (see https://chapel-lang.org/docs/1.20/modules/standard/CommDiagnostics.html)
* added file:line for executeOn in verbose comm diagnostics, matching other ops
* reduced the degree to which standard modules leak symbols into user code

Package Modules
---------------
* added new `UnitTest` module for writing unit tests in Chapel  
  (see https://chapel-lang.org/docs/1.20/modules/packages/UnitTest.html)
* added a new `URL` package module  
  (see https://chapel-lang.org/docs/1.20/modules/packages/URL.html)
* added `AtomicObjects` to support atomic operations on unmanaged classes  
  (see https://chapel-lang.org/docs/1.20/modules/packages/AtomicObjects.html)
* added `LockFreeQueue` and `LockFreeStack` data structures  
  (see https://chapel-lang.org/docs/1.20/modules/packages/LockFreeQueue.html  
   and https://chapel-lang.org/docs/1.20/modules/packages/LockFreeStack.html)
* added an `EpochManager` package to support epoch-based memory reclamation  
  (see https://chapel-lang.org/docs/1.20/modules/packages/EpochManager.html)
* `sort` in the Sort module now uses radix sort for floating point types  
  (see https://chapel-lang.org/docs/1.20/modules/packages/Sort.html#Sort.sort)
* dropped the LLVM back-end requirement for uses of the `HDF5` module
* enabled distributed element-wise operations in the `LinearAlgebra` module
* improved distributed dot product in the `LinearAlgebra` module
* added sparse support for `LinearAlgebra.{isDiag, isSymmetric, isHermitian}`  
  (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra/Sparse.html#Sparse.isDiag)
* added several new operations to the `LinearAlgebra` module:
  - setting the matrix diagonal  
    (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra.html#LinearAlgebra.setDiag)
  - LU factorization  
    (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra.html#LinearAlgebra.lu)
  - computing determinants  
    (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra.html#LinearAlgebra.det)
  - a linear system solver  
    (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra.html#LinearAlgebra.solve)
  - matrix inversion  
    (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra.html#LinearAlgebra.inv)
  - the Jacobi method  
    (see https://chapel-lang.org/docs/1.20/modules/packages/LinearAlgebra.html#LinearAlgebra.jacobi)
* added date and time support to the `TOML` module
* added per-task fences for unordered operations  
  (see https://chapel-lang.org/docs/1.20/modules/packages/UnorderedCopy.html#UnorderedCopy.unorderedCopyTaskFence  
   and https://chapel-lang.org/docs/1.20/modules/packages/UnorderedAtomics.html#UnorderedAtomics.unorderedAtomicTaskFence)
* added support for `param`/`const` source arguments to `unorderedCopy()`
* extended `unorderedCopy()` to support `bool` values  
  (see https://chapel-lang.org/docs/1.20/modules/packages/UnorderedCopy.html#UnorderedCopy.unorderedCopy)
* added support for several setter and getter routines on ZMQ sockets  
  (e.g., added `Socket.getLastEndpoint()`, `Socket.getLinger()`, etc.;  
   see https://chapel-lang.org/docs/1.20/modules/packages/ZMQ.html#ZMQ.Socket.getLastEndpoint)
* added new `Error` subclass `ZMQError` for `ZMQ`-specific errors  
  (see https://chapel-lang.org/docs/1.20/modules/packages/ZMQ.html#ZMQ.ZMQError)
* added support for the `PAIR` socket type to the `ZMQ` module  
  (see https://chapel-lang.org/docs/1.20/modules/packages/ZMQ.html#ZMQ.PAIR)
* renamed 'Buffers.bytes' to 'Buffers.byteBuffer'  
  (see https://chapel-lang.org/docs/1.20/modules/packages/Buffers.html)
* significantly improved the performance and testing of the `Curl` module  
  (see https://chapel-lang.org/docs/1.20/modules/packages/Curl.html)
* fixed the `HDFS` module and added regular testing for it  
  (see https://chapel-lang.org/docs/1.20/modules/packages/HDFS.html)
* reduced the degree to which package modules leak symbols into user code

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added support for adding local indices to distributed sparse domains  
  (see https://chapel-lang.org/docs/1.20/builtins/ChapelArray.html#ChapelArray.bulkAdd)
* added support for bulk addition of indices to distributed sparse domains  
  (see https://chapel-lang.org/docs/1.20/builtins/ChapelArray.html#ChapelArray.makeIndexBuffer)
* optimized the implementation of ownership queries for `Cyclic` domains/arrays
* optimized communication out of `forall` loops over `Cyclic` domains/arrays

New Tools / Tool Changes
------------------------
* added `UnitTest` support to `mason test`  
  (see https://chapel-lang.org/docs/1.20/tools/mason/mason.html#testing-your-package)
* added `mason publish` subcommand to make publishing packages easier  
  (see https://chapel-lang.org/docs/1.20/tools/mason/mason.html#submit-a-package)
* added `mason search --show` flag to display manifest file of package  
  (see https://chapel-lang.org/docs/1.20/tools/mason/mason.html#submit-a-package)
* added `MASON_OFFLINE` to improve offline experience for mason users  
  (see https://chapel-lang.org/docs/1.20/tools/mason/mason.html#environment-variables)
* pinned the version of `Pygments` relied upon by `chpldoc`

Interoperability Improvements
-----------------------------
* added support for multi-locale Chapel libraries  
  (see https://chapel-lang.org/docs/1.20/technotes/libraries.html#using-your-library-in-multilocale-settings)
* the LLVM back-end now supports `--library-python` and `--library-makefile`
* added support for exporting routines that accept/return strings
* added support for overriding environment variables to `--library-makefile`
* `.c` files on the `chpl` command line can now `#include "chplrt.h"`
* `extern` blocks now support unary `+` in `#define` directives  
  (e.g. `#define X (+1)`)
* added support for passing the `string` type to extern procedures

Performance Optimizations/Improvements
--------------------------------------
* enabled optimized bulk transfers for `Block`-distributed arrays by default
* improved the unordered compiler optimization and enabled it by default  
  (see `--optimize-forall-unordered-ops` in `man chpl`)
* enabled a parallel implementation of scans for 1D local and `Block` arrays
* improved task affinity for parallel loops
* optimized `op=` overloads for array/scalar pairs
* improved the speed of parallel-safe `RandomStream` instances
* improved the performance of `sort` and `isSorted` in the `Sort` module
* reduced contention from polling threads for CHPL_COMM=gasnet
* improved the implementation for `log2` and `logBasePow` for integral types
* optimized iteration over `Stencil`-distributed arrays
* created a prototype optimization for slicing arrays by domains  
  (compile with `-schpl_serializeSlices` to enable)

Cray-specific Performance Optimizations/Improvements
----------------------------------------------------
* optimized `unorderedCopy()` for remote destinations
* improved the performance of all unordered operations
* made out-of-memory handling with `ugni` communication more robust

Memory Improvements
-------------------
* minimized memory pressure from short-lived tasks

Documentation
-------------
* added a new chapter to the language specification on error-handling  
  (see the 'Error Handling' chapter in the language specification)
* added a new technical note describing partial instantiations  
  (see https://chapel-lang.org/docs/1.20/technotes/partialInstantiations.html)
* updated `mason` documentation to reflect new mason features  
  (see https://chapel-lang.org/docs/1.20/tools/mason/mason.html)
* documented that a user's environment must support Unicode with UTF8 encoding  
  (see https://chapel-lang.org/docs/1.20/usingchapel/chplenv.html#character-set)
* added `bytes` to the language specification as a primitive type
* clarified that modules that are not referred to are not initialized  
  (see 'Module Initialization' in the spec)
* updated the language specification with respect to other language changes
* updated `chpldoc` documentation to use `--output-dir` instead of `--docs-dir`  
  (see https://chapel-lang.org/docs/1.20/tools/chpldoc/chpldoc.html#documenting-modules)
* updated reductions technote to use memory management annotations  
  (see https://chapel-lang.org/docs/1.20/technotes/reduceIntents.html)
* improved the `--help` description of the `--fast` flag
* added a warning to 'channel.readf' documentation  
  (see https://chapel-lang.org/docs/1.20/modules/standard/IO/FormattedIO.html#FormattedIO.channel.readf)
* removed a reference to old assignment behavior from interoperability technote
* fixed several broken links in the online documentation

Example Codes
-------------
* added a primer for the new `list` type  
  (see https://chapel-lang.org/docs/1.20/primers/listOps.html)
* replaced the `voidVariables` primer with a `nothingVariables` primer  
  (see https://chapel-lang.org/docs/1.20/primers/nothingVariables.html)
* improved the `specialMethods` primer to remove the files it creates  
  (see https://chapel-lang.org/docs/1.20/primers/specialMethods.html)
* disabled some numerically unstable kernels in LCALS

Portability
-----------
* fixed cross-compilation support for GMP builds
* fixed support for `--llvm` with GASNet on Crays
* resolved several warnings when building with GCC 9
* added new environment variables `CHPL_RT_MASTERIP` and `CHPL_RT_WORKERIP`  
  (see https://chapel-lang.org/docs/1.20/usingchapel/launcher.html#chpl-rt-masterip)
* fixed a code portability issue in the `pbs-aprun` launcher

Cray-specific Changes and Bug Fixes
-----------------------------------
* added initial support for a pre-built Chapel module on Cray Shasta systems  
  (see https://chapel-lang.org/docs/1.20/platforms/cray.html#getting-started-with-chapel-on-cray-shasta-systems)
* updated modulefile to work if there is an incompatible cray-mpich pre-loaded
* fixed a problem with --llvm compilation when using dynamic linking on a Cray
* fixed a hang for strided communication

Compiler Improvements
---------------------
* added support for overload-set checking  
  (see https://chapel-lang.org/docs/1.20/technotes/overloadSets.html)
* stopped the compiler from parsing the same file multiple times
* improved the accuracy of detecting infinitely recursive instantiations
* sub-modules that are not referred to are removed early in compilation

Compiler Flags
--------------
* a new `--print-all-candidates` flag gives verbose output for unresolved calls

Error Messages / Semantic Checks
--------------------------------
* function resolution errors now describe a reason for the failure
* compiler errors in generic functions now describe the failing instantiation
* improved checks that procedures return along all paths for `try/catch/throw`
* improved checking for multiple management decorators on a class
* added an error message for incorrect tuple expansion usage
* added a useful error when creating arrays of a generic type
* added an error message for ranges over an enum type with a single value
* made defining a method named 'borrow' a compiler error
* added an error for domain expressions that are types rather than values
* added non-`[const] in` intents error messages in certain interop situations  
  (see https://chapel-lang.org/docs/1.20/technotes/libraries.html#intents  
   and https://chapel-lang.org/docs/1.20/technotes/libraries.html#intents-in-python-interoperability)
* improved error message wording for type mismatches in assignment
* made a user-facing "the type of the actual argument is generic" error

Bug Fixes
---------
* fixed a bug in which internal/standard module symbols shadowed user symbols
* fixed a bug in which the count operator (`#`) was not creating an array alias
* fixed a bug in parallel scans of Block arrays for non-`+` operators
* fixed a bug in which scans of array slices were not working
* fixed several bugs with casting for managed class types
* fixed problems when an `owned` argument is used in a later default expression
* `isRecordType` now returns `false` for `owned` and `shared` classes
* fixed a bug in which parsing files multiple times caused duplicate modules
* fixed a bug in tracking number of non-zeroes for distributed sparse domains
* fixed a bug in index addition to distributed CSC domains
* fixed a bug in which missing line numbers in the IR caused an internal error
* fixed a null-termination issue with `string.join`
* fixed a problem with the string-to-uint cast `"0xffffffffffffffff":uint`
* fixed a bug where `isRecord()` returned true for `string`
* resolved problems when calling `sort` on arrays with aligned domains
* fixed reading of associative domains
* enabled const checking on index variables of forall loops in some cases
* `defer` actions in an iterator are now executed upon a `break` from its loop
* fixed a bug with `use ZMQ` in `--library` compilation
* fixed problems capturing a throwing function as a first-class function
* fixed casts from `real` to `bool` when using --llvm
* the `--dynamic` flag now creates a shared library under the LLVM back-end
* object files generated by the LLVM back-end now respect `CHPL_LIB_PIC=pic`
* fixed a compiler segfault with certain recursive class declarations
* fixed incorrect instantiation for certain generic class methods
* fixed problems with arguments using `new` as a default expression
* fixed bug with error handling for default args giving an incorrect error
* fixed bug with error handling for default args not issuing an error correctly
* fixed a bug where range arguments with `in` intent were not modifiable
* fixed errors in JSON I/O for block arrays
* fixed precision loss when printing real numbers to JSON format
* fixed bug when opening a channel on a different locale from its file
* fixed a bug in override checking
* fixed a bug in the compiler's analysis of non-aliasing arrays
* fixed a `vim` syntax highlighting bug involving domain literals
* fixed bug when shrinking an array with `pop_back()`
* added a thrown error for `FileSystem.mkdir('')` instead of a seg-fault
* fixed a bug in `TOML` where empty lines were not counted in the line number
* fixed `mason test` bug where exit code would not reflect test results
* fixed `mason test` bug in which subdirectories were not being traversed
* fixed a bug in which `mason doc` did not process used modules
* fixed `mason` help flags such that being in a package is not required
* fixed `mason search` to only show bricks that support current Chapel version
* fixed `make mason` such that it will not hang if hugepages is unavailable
* fixed `make mason` to detect changes in any mason source files
* fixed `make clobber` such that it clobbers mason

Packaging / Configuration Changes
---------------------------------
* added a warning for unfamiliar CHPL_*_COMPILER settings
* cleaned up the output of `make` when building Chapel

Third-Party Software Changes
----------------------------
* upgraded GASNet-EX to version 2019.6.0
* upgraded hwloc to version 1.11.13
* updated the LLVM version 8.0
* removed bundled copy of libhdfs3 since this project is no longer maintained
* retired massivethreads tasking

Runtime Library Changes
-----------------------
* made CHPL_COMM=ofi significantly more complete and portable across providers
* I/O buffers are no longer page aligned when the buffer size is very small
* retired massivethreads tasking

Launchers
---------
* made verbose output from launchers include environment variables they set  
  (see https://chapel-lang.org/docs/1.20/usingchapel/launcher.html#chapel-launchers)
* added CHPL_COMM_USE_GDB support to many more launchers  
  (see https://chapel-lang.org/docs/1.20/usingchapel/debugging.html#running-in-gdb)
* improved CPU binding for gasnetrun* launchers
* added a slurm-gasnetrun_mpi launcher

Testing System
--------------
* added support for running multilocale C tests via `start_test`  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/TestSystem.rst#comparing-to-a-c-version)

Developer-oriented changes: Module changes
------------------------------------------
* made many modules use `private use` to avoid leaking names
* added an optimized spinlock wrapper to replace manual test-and-set loops
* `assert()` prints out line numbers from the call site even with `--devel`
* removed stale modules: `ChapelDynDispHack`, `Chapel[Tasks|Tasks]Internal`
* refactored `ChapelStandard` to focus on modules implementing the language
* made arrays "always RVF"
* simplified the standalone parallel iterator for default rectangular arrays
* added missing 'override' keywords to dsiDisplayRepresentation overrides
* moved definition of `chpl_emptyLocale[s|Space]` to remaining `LocaleModel`s
* moved definitions of some `read/writeThis` functions to `ChapelIO`
* eliminated a self-assignment in `chpl__mod`
* added experimental distributed sort to the `Sort` module
* new internal module 'ByteBufferHelpers' for bytes/string buffer management
* new internal module 'BytesStringCommons' for common bytes/string helpers
* added minimum string allocation size 'param chpl_minStringAllocSize=0'

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* added a script that can install the bundled LLVM

Developer-oriented changes: Compiler Flags
------------------------------------------
* added flags to prepend directories to the internal / standard module paths  
  (see `--prepend-internal-module-dir` and `--prepend-standard-module-dir`)
* added `--library-ml-debug` to debug multilocale library communication

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* started respecting "always rvf" pragmas at module scope
* stopped heap-promoting local variables
* addressed several build problems when using newer LLVM versions
* generated `llvm.ident` now includes Chapel compiler information
* `--llvm` compilation avoids generating and compiling C code
* `--llvm` compilation now emits `llvm.lifetime.start` and `llvm.lifetime.end`
* `--llvm-print-ir` can now accept multiple functions to print
* generated more debug information under `--llvm -g`
* `--print-commands` more reliably prints the commands spawned
* added 'dtBytes' to represent the new `bytes` type
* improved an internal error message about actual / formal mismatches
* added new primitives in support of `UnitTest module  
  (see `PRIM_GATHER_TESTS`, `PRIM_GET_TEST_BY_NAME`, `PRIM_GET_TEST_BY_INDEX`)
* removed vestiges of `--heterogeneous` support
* refactored compiler to re-use stripdirectories() function
* the compiler now represents decorated class types with `DecoratedClassType`
* the compiler now handles certain cast calls directly
* added 'FLAG_CHAPEL_BYTES_LITERAL' AggregateType
* fixed an override checking bug with --devel flag

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added CHPL_RT_OVERSUBSCRIBED to generally indicate oversubscribed execution  
  (see https://chapel-lang.org/docs/1.20/usingchapel/tasks.html#overloading-system-nodes)
* fixed the qthreads build when CHPL_HOME doesn't match CHPL_MAKE_HOME
* reading I/O channels now default to using `pread` instead of `mmap`
* I/O plugins implementing Curl and HDFS are now implemented in Chapel
* added support for `bytes` in QIO
* reorganized and simplified runtime support for comm diagnostics
* moved multilocale global var dissemination from comm layers into shared code

Developer-oriented changes: Testing System
------------------------------------------
* added paratest support for `<dir>.notest` to reflect `start_test` behavior
* improved performance graph screenshot quality and resolution
* added Python 3 support for `chpl_launchcmd`
* lowered polling frequency for `chpl_launchcmd`
* rewrote gen-chpl-bash-completion in Python
* fixed a problem with `start_test` when using Python 3.7
* resolved a race condition when `sub_test` creates directories
* added a test suite for `sub_test` filters


version 1.19.0
==============

Twenty-second public release of Chapel, March 21, 2019

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* language:
  - added support for compile-time operations on floating point `param` values
  - improved initializers w.r.t. type aliases and copy initialization
  - improved strings with respect to accesses, iterators, and UTF-8 support
  - added support for lifetime annotations on functions to help with checking
  - added support for compile-time nil-checking to avoid potential errors
  - made `throw` and `catch` operate on `owned` errors
  - added shape / index preservation for scans and range expressions
  - added support for underscores in numeric literals and strings
  - defined `[]`/promotions as implying "may" parallelism vs. `forall`'s "must"
* libraries and domain maps:
  - added support for distributed associative domains/arrays via `HashedDist`
  - added support for unordered copies and non-fetching atomics
  - added a `choice()` method to the `Random` module for weighted sampling
  - added `map()`, `filter()`, and `consume()` for iterators
  - added most of the remaining routines to the `Path` module
  - added convenience routines for creating Block or Cyclic domains and arrays
  - added a parallel radix sort method to the `Sort` module
* performance improvements:
  - added a prototype optimization that makes use of unordered communications
  - added a prototype parallelization of 1D scans for block and default arrays
  - eliminated several remaining sources of memory leaks
  - optimized remote task spawns on Cray systems using `ugni` communication
  - optimized ordered, unordered, and oversubscribed communication for `ugni`
* interoperability:
  - added a `c_array` type for interoperating with fixed-size C arrays
  - improved the previous prototype for interoperating with Python
  - introduced initial support for interoperating with Fortran
* additional highlights:
  - dramatically improved the level of support for the LLVM back-end
  - added a new Open Fabrics Interfaces libfabric-based `ofi` runtime option
  - made `cstdlib` atomics the default for the gcc, clang, and llvm back-ends
  - introduced variants of RA that use unordered atomics and oversubscription
  - added new primers for records, tuples, and special object methods

Packaging / Configuration Changes
---------------------------------
* `CHPL_TARGET_ARCH` now refers to machine types and `CHPL_TARGET_CPU` to cpus  
  (e.g., `export CHPL_TARGET_ARCH=x86_64`, `CHPL_TARGET_CPU=sandybridge`  
   see https://chapel-lang.org/docs/1.19/usingchapel/chplenv.html#chpl-target-arch  
   and https://chapel-lang.org/docs/1.19/usingchapel/chplenv.html#chpl-target-cpu)
* made `cstdlib` atomics the default for gcc, clang and llvm compilers  
  (see https://chapel-lang.org/docs/1.19/usingchapel/chplenv.html#chpl-atomics)

Syntactic/Naming Changes
------------------------
* made `true`, `false`, and numeric type names into reserved words in Chapel  
  (see the 'Keywords' section in the 'Lexical Structure' chapter of the spec)
* added support for underscores in integer and floating point literals  
  (e.g., `1_000_000` is now the same as `1000000`  
   see the 'Literals' section in the 'Lexical Structure' chapter of the spec)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* made `throw` and `catch` operate on `owned` errors, enabling re-throwing  
  (see https://chapel-lang.org/docs/1.19/primers/errorHandling.html)
* for records, compiler-generated `=`, `==`, `!=` now require matching types  
  (see 'Record Assignment' and 'Default Comparison Operators' in the spec)
* `[]`-loops now permit serial execution if parallelism isn't an option  
  (see 'The Forall Statement' in the 'Data Parallelism' chapter of the spec)
* made default string accesses always return a string  
  (see https://chapel-lang.org/docs/1.19/builtins/String.html#String.string.this)
* default initializers for generic types require formal names to match fields  
  (see https://chapel-lang.org/docs/1.19/technotes/initTypeAlias.html)

New Features
------------
* added support for directly initializing atomic variables from values  
  (e.g., `var x: atomic int = 10;`)
* added lifetime annotations for expressing relative lifetimes between arguments  
  (see https://chapel-lang.org/docs/1.19/technotes/lifetimeChecking.html#lifetime-annotations)
* certain dereferences of `nil` values are now caught by the compiler  
  (see https://chapel-lang.org/docs/1.19/technotes/nilChecking.html)
* added support for using type aliases in `new` expressions  
  (see https://chapel-lang.org/docs/1.19/technotes/initTypeAlias.html)
* added support for the `init=` method, a proposed change to copy initializers  
  (see https://chapel-lang.org/docs/1.19/technotes/initequals.html)
* added support for ranges of codepoints and slicing of strings using them  
  (see https://chapel-lang.org/docs/1.19/builtins/String.html)
* added `string.codepoint[s]()` to access and iterate over strings by codepoint  
  (see https://chapel-lang.org/docs/1.19/builtins/String.html#String.string.codepoint  
   and https://chapel-lang.org/docs/1.19/builtins/String.html#String.string.codepoints)
* added `string.byte[s]()` to access and iterate over strings by byte  
  (see https://chapel-lang.org/docs/1.19/builtins/String.html#String.string.byte  
   and https://chapel-lang.org/docs/1.19/builtins/String.html#String.string.bytes)
* added automatic fences for unordered operations at task termination

Feature Improvements
--------------------
* added support for compile-time operations on floating point `param` values
* added config disambiguation for `chpl` arguments via module names  
  (e.g., `-sM.debug=true` can be used to set config `debug` in module `M`)
* made scan expressions preserve the shape/domain of the input expression  
  (e.g., in `var B = + scan A;`, B will have A's shape and domain)
* inferred-type arrays defined using range expressions now preserve indices  
  (e.g., `var A = [i in -2..2] i;` now results an array with domain {-2..2})
* extended `reshape()` to accept loop expressions  
  (e.g., `reshape([i in 1..4] i, {1..2, 1..2})` now works)
* string casts to integral or floating point types may now contain underscores  
  (e.g., `"1_000_000":int` is now supported)
* string casts to integral types can now be in base 2, 8, or 16  
  (e.g., `"0xabcd":int` is now supported)
* array initializer expressions based on range expressions are now parallelized
* added support for declaring homogeneous tuple types using `uint`s  
  (e.g., `param d = 3: uint; var t: d*int;` is now supported)
* added support for `where`-clauses to `extern` procedures
* added support for return type constraints on generic routines

Deprecated and Removed Features
-------------------------------
* removed support for `chpl-ipe`
* removed support for `noinit` for the time being
* deprecated `domain.member()` in favor of `domain.contains()`
* deprecated `string.isEmptyString()` in favor of `string.isEmpty()`  
  (see https://chapel-lang.org/docs/1.19/builtins/String.html#String.string.isEmpty)
* deprecated support for `string.uchars()` in favor of `string.codepoints()`
* deprecated support for `string.ulength()` in favor of `string.numCodepoints()`
* deprecated support for the `codePointIndex` type in favor of `codepointIndex`
* deprecated support for `codePointToString()` in favor of `codepointToString()`
* deprecated the `List` module, renaming it `LinkedList`  
  (see https://chapel-lang.org/docs/1.19/modules/standard/LinkedLists.html)
* deprecated the `BufferedAtomics` module, in favor of `UnorderedAtomics`  
  (see https://chapel-lang.org/docs/1.19/modules/packages/UnorderedAtomics.html)
* removed previously deprecated behavior of `:` in where clauses
* removed previously deprecated `matPlus()`, `matMinus()` from `LinearAlgebra`
* removed previously deprecated `isBLAS_MKL` flag from `BLAS` module

Standard Modules / Library
--------------------------
* improved UTF-8 string support  
  (see https://chapel-lang.org/docs/1.19/builtins/String.html#activating-unicode-support)
* added `Path` routines `[file].absPath()`, `[file].relPath()`, and `normPath()`  
  (see https://chapel-lang.org/docs/1.19/modules/standard/Path.html)
* added `choice()` method to `Random` module for weighted sampling  
  (see https://chapel-lang.org/docs/1.19/modules/standard/Random.html#Random.RandomStreamInterface.choice)
* added `getNext(resultType, min, max)` method to the PCG Random Stream  
  (see https://chapel-lang.org/docs/1.19/modules/standard/Random/PCGRandom.html#PCGRandom.RandomStream.getNext)
* added bounds checking to `getNext(min, max)` in the `Random` module  
  (see https://chapel-lang.org/docs/1.19/modules/standard/Random/PCGRandom.html#PCGRandom.RandomStream.getNext)
* added message sizes to verbose communication diagnostics  
  (see https://chapel-lang.org/docs/1.19/modules/standard/CommDiagnostics.html)
* added cast from integral types to `bigint`  
  (see https://chapel-lang.org/docs/1.19/modules/standard/BigInteger.html#biginteger)
* added `c_offsetof` to get memory offsets for fields in a record  
  (see https://chapel-lang.org/docs/1.19/builtins/CPtr.html#CPtr.c_offsetof)

Package Modules
---------------
* added `map()`, `filter()`, and `consume()` for iterators  
  (see https://chapel-lang.org/docs/1.19/modules/packages/FunctionalOperations.html)
* added parallel radix sort to the `Sort` module and made use of it in `sort()`  
  (see https://chapel-lang.org/docs/1.19/modules/packages/Sort.html)
* added an interface for performing unordered copies  
  (see https://chapel-lang.org/docs/1.19/modules/packages/UnorderedCopy.html)
* added unordered versions of non-fetching atomic operations  
  (see https://chapel-lang.org/docs/1.19/modules/packages/UnorderedAtomics.html)
* renamed `eigvals()` to `eig()` and made `eigvals()` support eigenvalues only  
  (see https://chapel-lang.org/docs/1.19/modules/packages/LinearAlgebra.html#LinearAlgebra.eigvals)
* added checks to `LinearAlgebra` routines to ensure non-distributed arrays
* stopped transitively using `BLAS` and `LAPACK` in the `LinearAlgebra` module

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added `HashedDist` to support distributed associative domains and arrays  
  (see https://chapel-lang.org/docs/1.19/modules/dists/HashedDist.html)
* added support for queries of remote subdomains to most standard domain maps  
  (see https://chapel-lang.org/docs/1.19/builtins/ChapelArray.html#ChapelArray.hasSingleLocalSubdomain)
* added convenience functions to simplify creating Block/Cyclic domains/arrays  
  (see https://chapel-lang.org/docs/1.19/modules/dists/BlockDist.html  
   and https://chapel-lang.org/docs/1.19/modules/dists/CyclicDist.html)

New Tools / Tool Changes
------------------------
* added support for external Spack installations in `mason external`  
  (see https://chapel-lang.org/docs/1.19/tools/mason/mason.html#using-spack-dependencies)
* added `:throw:/:throws:` tags to `chpldoc` for documenting thrown errors  
  (see https://chapel-lang.org/docs/1.19/tools/chpldoc/chpldoc.html#documenting-functions-that-throw)
* improved `c2chapel` handling of functions with pointer arguments
* improved syntax highlighting for `vim`, `source-highlight`, and `highlight`

Interoperability Improvements
-----------------------------
* added a `c_array` type that behaves like a fixed-size C array  
  (see https://chapel-lang.org/docs/1.19/technotes/extern.html#c-array-t-n)
* added the ability to rename external variables and fields  
  (e.g., `extern "x" var c_x: c_int;` lets `x` in C be called `c_x` in Chapel)
* added support for passing Chapel-unique array types opaquely to/from Python/C  
  (see https://chapel-lang.org/docs/1.19/technotes/libraries.html#arrays)
* added support for literal default arguments in routines exported to Python  
  (see https://chapel-lang.org/docs/1.19/technotes/libraries.html#argument-default-values)
* added `c_ptr` Python interop arguments using NumPy arrays or ctypes pointers  
  (see https://chapel-lang.org/docs/1.19/technotes/libraries.html#c-ptr-arguments)
* added initial support for Fortran interoperability including 1D array passing  
  (see https://chapel-lang.org/docs/1.19/technotes/fortranInterop.html)
* enabled casts between `c_string` and `c_ptr(int(8))`/`c_ptr(uint(8))`
* improved extern-block support for structs with fixed-size arrays

Performance Optimizations/Improvements
--------------------------------------
* optimized iteration for Block-distributed arrays
* prototyped parallelized 1D scans for block- and default-distributed arrays  
  (use `-senableParScan` to enable this prototype)
* enabled parallelism for statement-level promotions
* improved the performance of string comparisons for local strings
* optimized internal testAndSet locks
* improved target-compiler optimizations for non-x86 architectures
* added compiler hints to the LLVM back-end for non-aliasing arrays
* enabled more floating point optimizations in the LLVM back-end
* added vectorization hints for the LLVM back-end

Cray-specific Performance Optimizations/Improvements
----------------------------------------------------
* optimized certain forall-loops to take advantage of unordered communication  
  (see `--optimize-forall-unordered-ops` in `man chpl`)
* optimized oversubscribed communication under `ugni`
* optimized small data transfers and fetching atomics under `ugni`
* optimized remote task spawning under `ugni`
* optimized unordered communication under `ugni`

Memory Improvements
-------------------
* addressed memory leaks in sparse domains, reductions, and arrays-of-arrays
* fixed a memory leak when throwing errors from nested coforalls
* fixed a memory leak when popping the last element from an array
* optimized away some unnecessary memory allocations

Documentation
-------------
* added a primer for special methods on classes and records  
  (see https://chapel-lang.org/docs/1.19/primers/specialMethods.html)
* added primers on records and tuples  
  (see https://chapel-lang.org/docs/1.19/primers/records.html  
   and https://chapel-lang.org/docs/1.19/primers/tuples.html)
* added a technical note on `nil`-checking  
  (see https://chapel-lang.org/docs/1.19/technotes/nilChecking.html)
* added a technical note on lifetime checking  
  (see https://chapel-lang.org/docs/1.19/technotes/lifetimeChecking.html)
* removed `examples/programs` from the release due to low perceived value
* added documentation for `CHPL_LIB_PIC`  
  (see https://chapel-lang.org/docs/1.19/technotes/libraries.html#static-and-dynamic-libraries)
* documented that Chapel is now primarily tested using UTF-8  
  (see https://www.chapel-lang.org/docs/1.19/usingchapel/chplenv.html#character-set)
* added documentation of the `:throw:/:throws:` tags in `chpldoc`  
  (see https://chapel-lang.org/docs/1.19/tools/chpldoc/chpldoc.html#documenting-functions-that-throw)
* documented some throwing functions in the standard library documentation
* fixed typos in, and generally improved, various forms of documentation

Example Codes
-------------
* added a variant of HPCC RA that uses unordered atomics  
  (see `examples/benchmarks/hpcc/variants/ra-unordered-atomics.chpl`)
* updated `ra-atomics.chpl` to support oversubscription via a `config`  
  (see `examples/benchmarks/hpcc/ra-atomics.chpl`)
* updated chameneos benchmarks to use direct initializations of atomics  
  (see `examples/benchmarks/shootout/chameneos*.chpl`)
* updated CLBG benchmarks to refer to the proper URL  
  (see `examples/benchmarks/shootout/*.chpl`)
* other minor updates to keep up with Chapel evolution

Portability
-----------
* added an Open Fabrics Interfaces libfabric-based `ofi` communication layer  
  (see https://chapel-lang.org/docs/1.19/platforms/libfabric.html)
* ported Chapel to macOS Mojave
* ensured Chapel supports LLVM 7
* improved the LLVM back-end's ability to find gcc header files
* ported the LLVM back-end to 32-bit x86
* added support for urxvt terminal emulator with CHPL_COMM_USE_[G|LL]DB.  
  (see https://chapel-lang.org/docs/1.19/usingchapel/debugging.html)

Cray-specific Changes and Bug Fixes
-----------------------------------
* improved `ugni` fixed heap behavior near the registration limit  
  (see https://chapel-lang.org/docs/1.19/platforms/cray.html#ugni-communication-layer-and-the-heap)
* allowed specifying fixed heap size as a percentage of physical memory size  
  (see https://chapel-lang.org/docs/1.19/platforms/cray.html#ugni-communication-layer-and-the-heap)
* fixed Python interoperability when using `prgenv-*` compilers
* fixed the LLVM back-end when using `prgenv-*` compilers
* improved the use of the LLVM back-end with GASNet on Cray systems
* fixed support for heterogeneous nodes with GASNet over the `aries` conduit
* fixed a bug in the `MPI` module for `ugni` which gave a compiler error

Compiler Improvements
---------------------
* added support for static linking when using the LLVM back-end
* made `--no-checks` disable several checks in range operations

Compiler Flags
--------------
* added a `--target-cpu` flag for setting `CHPL_TARGET_CPU`
* added a `--[no-]optimize-forall-unordered-ops` flag (off by default)
* removed the `--[no-]warn-constructors` flag

Error Messages / Semantic Checks
--------------------------------
* removed warnings for [op]= overloads whose LHS expressions weren't `ref`  
  (e.g., `proc +=(lhs: C, rhs: C) { ... }` no longer results in a warning)
* added an error for new-expressions without argument lists
* improved error messages for initializers
* added an error for user-defined constructors
* removed the transitional warning for `new C` being borrowed by default
* added an error for `new owned borrowed C()`
* improved lifetime checking within task constructs and initializers
* fixed lifetime checking for module-scope code
* enabled lifetime checking for iterators and loop expressions
* improved errors when throwing from within `coforall`/`begin`/`on`/`cobegin`
* improved errors when throwing something that is not a subclass of `Error`
* made throwing borrowed errors into a compiler error
* added an error when a `use` statement's filters include the module itself
* improved errors when a `use` statement's filters refer to bad symbols
* improved checks that tuple destructuring is only applied to tuples
* improved const checking, for example when assigning to tuples
* improved error messages for creating a `ref` to `nil`
* improved errors for `param` loops over improper ranges
* improved errors relative to unsupported domain / partial domain queries
* added an error for applying `~` to booleans
* added an error for zippered for-loops that invoke parallel iterators
* improved error messages for compile-time `config`s
* squashed references to internal subroutines for certain classes of errors
* improved errors when exported routines return arrays without element types
* added an error for exported routines that have `where` clauses
* improved error messages for generic first-class functions
* added a warning for certain races that occur when promoting a method
* upgraded the format of internal error messages

Execution-time Checks
---------------------
* added an error when remote records are passed to external procedures

Bug Fixes
---------
* fixed support for task-private array variables
* fixed bugs in `writef()`/`readf()`/`format()` for enums without int values
* fixed bugs so that `LinearAlgebra` routines can accept rank-change slices
* made empty `Spawn.spawn()` calls throw errors instead of segfaulting
* fixed a bug when running `subprocess.wait` more than once
* resolved problems when multiple extern blocks `#include`d the same header
* resolved problems for extern blocks with mutually recursive `struct`s
* made `mason search` warn about bad manifest filenames instead of halting
* fixed a bug in which `mason doc` expected project dirs to match package names
* fixed a bug in which certain `try!` patterns caused internal errors
* fixed a bug in which I/O couldn't read integers starting with `+` like `+10`
* iterating over tuples now yields `ref` or `const ref` elements
* `on s` for `owned` or `shared` objects now runs where the object is allocated
* fixed support for forall loops over zippered loop expressions
* fixed support for forall loops over tuple expansion expressions
* enabled tuples to contain `owned` objects
* fixed a bug in range.member(range)
* fixed some bugs/inconsistencies in methods and functions on ranges
* fixed support for `cstdlib` atomics for clang and llvm compilers
* fixed some issues with `--library*` compilation using the LLVM back-end  
  (see https://chapel-lang.org/docs/1.19/technotes/libraries.html#llvm)
* fixed `setchplenv` scripts for `pyenv` users
* fixed a bug in which `PATH` was not quoted in `chpldoc` & `chplvenv` builds
* fixed a problem where `setchplenv` added `' '` to MANPATH
* fixed a bug in which comparing rank-variant domains generated a compiler error
* fixed a bug in which global extern consts were incorrectly localized
* fixed a problem with override-checking for functions with `where`-clauses
* fixed a problem with control flow analysis in functions with `catch` blocks
* converted memcpy() calls that may overlap to use memmove()
* fixed some incorrect buffer sizes found using gcc 8.2 static analysis
* fixed target-compiler optimization flags for non-x86 architectures
* fixed problems caused by toggling `CHPL_LLVM` while running `make`
* fixed an error in the documentation of `string.match`

Third-Party Software Changes
----------------------------
* upgraded GASNet to GASNet-EX version 2018.9.0
* upgraded hwloc to version 1.11.11
* upgraded qthreads to version 1.14
* upgraded re2 to commit 0a6326b
* upgraded LLVM to version 7.0.1 and began storing it in an unpacked manner  
  (see https://www.chapel-lang.org/docs/1.19/usingchapel/chplenv.html#chpl-llvm  
   and https://www.chapel-lang.org/docs/1.19/technotes/llvm.html)
* upgraded fltk to version 1.3.5

Launchers
---------
* added support for setting a node access type for slurm launchers  
  (see https://chapel-lang.org/docs/1.19/usingchapel/launcher.html#common-slurm-settings)
* improved propagation of environment variables for Perl-based GASNet launchers
* improved how processes are mapped to locales for gasnetrun-based launchers
* improved portability and usability of slurm-gasnetrun_ibv launcher

Testing System
--------------
* added Python 3 support to the testing infrastructure
* reorganized test output to first show all stdout, then all stderr
* fixed support for building our test virtualenv within an existing virtualenv
* removed our dependency on `subprocess32`

Developer-oriented changes: Module changes
------------------------------------------
* removed all instance of `domain._value` from the `LinearAlgebra` module

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* improved GASNet build speeds
* `make` no longer runs GMP and RE2 builds at the same time
* improved the build configuration of the bundled LLVM sources
* the bundled LLVM build now sets `GCC_INSTALL_PREFIX` appropriately
* the bundled LLVM build now builds shared objects by default
* the bundled LLVM build includes `dump` methods when `CHPL_DEVELOPER` is set
* enabled asserts in bundled LLVM build when `CHPL_DEVELOPER` or `ASSERTS` set
* source directories can now contain builds for several architectures

Developer-oriented changes: Compiler Flags
------------------------------------------
* added `--library-fortran[-name]` flags in support of Fortran interoperability

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* eliminated all remaining uses of `chpl__tryToken`
* dramatically improved the representation of forall intents within the IR
* modernized the representation of reduce expressions
* improved the creation of promotion iterators and made them more uniform
* improved the handling of outer variables in for-/forall-expressions
* fixed the scope resolution of LoopExprs
* fixed issues with reduce task intents
* improved the IR representation for default initialization
* made some internal module params and type aliases available earlier
* refactored the parser to simplify the declaration of variables
* made deserialization errors use cnames when compiling in --devel mode
* variables declared in scopeless blocks now destroyed at end of parent block
* in module-scope code, call temps are now module-scope variables
* removed use of `_defaultOf` for numeric types or classes
* removed `dtSymbol`
* enabled prototype integration with the Region Vectorizer for LLVM
* fixed problems with `--llvm-wide-opt` with LLVM 8
* `--llvm --specialize` compilation generates target metadata for functions
* migrated `chpl_getPrivatizedCopy()` to module code to improve LLVM performance
* removed special handling for `cabs()` with `--llvm`
* `--llvm --gen-ids` compilation now adds LLVM metadata storing Chapel AST ids
* added experimental support for emitting `llvm.invariant.start`
* source files supporting `--llvm` are now in `compiler/llvm`
* `inferConstRefs` now runs on both single-locale and multi-locale compilation
* removed `reprivatizeIterators`

Developer-oriented changes: Runtime improvements
------------------------------------------------
* restructured array memory allocation interfaces
* moved communication diagnostics from comm layers to shared, common code
* moved strided bulk transfer from comm layers to shared, common code
* improved speed and ease of gathering performance statistics under `ugni`
* added tasking layer interface queries for fixed-thread-count implementations
* addressed compilation errors with `slurm-gasnetrun_ibv` launcher
* unified the implementation of all gasnetrun-based launchers

Developer-oriented changes: Testing System
------------------------------------------
* fixed a problem with integer division in `sub_test`
* removed `sub_test` transient MPP error, which interfered with prediff filter


version 1.18.0
==============

Twenty-first public release of Chapel, September 20, 2018

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* language highlights:
  - deprecated constructors in favor of initializers for classes and records
  - added managed classes and lifetime checking to help with memory management
  - added an `override` keyword to avoid mistakes when overriding class methods
  - made loop expressions and promoted calls preserve shape for domains/arrays
  - added support for task-private variables in forall loops
  - improved enums with respect to casts, coercions, comparisons, and ranges
  - added initial support for UTF-8 strings
* standard library / package highlights:
  - added `HDF5` and `NetCDF` modules supporting I/O for those file formats
  - added support for buffered versions of non-fetching atomic operations
  - improved the `LinearAlgebra` module in terms of performance and usability
* performance highlights:
  - optimized `sync` variables and concurrent I/O for `qthreads` tasking
  - optimized big data transfers, non-fetching atomics, and on-clauses on Crays
  - improved memory utilization and reduced fragmentation for task stacks
* interoperability highlights:
  - added `mason` support for external system and `Spack` package dependencies
  - significantly improved support for creating libraries for use from C
  - added initial support for exporting library routines for use with Python
* additional highlights:
  - reduced compilation times for most programs
  - added several other features and improvements to the `mason` package manager
  - improved support for ARM systems
  - added a new version of the HPCC RA benchmark that uses buffered atomics
  - added scripts to help build and maintain Chapel configurations
  - numerous error message improvements, bug fixes, and feature improvements

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* deprecated constructors in favor of initializers which are now used by default  
  (see 'Class Initializers' and 'User-Defined Initializers' in the spec)
* for a class C, `new C(...)` is now equivalent to `new borrowed C(...)`  
  (see 'Class Types' in the 'Classes' chapter of the language specification)
* when overriding a class method, the `override` keyword must now be used  
  (see 'Overriding Base Class Methods' in the spec's 'Classes' chapter)
* removed support for coercions from enums to integers
* associative domains of enums are no longer fully populated by default
* deprecated the interpretation of `:` within where clauses as a subtype query
* deprecated support for casting from numeric types to `c_string`
* deprecated support for extern classes
* made enums no longer have integer values unless specified by the user  
  (see `Enumerated Types` in the language specification)
* disabled casts from enums to integers when they have no associated value  
  (e.g., `enum color { red, green, blue};`  ...`red:int`... is no longer valid)

New Features
------------
* added support for managed class objects via `owned`, `shared`, and `borrowed`  
  (see 'Class Types' in the 'Classes' chapter of the language specification)
* added an `unmanaged` keyword for manually managing class objects  
  (see 'Class Types' in the 'Classes' chapter of the language specification)
* added a `.borrow()` method to all flavors of classes  
  (see 'Class Lifetime and Borrows' in the 'Classes' chapter of the spec)
* added a compiler lifetime checker to flag borrows that refer to freed objects
* added support for task-private variables in forall loops  
  (see 'Task-Private Variables' in the 'Data Parallelism' chapter of the spec)
* extended Chapel strings to support UTF-8 characters  
  (see https://chapel-lang.org/docs/1.18/builtins/String.html)
* added support for ranges with `enum` and `bool` indices  
  (see 'Range Types' in the 'Ranges' chapter of the language specification)
* added support for comparison operators (`<`, `<=`, `>=`, `>`) on enums
* added support for variables and fields with generic declared types  
  (see 'Variable Declarations' in the language spec's 'Variables' chapter)
* added support for querying subtype relationships via `<`, `<=`, `>`, `>=`  
  (see https://chapel-lang.org/docs/1.18/builtins/UtilMisc_forDocs.html#UtilMisc_forDocs.isSubtype)

Feature Improvements
--------------------
* significantly improved the robustness and capabilities of initializers
* made loop expressions and promoted expressions preserve shape (domain)  
  (see `For[all] Expressions` and `Array Promotion of Scalar Functions` in spec)
* added support for specifying extern/export names via param string expressions  
  (see 'Calling External Functions' in the spec's 'Interoperability' chapter)
* added support for min/max reduce intents on coforall loops
* added support for reduce intents on coforall+on loops
* added support for array return types with unspecified domains / element types  
  (e.g., `proc foo(): []` says that `foo()` returns an array but little else)
* added support for dynamic dispatch on variadic (varargs) methods
* added support for rectangular domains and arrays of `enum` or `bool` idxType
* updated `--memStats` to work properly in multi-locale runs  
  (see https://chapel-lang.org/docs/1.18/modules/standard/Memory.html#Memory.printMemAllocStats)
* added subtyping for owned and shared classes  
  (see https://chapel-lang.org/docs/1.18/builtins/SharedObject.html#coercions-for-shared  
   and https://chapel-lang.org/docs/1.18/builtins/OwnedObject.html#coercions-for-owned)
* added support for assigning `nil` to owned and shared classes
* made the default intent for formals declared with owned/shared type `const in`
* made forall loops borrow outer owned and shared class objects by default
* improved the appearance of shared objects printed via `writeln()`
* added support for argument types containing nested generic or query types  
  (see 'Formal Arguments of Partially Generic Type' in the 'Generics' chapter)
* improved the instantiation of generic arguments when coercions are involved
* added support for infix bool operators to throw
* improved `isSubtype()` and `isProperSubtype()` to handle cases that can coerce
* extended `isSubtype()` and `isProperSubtype()` to work with generic types  
  (see https://chapel-lang.org/docs/1.18/builtins/UtilMisc_forDocs.html#UtilMisc_forDocs.isSubtype)
* improved disambiguation and visibility rules when resolving function calls  
  (see 'Function Visibility in Generic Functions' in the 'Generics' chapter)
* made `in` arguments more consistent with variable initialization  
  (see 'Argument Intents' in the language specification's 'Procedures' chapter)  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/chips/13.rst)
* added support for casts from `c_void_ptr` to `c_ptr`

Removed Features
----------------
* removed implicit `outer` field on nested types with initializers
* removed the `UtilReplicatedVar` module (deprecated in 1.17)
* disabled non-`ref` forall intents when using recursive parallel iterators

Standard Modules / Library
--------------------------
* increased the use of error-handling in standard modules
* deprecated 'out error' patterns in libraries in favor of throwing versions
* converted some non-fatal checks from using `halt()` to `warning()`
* deprecated `Owned(C)` and `Shared(C)` in favor of `owned C` and `shared C`  
  (see 'Class Types' in the 'Classes' chapter of the language specification)
* added type query routines for `owned`, `shared`, `unmanaged`, and `borrowed`  
  (see https://chapel-lang.org/docs/1.18/modules/standard/Types.html#Types.isOwnedClass)
* extended string methods and library routines to support UTF-8 strings  
  (see https://chapel-lang.org/docs/1.18/builtins/String.html)
* added `array.front()`/`array.back()` to get the first/last element of an array  
  (see https://chapel-lang.org/docs/1.18/builtins/ChapelArray.html#ChapelArray.back)
* made `array.pop_front()` and `array.pop_back()` return the removed element  
  (see https://chapel-lang.org/docs/1.18/builtins/ChapelArray.html#ChapelArray.pop_back)
* added a new string `join()` overload that accepts iterator expressions
* added `expandVars()` to the `Path` module  
  (see https://chapel-lang.org/docs/1.18/modules/standard/Path.html#Path.expandVars)
* updated `makeRandomStream()` to return an owned random stream object  
  (see https://chapel-lang.org/docs/1.18/modules/standard/Random.html#Random.makeRandomStream)
* converted blocking calls in `Spawn` to yielding non-blocking loops
* made the Sync `Barrier` reusable

Package Modules
---------------
* added an `HDF5` module for reading/writing files using the HDF5 interface  
  (see https://chapel-lang.org/docs/1.18/modules/packages/HDF5.html)
* added a `NetCDF` module for reading/writing files using the NetCDF interface  
  (see https://chapel-lang.org/docs/1.18/modules/packages/NetCDF.html)
* added buffered versions of non-fetching atomic operations  
  (see https://chapel-lang.org/docs/1.18/modules/packages/BufferedAtomics.html)
* added support for singular value decomposition to the `LinearAlgebra` module  
  (see https://chapel-lang.org/docs/1.18/modules/packages/LinearAlgebra.html#LinearAlgebra.svd)
* enabled using `LinearAlgebra` without having `BLAS/LAPACK` installed  
  (see https://chapel-lang.org/docs/1.18/modules/packages/LinearAlgebra.html#compiling-with-linear-algebra)
* added configs `blasImpl` and `blasHeader` to `BLAS` to select backend  
  (see https://chapel-lang.org/docs/1.18/modules/packages/BLAS.html#BLAS.blasImpl)
* added configs `lapackImpl` and `lapackHeader` to `LAPACK` to select backend  
  (see https://chapel-lang.org/docs/1.18/modules/packages/LAPACK.html#LAPACK.lapackImpl)
* deprecated `BLAS` config `isBLAS_MKL` in favor of using `blasImpl`
* made `LinearAlgebra` sparse matrices store indices in unsorted order
* replaced string options with enumerations in the `Crypto` module  
  (see https://chapel-lang.org/docs/1.18/modules/packages/Crypto.html#Crypto.Digest  
   and https://chapel-lang.org/docs/1.18/modules/packages/Crypto.html#Crypto.CryptoChainMode)
* updated the `Crypto` module to return owned pointers
* updated the sentinel value returned by `Search.linearSearch()`  
  (see https://chapel-lang.org/docs/1.18/modules/packages/Search.html#Search.linearSearch)
* converted the `TOML` module over to use error-handling  
  (see https://chapel-lang.org/docs/1.18/modules/packages/TOML.html#TOML.TomlError)

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added support for storing the indices of sparse CS domains in unsorted order  
  (see https://chapel-lang.org/docs/1.18/modules/layouts/LayoutCS.html#LayoutCS.CS)
* added missing core operations to sparse Block-distributed domains

New Tools / Tool Changes
------------------------
* added support for non-Chapel system and Spack packages in mason  
  (see https://chapel-lang.org/docs/1.18/tools/mason/mason.html#using-system-dependencies  
   and https://chapel-lang.org/docs/1.18/tools/mason/mason.html#using-spack-dependencies)
* added `mason add` and `mason rm` for managing dependencies  
  (see https://chapel-lang.org/docs/1.18/tools/mason/mason.html#using-chapel-dependencies)
* added support for tests and examples within mason  
  (see https://chapel-lang.org/docs/1.18/tools/mason/mason.html#testing-your-package  
   and https://chapel-lang.org/docs/1.18/tools/mason/mason.html#creating-and-running-examples)
* added `mason run --release` flag to specify release vs. debug modes
* added `--no-update` flag for better offline support in mason
* added support for calling mason commands from any directory within a project
* added support for checking last modified timestamp before building in mason
* improved bash tab completion to offer developer flags in developer mode only
* added `chpldoc` support for new keywords: `overrides`, `owned`, `shared`, ...
* squashed `chpldoc` documentation of compiler-generated symbols
* added Python 3 support for chpldoc

Interoperability Improvements
-----------------------------
* significantly improved support for calling exported Chapel routines from C  
  (see https://chapel-lang.org/docs/1.18/technotes/libraries.html)
* added initial support for exporting library routines for use from Python  
  (see https://chapel-lang.org/docs/1.18/technotes/libraries.html#using-your-library-in-python)
* `--library` compilations now generate .h files and Makefiles for ease-of-use  
  (see https://chapel-lang.org/docs/1.18/technotes/libraries.html#using-your-library-in-c)
* `lib` is now prepended to filenames generated by the `--library` flags
* files generated by `--library` compilations are now stored in a subdirectory
* `--library` compiles now auto-export module (de)initialization routines
* added initial support for exported functions taking/returning 1D arrays

Performance Optimizations/Improvements
--------------------------------------
* improved the performance of sync variables and concurrent I/O under `qthreads`
* optimized away communication for queries to the `id` field of a locale
* optimized sparse matrix addition and multiplication in `LinearAlgebra`
* parallelized a loop in array reallocation
* reduced overheads in the `Search.linearSearch()` routine

Cray-specific Performance Optimizations/Improvements
----------------------------------------------------
* improved performance of large transfers under `ugni`
* optimized non-fetching network atomics
* improved on-stmt performance for `ugni`
* optimized the Atomic `Barrier` for network atomics
* mapped `atomic real(32)` operations to network atomics

Memory Improvements
-------------------
* reduced memory leaks related to initializers
* fixed leaks in the `DateTime` and `Regexp` modules
* fixed memory leaks in `array.pop_front()`/`.pop_back()` and `list.pop_front()`
* eliminated memory fragmentation for task stacks hosted on hugepages
* reduced the amount of memory preemptively allocated for task stacks

Compiler Flags
--------------
* added `--warn-unstable` to flag code which uses features that are in flux
* added `--warn-constructors` flag to warn against user-defined constructors
* added a `--[no-]optimize-range-iteration` flag to control range optimizations
* made `--warn-const-loops` and `--warn-special` into developer flags
* made `--warn-domain-literal` and `--warn-tuple-iteration` into developer flags

Documentation
-------------
* added descriptions of managed and unmanaged classes to the classes primer  
  (see https://chapel-lang.org/docs/1.18/primers/classes.html)
* improved the mason documentation  
  (see https://chapel-lang.org/docs/1.18/tools/mason/mason.html)
* added documentation for the `TOML` module  
  (see https://chapel-lang.org/docs/1.18/modules/packages/TOML.html)
* improved the documentation for the `LinearAlgebra` module  
  (see https://chapel-lang.org/docs/1.18/modules/packages/LinearAlgebra.html)
* documented `bigint.divexact` in the `BigInteger` module  
  (see https://chapel-lang.org/docs/1.18/modules/standard/BigInteger.html#BigInteger.bigint.divexact)
* simplified the version selection button in Chapel's online documentation  
  (see the menu in the upper left at https://chapel-lang.org/docs/)

Example Codes
-------------
* added a new version of the HPCC RA benchmark that uses `BufferedAtomics`  
  (see `$CHPL_HOME/examples/benchmarks/hpcc/variants/ra-buff-atomics.chpl`)
* updated many of the example codes to make use of managed classes
* updated example codes with respect to using the `override` keyword
* updated example codes with respect to changes to `enum` types
* updated example codes with respect to shape-preservation semantics
* clarified how vector operations modify domains in the arrayVectorOps primer  
  (see https://chapel-lang.org/docs/1.18/primers/arrayVectorOps.html)
* updated our port of LCALS to use relative, rather than absolute, differences
* fixed an off-by-one bug in a loop bound in our port of LCALS

Portability
-----------
* updated the target compiler interface to handle 64-bit ARM, Skylake, KNL  
  (see https://chapel-lang.org/docs/1.18/usingchapel/chplenv.html#chpl-target-arch)
* added support for the Allinea compiler on ARM systems
* improved LLVM back-end support for ARM systems
* improved our counting of compute node CPUs, with and without `hwloc`
* improved the `Crypto` module to work on platforms with OpenSSL 1.1
* ported the `Math` module's Bessel functions to `darwin`
* improved the portability of the code base to gcc 7.x
* resolved a build failure on certain systems with CUDA installed

Cray-specific Changes
---------------------
* made `ibv` the default substrate for `cray-cs` systems
* increased the number of memory regions while allowing for override for `ugni`  
  (see https://chapel-lang.org/docs/1.18/platforms/cray.html#ugni-communication-layer-registered-memory-regions)
* added memory tracking of dynamically registered arrays for `ugni`
* added hugepage-related environment consistency checks for `ugni`
* fixed support for large non-blocking gets under `ugni`
* made LLVM work with dynamic linking on Cray XC systems
* suppressed an error about incompatible casting for `ZMQ` with PrgEnv-cray

Error Messages / Semantic Checks
--------------------------------
* significantly improved error messages for initializers
* added a compile-time error when declaring recursive records
* improved error messages to show types of non-default numeric param values
* made use-before-def error messages print to the symbol's definition point
* added an error message when we can't determine an iterator's yield type
* improved error messages for accessing tuples of types out of bounds
* improved const checking for tuple arguments
* added an error for passing too many arguments to a tuple-type index expression
* added a helpful error message when throwing an error type without `new`
* added an error message for applying `.type` to a type
* improved checking of intents on overridden methods
* improved the error message for library compilations using multiple modules
* added a compile-time error for exported functions using strings
* added an error message if `CHPL_COMM_SUBSTRATE` isn't detected by `GASNet`
* improved error-handling for certain operations on an invalid channel
* removed a warning regarding returned iterators being promoted to arrays

Execution-time Checks
---------------------
* added a better error for running a `--local` program on more than 1 locale
* added runtime memory exhaustion reporting for `CHPL_TASKS=qthreads`

Bug Fixes
---------
* fixed a number of bugs related to initializers
* fixed several bugs with `forwarding` fields
* fixed several problems with calls qualified by explicit module names
* fixed a bug in which private overloads could completely shadow public ones
* fixed a bug in which qualified 'use's hid methods with the same name
* fixed support for the swap operator (`<=>`) on owned and shared objects
* fixed problems with records containing `owned` class fields
* fixed problems with compiler-added copies for `owned` variables
* adjusted `make install` to enable the use of the setchplenv scripts
* fixed a bash tab completion bug for paths involving `~`
* fixed problems with `--llvm` in `make install` builds
* fixed problems with certain GASNet configurations using `--llvm`
* fixed `--llvm` compiles with `CHPL_TARGET_ARCH=unknown`
* fixed incorrect bulk-transfers between reindexed arrays
* fixed support for `atomic real(32)` on platforms with network atomics
* fixed bugs with operators and intents in `BigInteger` library routines
* fixed return type of casts from `bigint` to `integral`/`real`
* fixed bugs in `IO.readline()`
* fixed bugs with exists(""), isFile(""), isDir(""), isLink(""), isMount("")
* fixed problems in `FileSystem.copyFile` for files not ending in newlines
* fixed a bug where `Search` sometimes used the wrong bounds for strided arrays
* fixed `DynamicIterators` for 0-length ranges and domains
* fixed a bug in mergeSort's documentation claiming it was in-place
* fixed a bug when spawning a task with stdout set to PIPE and stderr to STDOUT
* fixed reported line numbers for non-generic class allocations
* fixed a bug with `createRandomBuffer()` in the `Crypto` module
* fixed potential `export`/`extern` naming conflicts in the generated code
* fixed a bug with a function called from forall loop nested in an on-statement
* fixed a double free with variable initialization and nested throwing calls
* fixed an issue with with the extern block feature
* fixed compiler crashes when compiling highly nested expressions
* fixed a bug with promoted casts from an `enum` type to itself
* fixed a bug in `chpldoc` for the rendering of forwarding fields
* fixed a problem where the compiler lost track of a point of instantiation
* improved function resolution to resolve return types only for legal candidates
* improved our running task counter for remote tasks
* fixed a bug in which quoted spaces were mishandled in `setchplenv.fish`
* fixed a bug in which `printchplenv -all` did not include defaults
* fixed a bug in which modules were not built as a dependency to mason
* fixed how we detect local spawning for setting locale names
* fixed an extremely rare deadlock during `qthreads` shutdown
* fixed an initialization order bug with `qthreads` and `CHPL_ATOMICS=locks`
* fixed buffer overflows found by the extra checking built into gcc 8.1
* fixed `isClassType()` to return false for `c_ptr` types

Compiler Performance
--------------------
* improved compiler speed by reducing uses of where clauses in standard modules
* improved compiler speed by refactoring how primitives are code-generated

Packaging / Configuration Changes
---------------------------------
* added scripts to make it easier to build and maintain Chapel configurations  
  (see `$CHPL_HOME/util/build_configs/README.md`)

Third-Party Software Changes
----------------------------
* upgraded GASNet to version 1.32.0
* arranged for Qthreads to use the runtime's `hwloc` topology when that exists
* third-party libraries are now position-independent when `CHPL_LIBMODE=shared`
* disabled guard pages for `arm-thunderx` under `qthreads`
* suppressed a package conflict and pip 10 warnings when building virtualenvs

Testing System
--------------
* allowed performance tests to only define a .perfcompopts file
* fixed start_test escaping of `--compopts`/`--execopts`
* improved how start_test detects whether re2 was built with valgrind support
* disabled loose matching for paratest.server command-line options
* made the output of paratest.server appear in more deterministic sorted order
* retained the temporary log files when paratest.server fails

Developer-oriented changes: Configuration changes
-------------------------------------------------
* improved `MPI_CC` and `MPI_CXX` defaults for the Intel compiler
* added `CHPL_HWLOC` and `CHPL_TARGET_MEM` to qthread-specific paths
* added `JEMALLOC_LIB_DIR` to the runtime path
* reduced the dependence on `$CHPL_HOME` when computing the compiler's SHA

Developer-oriented changes: Module changes
------------------------------------------
* all internal, standard, and package modules now use initializers
* updated modules to work with the new class memory management features
* updated standard library and internal modules to utilize `override` keyword
* added a subclass of array/domain/distribution to handle external array types
* simplified the implementation of the minloc and maxloc reduction classes
* performed miscellaneous housekeeping cleanup of locale models
* removed several halts from the I/O module
* stopped exporting GMP routines

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* added `--compiler`, `--linker`, and `--linkershared` flags to `compileline`  
  (see `util/config/compileline -h`)

Developer-oriented changes: Compiler Flags
------------------------------------------
* dramatically improved support for `--library` compilation  
  (see 'Interoperability Improvements' above)
* added `--library-header` to rename a `--library`'s  .h file
* added `--library-dir` to specify the location for generated library files
* added `--library-makefile` to generate a Makefile for library compilations
* added `--library-python` to generate a Python module using Cython
* added `--library-python-name` to set the name of the generated Python module
* added `--ignore-user-errors` and `--stop-after-pass` compiler flags
* added the flag `--default-unmanaged` to make classes unmanaged by default
* changed the flag `--break-on-delete-id` to `--break-on-remove-id`
* removed `--user-constructor-error` flag as no longer being necessary

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* improved line number propagation for internal functions
* enabled pragmas to apply to formal arguments
* added functionality to reissue `compilerError()` messages
* changed the colors of links for user-modules in `--html` output to stand out
* AST dumps now show varargs arguments with `...`
* added an `always RVF` pragma to force remote-value forwarding on a given type
* added `chpl_anybool`, `chpl_anyimag`, and `chpl_anyreal` generic types
* replaced some uses of `Vec` with `std::vectors`
* simplified handling of forall loops and forall intents
* made LLVM alias analysis tests more tolerant of changes in name mangling
* updated `llvm.invariant.start` emission for records using initializers
* adjusted calls to `chpl__deserialize` to avoid runtime types
* compiler now prints some internal types without a leading underscore

Developer-oriented changes: Documentation improvements
------------------------------------------------------
* revamped the test system documentation to better serve new developers  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/TestSystem.rst)
* added a `check_path` script to find bad filepath references in repository
* documented the launcher interface  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/adding-a-launcher.rst)
* removed `404 error` output after successful documentation build
* removed `git clean` suggestion after failed documentation build

Developer-oriented changes: Module improvements
-----------------------------------------------
* simplified the implementation of atomic variables
* implemented experimental support for Polly optimization of Chapel arrays
* removed the unused `origin` field from DefaultRectangularArr
* added `dsiAlign*` methods to `CyclicDom` and `ReplicatedDom`

Developer-oriented changes: Runtime improvements
------------------------------------------------
* reorganized the topology layer into `none` and `hwloc` implementations
* added support for processing non-local /proc/cpuinfo files in counting CPUs
* cleaned up `ugni` implementation of network atomics
* improved the performance of comm diagnostic counters when using GASNet
* removed non-functional `qthreads` support for `--blockreport`/`--taskreport`
* removed code to set `GASNET_MAX_SEGSIZE`
* simplified implementation-specific `.h` file names for tasking and threading

Developer-oriented changes: Testing System
------------------------------------------
* avoided the use of spool files when using PBSPro via `chpl_launchcmd.py`
* added missing bracket to gengraphs messages

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* improved `CHPL_LLVM=system` support to avoid unpacking the LLVM sources
* enabled `chpl` to build with LLVM 7 pre-release
* moved GMP support out of the C runtime
* improved how runtime-oriented options are set in Qthreads builds

Developer-oriented changes: Tool improvements
---------------------------------------------
* added --break-on-id and --break-on-delete-id to `chpldoc`
* converted mason to use error-handling


version 1.17.1
==============

Update to twentieth public release of Chapel, April 2018  
(see also changes below for 1.17.0)

Bug Fixes
---------
* fixed a bug in which postinit() was not called for generic records
* fixed a bug in which most launchers would not work with 'make install'
* fixed a portability problem w.r.t. our processing of /proc/cpuinfo
* fixed a bug in which LinearAlgebra.Sparse.eye() would unintentionally promote

Cray-specific Changes
---------------------
* reduced contention for polling threads for CHPL_COMM=ugni
* fixed a bug in computing the max number of comm domains for CHPL_COMM=ugni
* improved the handling of unregisterable memory segments for CHPL_COMM=ugni
* increased conservatism in IPA for CHPL_TARGET_COMPILER=cray-prgenv-cray
* fixed debug build mode for CHPL_COMM=ugni

Documentation
-------------
* simplified URLs to use https://chapel-lang/docs/ rather than .../docs/latest/
* fixed some typos and broken links in this file

Packaging Changes
-----------------
* converted our use of easy_install to pip when installing virtualenv

Third-Party Software Changes
----------------------------
* updated hwloc to 1.11.10
* fix our snapshot of fltk


version 1.17.0
==============

Twentieth public release of Chapel, April 5, 2018

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* tool / configuration highlights:
  - added support for bash tab completion for `chpl` compiler options
  - `chpl` now offers suggestions for unrecognized flags
  - changed the generated executable's name from the main module to its filename
  - improved support for `chpl`s LLVM back-end
  - added support for multiple mason repositories, including local registries
* language highlights:
  - dramatically improved support for user-defined and implicit initializers
  - added support for uninterpreted triple-quoted strings
  - usability improvements for `Owned(c)` and `Shared(c)`
  - improved coercions for `enum` and numeric types, particularly `real(32)`
* standard library / package highlights:
  - `LinearAlgebra` matrices now use 1-based indices by default
  - new Kronecker, Cholesky, eigenvector/value routines in `LinearAlgebra`
  - added the Blowfish cipher to the `Crypto` module
  - added support for joinPath(), isAbsPath(), commonPath() to the `Path` module
  - added Bessel functions to `Math` module
  - added new channel.advancePastByte(), mark(), commit(), and revert() methods
  - increased the use of error-handling in standard, package, internal modules
* performance / benchmark / memory highlights::
  - significant performance improvements when executing using Cray networks
  - added a new faster version of the reverse-complement benchmark
  - closed a number of minor memory leaks
* portability highlights:
  - ported Chapel to the Cray XC50 system with ARM processors
  - improved portability to FreeBSD and PowerPC
  - improved portability for specific versions of gcc
* documentation highlights:
  - moved Chapel's website from http://chapel.cray.com to https://chapel-lang.org
  - added a color-coded version selection menu to the online documentation

File / Directory Structure
--------------------------
* made `make install` install mason
* added the CHPL_COMM_SUBSTRATE setting to GASNet-specific paths

New Tools / Tool Changes
------------------------
* added support for bash tab completion for `chpl` compiler options  
  (see https://chapel-lang.org/docs/1.17/usingchapel/compiling.html#tab-completion-for-flags)
* changed the generated executable's name from the main module to its filename  
  (see the `-o` flag on https://chapel-lang.org/docs/1.17/usingchapel/man.html)
* added support for multiple mason repositories, including local registries  
  (see https://chapel-lang.org/docs/1.17/tools/mason/mason.html#local-registries)
* added support for `mason help` and `mason version` commands
* `chpl` now offers suggestions for unrecognized flags  
  (see error message for `chpl -fast`)
* rewrote `printchplenv` and reworked its interface and output  
  (see `util/printchplenv --help`)
* rewrote `compileline`  
  (see `util/config/compileline --help`)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* `in` intents now behave more like variable initialization  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/chips/13.rst)
* ranges are now passed by `const in` intent by default  
  (see 'The Default Intent' in the 'Procedures' chapter of the specification)
* disallowed implicit coercions for type arguments with a formal type specifier  
  (see 'Implicit Conversions' in the specification's 'Conversions' chapter)
* changed the alignment of a non-stridable range from 0 to its low bound  
  (i.e., `(3..5).alignment` is now 3 where it used to be 0)

New Features
------------
* added support for uninterpreted triple-quoted strings  
  (see 'Literals' section in 'Lexical Structure' chapter of the specification)
* added support for `continue` statements within forall loops
* extended `delete` to accept arrays and list of expressions to delete  
  (see 'Deleting Class Objects' in the 'Classes' chapter of the specification)
* type and param fields can now be accessed from a type variable  
  (see 'Field Accesses' in the 'Classes' chapter of the specification)
* added support for forwarding methods on arrays, domains, and distributions  
  (see https://chapel-lang.org/docs/1.17/technotes/dsi.html#overview)
* added an `isEmpty()` method on domains
* added support for associative domains whose index types contain ranges
* added support for subtype queries on distributions  
  (see 'Methods on All Domain Types' in the 'Domains' chapter of the spec)
* added support for using GASNet's `smp` conduit

Feature Improvements
--------------------
* dramatically improved support for user-defined initializers  
  (see https://chapel-lang.org/docs/1.17/technotes/initializers.html)
* improved `enum` and numeric coercions, greatly improving `real(32)` usability  
  (see 'Implicit Numeric, Bool, and Enumeration Conversions' in the spec)
* made string->value casts throw rather than halt() when encountering errors
* `Owned(c)` and `Shared(c)` now coerce to type `c`  
  (see https://chapel-lang.org/docs/1.17/modules/packages/OwnedObject.html)
* made `Owned(d)` coerce to `Owned(c)` when `c` is a superclass of `d`  
  (see https://chapel-lang.org/docs/1.17/modules/packages/OwnedObject.html)
* writing out an `Owned(c)` now simply prints the `c` object
* improved support for casting arrays to strings
* made clear() for an array of records call the records' deinitializers
* added support for defining multiple config types in a single statement  
  (see 'Type Aliases' in the 'Types' chapter of the language specification)
* made error-handling propagate through forwarded methods
* added support for invoking recursive parallel iterators via forall loops
* enabled wide pointers to be cast to `c_void_ptr`
* improved support for enums with non-trivial initialization expressions
* improved default argument handling

Removed Features
----------------
* removed the `msg` field from the `Error` class
* removed deprecated `Barrier` module in favor of `Barriers`
* removed deprecated `LayoutCSR` module in favor of `LayoutCS`
* removed `ReplicatedDist` in favor of `Replicated`

Standard Modules / Library
--------------------------
* added Bessel functions to `Math` module  
  (see https://chapel-lang.org/docs/1.17/modules/standard/Math.html#Math.j0)
* added support for joinPath(), isAbsPath(), commonPath() to the `Path` module  
  (see https://chapel-lang.org/docs/1.17/modules/standard/Path.html)
* added support for channel.advancePastByte() to read until a particular byte  
  (see https://chapel-lang.org/docs/1.17/modules/standard/IO.html#IO.channel.advancePastByte)
* added versions of channel.mark(), commit(), revert() when locking==false  
  (see https://chapel-lang.org/docs/1.17/modules/standard/IO.html#IO.channel.mark)
* improved support for I/O on `date`, `time`, and `datetime` types in `DateTime`  
  (see https://chapel-lang.org/docs/1.17/modules/standard/DateTime.html#DateTime.date.readWriteThis)
* made DateTime.time.tzinfo `Shared` for automated memory management  
  (see https://chapel-lang.org/docs/1.17/modules/standard/DateTime.html#DateTime.time.init)
* array `push*` methods now use `in` intents to improve their use with Owned  
  (see https://chapel-lang.org/docs/1.17/builtins/ChapelArray.html#ChapelArray.push_back)
* added `string.size` overload for `string.length`  
  (see https://chapel-lang.org/docs/1.17/builtins/String.html#String.string.size)
* updated several modules to use error handling rather than `try!` / `halt()`
* made the `Buffers` module into a package module  
  (see https://chapel-lang.org/docs/1.17/modules/packages/Buffers.html)
* made the `UtilReplicatedVar` module into a package module `ReplicatedVar`  
  (see https://chapel-lang.org/docs/1.17/modules/packages/ReplicatedVar.html)

Package Modules
---------------
* `LinearAlgebra` matrices now use 1-based indices by default  
  (see https://chapel-lang.org/docs/1.17/modules/packages/LinearAlgebra.html#linear-algebra-interface)
* added Kronecker product, `kron()`, to `LinearAlgebra` module  
  (see https://chapel-lang.org/docs/1.17/modules/packages/LinearAlgebra.html#LinearAlgebra.kron)
* added Cholesky factorization routine to `LinearAlgebra` module  
  (see https://chapel-lang.org/docs/1.17/modules/packages/LinearAlgebra.html#LinearAlgebra.cholesky)
* added eigenvalue/eigenvector solvers to `LinearAlgebra` module  
  (see https://chapel-lang.org/docs/1.17/modules/packages/LinearAlgebra.html#LinearAlgebra.eigvals)
* added support for `eye()` to `LinearAlgebra` for CS* domains  
  (see https://chapel-lang.org/docs/1.17/modules/packages/LinearAlgebra/Sparse.html#Sparse.eye)
* added the Blowfish cipher to the `Crypto` module  
  (see https://chapel-lang.org/docs/1.17/modules/packages/Crypto.html#Crypto.Blowfish)
* added a new scalable barrier across all locales  
  (see https://chapel-lang.org/docs/1.17/modules/packages/AllLocalesBarriers.html)
* added binaryInsertionSort to the `Sort` module  
  (see https://chapel-lang.org/docs/1.17/modules/packages/Sort.html#Sort.binaryInsertionSort)
* added `--debugTomlReader` flag for `TOML.TomlReader` submodule

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* added the ability for sparse CS domains to have a sparse parent domain
* added support for querying the stridability of sparse domains  
  (see https://chapel-lang.org/docs/1.17/builtins/ChapelArray.html#ChapelArray.stridable)
* added support for strided Block-sparse domains and arrays
* redesigned the bulk-transfer interface to reduce its complexity  
  (see https://chapel-lang.org/docs/1.17/technotes/dsi.html#phase-4-bulk-transfer-interface)

Interoperability Improvements
-----------------------------
* extern blocks now support #defines containing casted literals  
  (see https://chapel-lang.org/docs/1.17/technotes/extern.html#defines)

Performance Optimizations/Improvements
--------------------------------------
* improved performance of sparse matrix-matrix multiplication in `LinearAlgebra`
* improved remote value forwarding optimization for types with initializers
* reduced wide-pointer overhead for domains and distributions
* re-enabled and improved --llvm-wide-opt optimizations
* improved the performance of the `Barriers` module by using processor atomics
* improved execution start up times under `ugni`
* increased the amount of communication concurrency permitted for `ugni`
* significantly improved scalability of `coforall ... do on ... {}` under `ugni`
* increased the rate that on-stmts that can be processed under `ugni`
* improved performance of puts/gets for GASNet over the `aries` conduit

Memory Improvements
-------------------
* closed a number of memory leaks
* significantly improved iterator memory management
* optimized away storage of alignment-related fields from non-stridable ranges
* fixed some incorrect memory descriptors

Compiler Flags
--------------
* removed support for the `--wide-pointers` flag

Documentation
-------------
* moved Chapel's website from http://chapel.cray.com to https://chapel-lang.org  
  (see https://chapel-lang.org)
* added a color-coded version selection menu to the online documentation  
  (see the upper-left corner of https://chapel-lang.org/docs/)
* simplified the URLs for the current release's documentation  
  (see https://chapel-lang.org/docs/)
* documented the built-in Error types  
  (see https://chapel-lang.org/docs/1.17/builtins/ChapelError.html)
* updated function overload disambiguation rules in the language specification  
  (see 'Determining More Specific Functions' in the 'Procedures' chapter)
* described combining promotion and default arguments in the specification  
  (see 'Promotion' in the 'Data Parallelism' chapter of the specification)
* documented type arguments with type specifiers  
  (see 'Formal Type Arguments' in the 'Generics' chapter of the specification)
* improved documentation for `-f` configuration file flag  
  (see https://chapel-lang.org/docs/1.17/usingchapel/executing.html#configuration-file)
* improved documentation for which domain maps are supported by `LinearAlgebra`  
  (see https://chapel-lang.org/docs/1.17/modules/packages/LinearAlgebra.html#linear-algebra-interface)
* added m4 to Chapel's prerequisites list (required for GMP)  
  (see https://chapel-lang.org/docs/1.17/usingchapel/prereqs.html)
* documented `range.size`  
  (see https://chapel-lang.org/docs/1.17/builtins/ChapelRange.html#ChapelRange.range.size)
* documented `compileline --compile-c++` in the libraries documentation  
  (see https://chapel-lang.org/docs/1.17/technotes/libraries.html)
* added missing documentation for `dsiAssignDomain`  
  (see https://chapel-lang.org/docs/1.17/technotes/dsi.html)
* updated `mason` documentation to reflect new features
* fixed dead links within documentation
* fixed a number of typos

Example Codes
-------------
* added a new faster version of the reverse-complement benchmark  
  (see examples/benchmarks/shootout/revcomp-fast.chpl)
* updated example codes with respect to initializer changes
* converted leader-follower iterators in SSCA#2 into standalone iterators  
  (see examples/benchmarks/ssca2/)
* fixed a timing bug in our implementation of ISx when using multiple trials  
  (see examples/benchmarks/isx/isx.chpl)
* fixed a bug in the LCALS inner_prod loop kernel  
  (see examples/benchmarks/lcals/)
* removed the explicit version of MiniMD from the release

Locale Models
-------------
* converted locale models to use initializers

Portability
-----------
* made CHPL_LLVM=system more portable and added support for Mac Homebrew  
  (see https://www.chapel-lang.org/docs/1.17/technotes/llvm.html)
* improved portability to FreeBSD and PowerPC
* improved the portability of computing available memory on a locale
* made INFINITY and NAN independent of bit patterns
* made c2chapel Makefile POSIX-compliant
* improved portability of code w.r.t. certain versions of gcc and libmvec
* worked around a gcc bug by ensuring the last line in a file is not an #include

Cray-specific Changes
---------------------
* ported Chapel to the Cray XC50 system with ARM processors  
  (see https://www.chapel-lang.org/docs/1.17/platforms/cray.html)
* made `ugni` registered heap extensions dynamic, improving NUMA locality  
  (see https://chapel-lang.org/docs/1.17/platforms/cray.html#ugni-communication-layer-and-the-heap)
* raised the limit on Aries NIC resource usage for `ugni`  
  (see https://chapel-lang.org/docs/1.17/platforms/cray.html#communication-layer-concurrency)
* improved upon `Bus error` messages when array allocation fails for `ugni`
* improved backwards compatibility of `ugni` with respect to chained operations
* improved Cray XC code to pass stricter requirements of Clang

Platform-specific Changes
-------------------------
* fixed a bug causing control-C to hang the compiler on Mac OS X
* improved portability of re2 for Cygwin

Syntax Highlighting
-------------------
* added error-handling constructs to syntax highlighters
* added `prototype` modules to syntax highlighters

Error Messages / Semantic Checks
--------------------------------
* improved parser errors to support multiple errors
* added an error message when trying to `use GMP` for CHPL_GMP=none
* added user errors for `param` arguments with a non-`param` default value
* added a user error for `yield` and `return` statements at module scope
* added a user error for mismatched default values vs. formal types
* added an error when mixing constructors and initializers in a class hierarchy
* added a hint for initializers improperly recognized as copy initializers
* significantly improved error messages for initializer problems
* improved error messages for improper break/continue/return in forall loops
* improved error messages for out-of-bounds tuple element accesses
* improved an error message for a missing module / enum to name the symbol
* improved error messages for bad entries in config files
* added an error for creating a `ref` to a type
* improved an error message when zipping a tuple with a multi-dimensional object
* disallowed throwing from within defer statements and deinit() routines
* improved error messages for unimplemented features in parallel iterators
* improved error messages for assignments within conditionals
* improved errors for arguments with inferred types and conditional defaults
* improved errors for functions returning generic type variables
* fixed the path to `multilocale.rst` in runtime error messages

Execution-time Checks
---------------------
* added bounds checking for indices as they're added to default sparse domains
* improved an error when trying to open a directory

Bug Fixes
---------
* fixed a bug in which `mason run` used directory name as project name
* made `mason` exit cleanly if a build fails on `mason run --build`
* fixed a bug in the interaction between `coforall` and `try!`
* fixed a bug in which `try` and `return` could result in garbage return values
* fixed a bug in which non-returning functions could be assigned to variables
* fixed a bug when assigning between void values
* fixed a bug for iterating over anonymous low-bounded ranges (e.g., `lo..`)
* fixed a bug with where clauses that use the integral type
* fixed a bug in which iterator default arguments could access invalid memory
* fixed a bug relating to promoting atomic operations with `order` arguments
* fixed several bugs relating to type arguments with a specified type
* fixed a bug with forwarding certain generic functions
* fixed a segfault when casting an empty string to a real
* fixed a bug in enum->int casts for enums with nontrivial value expressions
* fixed task intents for const ref variables
* fixed a bug with enums declared in generic functions
* fixed a bug with casting an enum's constants to certain types
* fixed a bug with assignment for opaque domains
* fixed a bug with arguments whose default value is a `new` record with init
* fixed an internal compiler error with dynamic dispatch of serial iterators
* fixed a bug in clear() for rectangular domains
* fixed bugs related to sparse matrix-matrix multiplication
* fixed a bug with `StencilDist` arrays in which cached values would be printed
* fixed default values of new array elements added to associative arrays
* fixed a bug in bounds-checking for the `insert()` method on arrays
* fixed a bug with JSON output of records with `enum` fields
* fixed a bug with chpldoc and general enum documentation comments
* fixed some bugs with respect to `Owned` patterns
* fixed a bug in which tuples could not be zipped with arrays
* fixed a bug relating to when multiple modules define a procedure named main()
* fixed bugs in `LinearAlgebra` routines relating to square / non-square matrices
* fixed a bug in which `LinearAlgebra.dot()` did not have sorted indices
* fixed an incorrect return type in the `Crypto` module
* fixed a bug where `TOML` module failed to parse quoted values with whitespace
* fixed a bug regarding zippering PCG random streams' iterate() method
* fixed a use-after-free error in task counting at program shutdown
* fixed a bug related to concurrent array creation under ugni
* fixed an incorrect data type being used in the KNL locale model
* fixed a bug with large arrays and --llvm
* fixed a bug where the memory layer was shut down too early
* fixed a build issue on systems with CUDA installed
* fixed a bug related to clock-skew with compiler performance timings
* fixed a build issue on systems with low-resolution timestamps

Launchers
---------
* added a `smp` launcher for simulating multi-locales on a shared-memory system  
  (see https://chapel-lang.org/docs/1.17/usingchapel/launcher.html#currently-supported-launchers)
* added a `gasnetrun_ofi` launcher for running with GASNet over its OFI conduit  
  (see https://chapel-lang.org/docs/1.17/usingchapel/launcher.html#currently-supported-launchers)

Compiler Performance
--------------------
* significantly improved the speed of --llvm compilation

Third-Party Software Changes
----------------------------
* made Chapel default to using LLVM 6.0.0 when enabled  
  (see https://www.chapel-lang.org/docs/1.17/usingchapel/chplenv.html)
* removed support for LLVM versions older than 4.x  
  (see https://www.chapel-lang.org/docs/1.17/usingchapel/chplenv.html)
* updated hwloc to 1.11.9
* updated fltk to 1.3.4-2

Testing System
--------------
* dramatically improved the usability of the web-based performance graphs
* added tab-completion support for start_test
* made `start_test` process files, subdirectories in sorted order
* allow performance testing flags to be overridden
* added support for executable compopts files with conditionally empty output
* added support for a -futures-only flag to parallel testing scripts
* improved testing system's ability to run from a non-CHPL_HOME util/ directory
* improved test system checks and support for valid valgrind configurations
* fixed a race in code that limits the number of concurrently executing tests
* fixed a sporadic error in tests using the high-precision timer option

Developer-oriented changes: Configuration changes
-------------------------------------------------
* added `CHPL_RUNTIME_ARCH` to specify architecture runtime is built for
* added `CHPL_TARGET_BACKEND_ARCH` to specify cpu-type used for `-march` flag
* removed a special case and detected 64-bit ARM atomics the same as others

Developer-oriented changes: Module changes
------------------------------------------
* converted most internal/standard/package module objects to use `[de]init()`
* simplified how automatic `use`s are handled in internal modules

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* added support for computing the compiler version when using git worktree
* added an error for unsupported flex versions when generating the lexer
* fixed a problem preventing `make check -j` from succeeding

Developer-oriented changes: Compiler Flags
------------------------------------------
* added a `--lifetime-checking` flag to enable prototype use-after-free checks
* added a `--warn-unstable` flag to warn of changing language features
* updated `--llvm-print-ir` to produce LLVM modules that work with other tools
* removed 1-character developer-only flags

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* greatly improved support for default initializers
* significant clean-up/refactoring of the compiler's resolution passes
* simplified the implementation of forall intents
* enabled more of the compiler to work with qualified references
* updated the version of `flex` used to generate the parser warning-free
* simplified the computation of yielded types for forall loops
* clang support no longer requires internal clang headers
* made the compiler stop distinguishing between `()` and `[]` promotions
* improvements to type encapsulation for AggregateType
* added support for enabling promotion on types with initializers
* some iterators are no longer treated as recursive
* stopped adding init methods to virtual maps
* stopped normalizing ContextCallExprs after their insertion at resolution
* added comparison operators for compiler representation of source locations
* permitted compiler analysis of loops to be run in more places
* improved the normalization of error handling
* removed the processIteratorYields pass
* removed dead code in removeUnnecessaryAutoCopyCalls
* removed the removeWrapRecords pass
* removed the `c_string_copy` type
* improved precision of LLVM alias analysis metadata
* added experimental targeting to ARM's Allinea compiler

Developer-oriented changes: Documentation improvements
------------------------------------------------------
* updated CONTRIBUTING.md content, to reduce redundancy with other docs  
  (see https://github.com/chapel-lang/chapel/blob/main/.github/CONTRIBUTING.md)
* updated GitHub issue template to request users to note blocking issues  
  (see https://github.com/chapel-lang/chapel/blob/main/.github/ISSUE_TEMPLATE.md)
* modified ContributorInfo.rst and TestSystem.rst for clarity
* document new future file format option  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/bestPractices/TestSystem.rst#futures-a-mechanism-for-tracking-bugs-feature-requests-etc)

Developer-oriented changes: Module improvements
-----------------------------------------------
* removed some initialize() methods on module code
* converted `proc these` on array records into iterators
* removed the multi-ddata implementation, previously disabled / unused

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added `ugni` statistics for dynamic allocation operations

Developer-oriented changes: Testing System
------------------------------------------
* converted most tests from constructors and initialize() to initializers
* updated smokeTest scripting with respect to whitespace

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* moved handling of CHPL_COMM_USE_GDB from a GASNet patch to Chapel's launchers


version 1.16.0
==============

Nineteenth public release of Chapel, October 5, 2017

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* tool / configuration highlights:
  - added an initial version of 'Mason', Chapel's package manager
  - added a new 'c2chapel' tool that simplifies interoperability with C
  - 'chpl' executable names now take the main module's name instead of 'a.out'
  - added a 'configure'/'make install' option for building+installing Chapel
* language improvements:
  - significantly improved support for user-defined initializers
  - dramatically improved error-handling, particularly across locales and tasks
  - added a 'defer' statement to aid with cleanup
  - made reduce intents preserve the reduction variable's initial value
* standard library/package modules:
  - added support for a new 'Crypto' module based on OpenSSL
  - added new 'Collection' modules, 'DistributedBag' and 'DistributedDeque'
  - added support for distributed guided and dynamic iterators
  - added support for an experimental 'TOML' module
  - improved support for mixing MPI with ugni, gasnet/aries, and/or qthreads
  - continued to improve the 'LinearAlgebra' module
  - improved Chapel-Python interoperability for the 'ZMQ' (ZeroMQ) module
  - converted many library routines to 'throw' in the event of errors
* performance improvements:
  - significantly improved the ability of the LLVM back-end to optimize Chapel
  - added support for serializing records across locales to cache local copies
  - started registering arrays dynamically for 'ugni' to improve NUMA locality
  - reduced the amount of locking used for associative array accesses
* array / domain / domain map improvements:
  - generalized 'LayoutCSR' to 'LayoutCS' to support CSR and CSC sparse layouts
  - improved the locality properties of sparse Block-distributed domains/arrays
  - improved the locality of distributed rank-change and reindex operations
  - improved the behavior and power of the 'Replicated' distribution
* other improvements:
  - various interoperability improvements for working with C pointers and memory
  - various improvements for the 'ugni' communication layer on Cray systems
  - numerous bug fixes, error message improvements, and third-party updates

New Dependencies / Configuration Changes
----------------------------------------
* added a new 'configure'/'make install' option for building+installing Chapel  
  (see https://chapel-lang.org/docs/1.16/usingchapel/building.html#installing-chapel)
* users of the LLVM-based front- or back-ends must now have CMake to build
* users of the 'Regexp' module / RE2 must now have a C++11 compiler to build
* made 'printchplenv' distinguish between config-file- vs. env-set variables
* made 'printchplenv' infer the location of CHPL_HOME

New Tools / Tool Changes
------------------------
* added an initial version of 'Mason', Chapel's package manager  
  (see https://chapel-lang.org/docs/1.16/tools/mason/mason.html)
* added a new 'c2chapel' tool that converts C headers to Chapel extern decls  
  (see https://chapel-lang.org/docs/1.16/tools/c2chapel/c2chapel.html)
* 'chpl'-generated executables now take the main module name rather than 'a.out'
* added support for LaTeX in chpldoc comments via MathJax
* chpldoc now indicates 'throw'ing functions in its output
* made chpldoc issue a warning if it detects open/close comment mismatches

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* made explicit 'module' declarations use strict error handling by default  
  (see https://chapel-lang.org/docs/1.16/technotes/errorHandling.html#relaxed-mode-for-explicit-modules)
* made reduce intents preserve the reduction variable's initial value  
  (see https://chapel-lang.org/docs/1.16/technotes/reduceIntents.html#overview)
* added support for iterators that can yield void values  
  (see https://chapel-lang.org/docs/1.16/technotes/voidVariables.html#void-functions-and-iterators)
* distinguished between functions returning 'void' values and non-returning fns  
  (see https://chapel-lang.org/docs/1.16/technotes/voidVariables.html)
* added a requirement that 'deinit()' routines have parentheses
* return intent overloads now permit value and 'const ref' overloads w/out 'ref'  
  (see 'Return Intent Overloads' in the 'Procedures' chapter of the spec)
* made it an error to apply bitwise-not (~) to boolean values

Syntactic/Naming Changes
------------------------
* single-statement 'local' blocks now require a 'do' keyword
* renamed the 'Barrier' module to 'Barriers'

New Features
------------
* added a 'defer' statement to aid with cleanup  
  (see 'The Defer Statement' in the 'Statements' chapter of the language spec)
* added support for 'try'/'try!' expressions ('catch' only in statement form)  
  (see https://chapel-lang.org/docs/1.16/technotes/errorHandling.html#try-expressions)
* added a 'prototype' keyword to relax checks for explicit module declarations  
  (see https://chapel-lang.org/docs/1.16/technotes/errorHandling.html#fatal-mode-for-implicit-and-prototype-modules)
* added support for conditional 'local' statements  
  (see https://chapel-lang.org/docs/1.16/technotes/local.html#syntax)
* added prototype support for choosing error strictness on a module granularity  
  (see https://chapel-lang.org/docs/1.16/technotes/errorHandling.html#strict-mode)
* added support for reindex() on arrays to accept a list of ranges  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/ChapelArray.html#ChapelArray.reindex)

Feature Improvements
--------------------
* significantly improved the implementation of initializers  
  (see https://chapel-lang.org/docs/1.16/technotes/initializers.html)
* significantly improved support for error-handling  
  (see https://chapel-lang.org/docs/1.16/technotes/errorHandling.html)
* significantly improved the generality and robustness of 'forwarding' fields
* added support for #-based comments in the parsing of '-f' configuration files  
  (see https://chapel-lang.org/docs/1.16/usingchapel/executing.html#setting-configuration-variables)
* improved the CHPL_UNWIND output to include more functions
* made --print-callgraph print calls into non-user code
* improved overload disambiguation for functions w/ partially generic arguments

Removed Features
----------------
* removed support for the deprecated '=>' operator for creating array aliases
* removed support for deprecated 'RandomStream' constructors
* retired support for the deprecated CHPL_TASKS=muxed runtime configuration

Standard Modules/Library
------------------------
* added 'throw'ing overloads to routines in 'IO', 'Regexp', 'FileSystem', ...
* added overloads to push_front(), push_back(), etc. that take array arguments  
  (e.g., see https://chapel-lang.org/docs/1.16/builtins/internal/ChapelArray.html#ChapelArray.push_back)
* added support for 'waitAll()' to the 'Futures' module  
  (see https://chapel-lang.org/docs/1.16/modules/packages/Futures.html#Futures.waitAll)
* added 'param' and 'type' overloads of getField() to the Reflection module  
  (see https://chapel-lang.org/docs/1.16/modules/standard/Reflection.html#Reflection.getField)
* added a new lines() iterator to channels  
  (see https://chapel-lang.org/docs/1.16/modules/standard/IO.html#IO.channel.lines)
* added support for file.getParentName() to the 'Path' module  
  (see https://chapel-lang.org/docs/1.16/modules/standard/Path.html#Path.file.getParentName)
* added ctime() to the 'datetime' type in the 'DateTime' module  
  (see https://chapel-lang.org/docs/1.16/modules/standard/DateTime.html#DateTime.datetime.ctime)
* added guided and adaptive iterators that accept domains  
  (see https://chapel-lang.org/docs/1.16/modules/standard/DynamicIters.html)
* gave the dynamic() iterators a default chunk size of 1
* added an asciiToString function that converts a uint(8) into a string  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/String.html#String.asciiToString)
* made the printing of comm diagnostics in 'CommDiagnostics' suppress zeroes
* closed memory leaks in the 'Regexp' module

Package Modules
---------------
* added support for a new 'Crypto' module based on OpenSSL  
  (see https://chapel-lang.org/docs/1.16/modules/packages/Crypto.html)
* added new 'Collection' modules, 'DistributedBag' and 'DistributedDeque'  
  (see https://chapel-lang.org/docs/1.16/modules/packages/Collection.html,  
   https://chapel-lang.org/docs/1.16/modules/packages/DistributedBag.html, and  
   https://chapel-lang.org/docs/1.16/modules/packages/DistributedDeque.html)
* added support for distributed guided and dynamic iterators  
  (see https://chapel-lang.org/docs/1.16/modules/packages/DistributedIters.html)
* added support for a new 'TOML' module (not 100% feature complete)  
  (see $CHPL_HOME/modules/packages/TOML.chpl)
* improved support for 'MPI' with ugni, gasnet/aries, and/or qthreads
* improved Chapel-Python interoperability for the 'ZMQ' (ZeroMQ) module
* improved the 'LinearAlgebra' module in a number of ways:
  - added a new 'Sparse' sub-module to 'LinearAlgebra'  
    (see https://chapel-lang.org/docs/1.16/modules/packages/LinearAlgebra/Sparse.html)
  - added diag() to support extracting diagonals and building diagonal matrices  
    (see https://chapel-lang.org/docs/1.16/modules/packages/LinearAlgebra.html#LinearAlgebra.diag)
  - optimized the implementation of dense transpose
* added 'throw'ing functions in HDFS

Standard Domain Maps (Layouts and Distributions)
------------------------------------------------
* generalized 'LayoutCSR' to 'LayoutCS' to support CSR and CSC sparse layouts  
  (see https://chapel-lang.org/docs/1.16/modules/layouts/LayoutCS.html)
* normalized the ReplicatedDist distribution and renamed it to 'Replicated'  
  (see https://chapel-lang.org/docs/1.16/modules/dists/ReplicatedDist.html  
   and https://chapel-lang.org/docs/1.16/primers/replicated.html)
* added a 'replicand' method to 'ReplicatedDist' supporting local access  
  (see https://chapel-lang.org/docs/1.16/modules/dists/ReplicatedDist.html  
   and https://chapel-lang.org/docs/1.16/primers/replicated.html)
* privatized sparse Block-distributed domains/arrays
* closed memory leaks in the DimensionalDist2D distribution

Interoperability Improvements
-----------------------------
* added support for 'c_sizeof()' to query sizes of C types  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/CPtr.html#CPtr.c_sizeof)
* added support for an 'isAnyCPtr()' query  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/CPtr.html#CPtr.isAnyCPtr)
* permitted c_mem*() routines to work with c_void_ptr arguments
* added support for c_memset()  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/CPtr.html#CPtr.c_memset)
* added support for printing 'c_ptr' and 'c_void_ptr' variables
* added support for an 'isExternClassType()' query

Performance Optimizations/Improvements
--------------------------------------
* significantly improved the ability of the LLVM back-end to optimize Chapel
* improved locality for sparse Block-distributed domains/arrays
* optimized bulkAdd calls for empty sparse domains
* reduced the amount of locking used for associative array accesses
* added support for serializing records across locales, supporting local copies
* optimized remote task creation for cases like 'coforall ... do on ... {}'
* automatically inline iterators that have multiple yields (10 by default)
* improved the performance of dynamic casting / subclass checks
* improved wide-pointer analysis for 'const ref' arguments
* reduced wide pointer overheads for 'Block' and 'Stencil' distributions
* fixed bugs in counting tasks and creating the right number of new tasks
* added support for parallel array initialization for arrays of POD eltTypes
* optimized the implementation of updateFluff() on the Stencil distribution
* privatized domains and distributions created by rank changes and reindexing
* made the domains and distributions of reindexed arrays preserve locality

Memory Improvements
-------------------
* stopped heap-promoting local variables used within on-clauses for 'qthreads'
* closed memory leaks in the 'Regexp' module and DimensionalDist2D distribution

Compiler Flags
--------------
(see 'man chpl' or https://chapel-lang.org/docs/1.16/usingchapel/man.html for details)
* added --permit-unhandled-module-errors to enable relaxed error checking
* added --print-unused-functions to identify unused routines
* added --[no-]remote-serialization to control cross-locale record copies
* added an --mllvm flag to set LLVM-based optimizations when using --llvm
* added --inline-iterators-yield-limit to cap # of yields to inline for iters
* gave the --cache-remote flag a --no-cache-remote variation
* removed the --strict-errors flag in favor of new more precise features
* removed the --conditional-dynamic-dispatch-limit flag and feature

Documentation
-------------
* added new primers on error-handling and the 'LinearAlgebra' module  
  (see https://chapel-lang.org/docs/1.16/primers/errorHandling.html and  
   https://chapel-lang.org/docs/1.16/primers/LinearAlgebralib.html)
* added a document describing built-in 'Error' types in Chapel  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/ChapelError.html)
* broke information about the 'Replicated' distribution into its own primer  
  (see https://chapel-lang.org/docs/1.16/primers/replicated.html)
* added a new 'Methods' chapter to the language spec and refreshed the content
* improved the language specification's definition of records
* documented the ability to specify configuration files via '-f'  
  (see https://chapel-lang.org/docs/1.16/usingchapel/executing.html#setting-configuration-variables)
* added missing documentation for range.low, high, stride, alignment, aligned  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/ChapelRange.html#ChapelRange.range.stride)
* added missing documentation for reindex() and localSlice()  
  (see https://chapel-lang.org/docs/1.16/builtins/internal/ChapelArray.html#ChapelArray.reindex  
   and https://chapel-lang.org/docs/1.16/builtins/internal/ChapelArray.html#ChapelArray.localSlice)
* fixed an oversight in the specification to indicate that '=' is overloadable

Example Codes
-------------
* added new primer examples for error-handling, linear algebra, and replication  
  (see examples/primers/errorHandling.chpl,  
       examples/primers/LinearAlgebralib.chpl, and  
       examples/primers/replicated.chpl)
* updated example programs to use initializers rather than constructors
* updated example programs with respect to new error-handling features
* added new faster versions of the mandelbrot and chameneos CLBG benchmarks  
  (see examples/benchmarks/shootout/mandelbrot-fast.chpl and  
   examples/benchmarks/shootout/chameneosredux-fast.chpl)
* changed the knucleotide CLBG program to use the default 'parSafe' mode  
  (see examples/benchmarks/shootout/knucleotide.chpl)
* rewrote ISx to use a more elegant global domain declaration  
  (see examples/benchmarks/isx/)
* rewrote SSCA2 to use the standard 'Barriers' module and closed memory leaks  
  (see examples/benchmarks/ssca2/)
* renamed the 'opaque domains and arrays' primer to 'opaque-domains.chpl'
* made other updates to example programs to reflect changes since 1.15

Locale Models
-------------
* added a new locale model for AMD Accelerator Processing Units (APUs)  
  (see https://github.com/chapel-lang/chapel/blob/release/1.16/doc/rst/developer/chips/22.rst)
* stopped storing arrays as multiple distinct chunks in the 'numa' locale model
* ensured that existing locale models clean up after themselves at program exit

Portability
-----------
* added support for using Chapel on an OmniPath cluster  
  (see https://chapel-lang.org/docs/1.16/platforms/omnipath.html)
* improved code conformance with C++14
* improved code portability with respect to various versions of gcc
* improved portability of code with respect to Cygwin

Cray-specific Changes
---------------------
* started registering arrays dynamically for 'ugni' to improve NUMA locality
* optimized strided puts and gets for CHPL_COMM=ugni
* split large transfers for CHPL_COMM=ugni
* reduced the default heap size for CHPL_COMM=ugni
* removed caveat about ugni registration limits in Cray documentation
* retired official support for the 'cray-xt' platform

Syntax Highlighting
-------------------
* added some missing keywords to 'vim', 'emacs', and 'highlight' highlighters

Error Messages / Semantic Checks
--------------------------------
* improved 'const' checking
* extended --div-by-zero-checks to also check for modulus (%) 0 operations
* added an error message for exported functions with generic arguments
* improved error messages for illegal 'delete' statements
* removed checks that iterators must contain 'yield' statements; they need not
* added an error for records that try to subtype another type
* added a number of error messages for poorly formed (or unsupported) init()s
* added a warning for --library compiles on code containing a main() routine
* improved the error message generated when closing a file before its channels
* added an error for returning a tuple of the wrong size
* added a warning for potential confusions related to implicit module naming
* improved an error message for bad forwarding calls to parallel iterators
* improved an error message about type mismatches between fields

Bug Fixes
---------
* fixed a number of bugs related to initializers
* fixed a number of bugs related to error-handling
* fixed several bugs in the 'forwarding' feature for object fields
* fixed bugs in counting tasks and creating the right number of new tasks
* fixed bugs for several forall intent cases
* fixed a bug in which a qualified module reference was incorrectly shadowed
* fixed a bug in isAlpha() for characters between upper- and lowercase letters
* fixed a bug in bulk assignment for rank-change slices
* fixed a bug in variable deinitialization order
* fixed a bug in which 'use' statements were not considered in program order
* fixed a bug in which 'rmTree' would not remove directories with hidden files
* fixed some bugs in loop invariant code motion (LICM)
* fixed a portability bug in padding years in the DateTime module
* fixed a bug in dead code elimination relating to local record types
* fixed a bug comparing floating point expressions on linux32
* fixed a bug in complicated type aliases
* fixed a bug in denormalization for '~' for small integers
* fixed a bug in which remote-value forwarding didn't handle dereferences well
* fixed a bug relating to scoped accesses to internal modules
* fixed bugs with parallel iteration over domains with non-natural alignment
* fixed a bug in the implementation of the &= operator for associative domains
* fixed a bug in applying 'reindex()' to an empty domain/array
* fixed a bug in modules with just one non-initialization function declaration
* fixed a bug in dead code elimination for do-while loops
* fixed a bug in which isRecord*() returned 'true' for sync/single types
* fixed a bug related to task counters not being stored in task-local storage
* fixed a bug for ambiguous 'param' methods
* fixed a bug in 'fifo' tasking in which not enough threads were created

Launchers
---------
* added a 'gasnetrun_psm' launcher for running on OmniPath interconnects  
  (see https://chapel-lang.org/docs/1.16/usingchapel/launcher.html#currently-supported-launchers)
* fixed some bugs in the pbs-gasnetrun_ibv and slurm-based launchers

Generated Code
--------------
* cleaned up generated code for no-op statements referencing symbols

Third-Party Software Changes
----------------------------
* updated the compiler to be compatible with newer versions of LLVM
* switched the LLVM back-end to use version 4.0.1 by default
* updated GASNet to version 1.30.0
* updated hwloc to version 1.11.8
* updated GMP to version 6.1.2
* updated RE2 to commit a810d71
* enabled support for multiple communication domains in GASNet for gemini/aries

Testing System
--------------
* dramatically improved the quality of the generated web performance graphs
* improved the redirection of stderr into log files

Developer-oriented changes: Module changes
------------------------------------------
* added a "function terminates program" pragma to identify halt() and exit()
* simplified how automatic 'use's are handled in internal modules

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* made our Makefiles respect CFLAGS, CPPFLAGS, and CXXFLAGS
* we now build the compiler with C++11 when possible for gcc, clang, icc

Developer-oriented changes: Compiler Flags
------------------------------------------
* added --user-constructor-error to flag uses of constructors in user code
* added --force-initializers to generate default initializers for some types
* added --llvm-print-ir to dump the LLVM internal representation to stdout
* added --llvm-print-ir-stage to specify which LLVM stage should print the IR
* improved the behavior of the --log flag
* flipped --log-ids to be on by default
* made --print-module-resolution print AST counts

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* significant clean-up/refactoring of the compiler's resolution passes
* cleaned up / refactored aspects of file handling, parsing, and building AST
* converted more compiler data structures to use the STL
* made greater use of qualified types in compiler passes
* improved the internal representation of forall loops
* reduced the amount of nondeterminism in the compiler
* removed support for trying to handle references in copyPropagation
* added a "last resort" pragma/flag for error-case overloads
* removed support for the conditional-based dynamic dispatch implementation
* improved the management of well-known functions within the compiler
* cleaned up how the compiler manages the 'program' and 'root' modules
* added support for traversing the top-level modules
* refactored the cleanup pass to process a module at a time and cleaned it up
* cleaned up aspects of buildDefaultFunctions
* removed the reaching definition analysis portion of dead code elimination
* added 'parentlocid' command within the compiler's gdb support
* many other code cleanups, reorganizations, and refactorings

Developer-oriented changes: Documentation improvements
------------------------------------------------------
* fixed a bug in which CHIPs couldn't be built into HTML

Developer-oriented changes: Module improvements
-----------------------------------------------
* added a field to the 'channel' record indicating the originating locale

Developer-oriented changes: Runtime improvements
------------------------------------------------
* improved the mechanism we use to look for bad memory allocation/exit calls
* updated get/put runtime calls to include a file-unique ID
* added wrapper functions for direct calls to the system memory allocator

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* changed our Makefiles so that third-party code gets rebuilt when needed



version 1.15.0
==============

Eighteenth public release of Chapel, April 6, 2017

Highlights (see subsequent sections for further details)
--------------------------------------------------------
* performance optimization highlights:
  - significantly improved the performance of many key idioms and benchmarks
  - dramatically improved task creation speed
  - reduced overheads related to array slicing, rank-change, and reindexing
  - significantly improved the remote value forwarding optimization
  - optimized the performance of latency-bound applications with CHPL_COMM=ugni
  - improved qthreads tasking such that it outperforms 'muxed' on studied codes
* standard library/package highlights:
  - added a new 'DateTime' module for operating on dates and times
  - added BLAS level 1 and 2 routines to the previous support for level 3
  - added an early-draft 'LinearAlgebra' module
  - added a new 'Futures' module supporting library-based futures
  - added initial support for some class-owner patterns, 'Owned' and 'Shared'
  - added support for choosing between implementations for the 'FFTW' module
* language improvements:
  - dramatically improved support for object initializers and deinitializers
  - added prototype support for error-handling in Chapel
  - significantly improved array semantics and memory management
  - improved support for generic classes and records
  - made 'void' a first-class type in the language and a way to fold variables
  - added support for module deinit() functions
  - added support for 'forwarding' methods to fields of classes and records
  - vastly improved the stability, generality, and precision of 'where' clauses
* portability highlights:
  - added a locale model for KNL with support for different memory types
  - added Chapel support for AWS EC2
  - verified that Chapel works with the Windows 10 bash shell as with Ubuntu
  - improved support for ARM processors including multi-locale support
* implementation highlights:
  - closed significant memory leaks caused by arrays, domains, and domain maps
  - added support for numa-localization of array memory
  - improved array slice, rank change, and reindexing support for domain maps
  - streamlined several aspects of the domain map standard interface (dsi)
* additional highlights:
  - added new users guide text for promotion, constants, type aliases, configs
  - enabled GitHub issues to file and track Chapel bugs and feature requests
  - added the 'ugni' communication layer to the open-source repository
  - updated our versions of GASNet, Qthreads, jemalloc, and hwloc

Deployment
----------
* enabled GitHub issues to file and track Chapel bugs and feature requests  
  (see https://github.com/chapel-lang/chapel/issues)
* extended the Docker image to include a GASNet-based configuration  
  (see https://hub.docker.com/r/chapel/chapel/)

New Features
------------
* dramatically improved support for initializers  
  (see https://chapel-lang.org/docs/1.15/technotes/initializers.html  
   and https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/chips/10.rst)
* added prototype support for error-handling in Chapel  
  (see https://chapel-lang.org/docs/1.15/technotes/errorHandling.html  
   and https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/chips/8.rst)
* added support for deinit() as a replacement for class/record destructors  
  (see "Class Deinitializer" and "Record Deinitializer" sections in the spec  
   and https://github.com/chapel-lang/chapel/blob/main/doc/rst/developer/chips/10.rst)
* added support for 'forwarding' methods to fields of classes and records  
  (see https://chapel-lang.org/docs/1.15/technotes/forwarding.html)
* made 'void' a first-class type in the language and a way to fold variables  
  (see https://chapel-lang.org/docs/1.15/technotes/voidVariables.html  
   and $CHPL_HOME/examples/primers/voidVariables.chpl)
* added support for module deinit() functions  
  (see "Module Deinitialization" in the "Modules" chapter of the specification)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* functions that return array expressions now return by value by default  
  (see https://chapel-lang.org/docs/1.15/language/evolution.html#arrays-return-by-value-by-default)
* made the default intent for arrays be 'ref' if modified, else 'const ref'  
  (see https://chapel-lang.org/docs/1.15/language/evolution.html#array-default-intent  
   and "Array Arguments to Functions" in the "Arrays" chapter of the spec)
* made the default intent for 'this' on record methods be 'ref' if modified  
  (see https://chapel-lang.org/docs/1.15/language/evolution.html#record-this-default-intent)
* deprecated support for the '=>' operator to create array aliases  
  (see https://chapel-lang.org/docs/1.15/language/evolution.html#array-alias-operator-deprecated)
* deprecated support for using '=>' in constructors to create alias fields

Syntactic/Naming Changes
------------------------
* renamed the 'Error' module to 'SysError'  
  (see https://chapel-lang.org/docs/1.15/modules/standard/SysError.html)

Feature Improvements
--------------------
* vastly improved the stability, generality, and precision of 'where' clauses  
  (see "Where Expressions" in the "Procedures" chapter of the specification)
* improved array slice, rank change, and reindexing support across domain maps
* extended return intent overloading to improve its utility and flexibility  
  (see "Return Intents" in the "Procedures" chapter of the specification)
* added support for using 'const' and 'const ref' as 'this' intents  
  (see "The Method Receiver and the this Argument" sections in the spec)
* added support for defining type aliases for generic classes  
  (e.g., 'type Vec = Vector;' is now supported for a generic type 'Vector')
* added the ability to define secondary methods on instantiated types  
  (e.g., 'proc (R(int)).foo() { ... }' defines foo on R(int) but not R(real)  
   see "Class Methods" section in the Classes chapter of the specification)
* made tuple semantics more closely follow the behavior of their element types
* added min() and max() overloads that accept and generate 'param' values
* added support for casts between c_void_ptr and class objects/c_string
* improved the default hash functions used by associative domains
* reduced opportunities for races on set operations for associative arrays
* enabled 'param's and 'config param's to be specified without initializers

Known Feature Slips
-------------------
* domains of reindexed distributed arrays are not distributed as they should be
* removed support for having first-class functions capture outer variables

Removed Features
----------------
* removed the 'noRefCount' config const which is no longer necessary
* removed deprecated functions from the 'Sort' and 'Search' modules
* removed the deprecated 'BigInt' class in favor of the 'bigint' value type

Standard Modules/Library
------------------------
* added support for a 'DateTime' module for operating on dates and times  
  (see https://chapel-lang.org/docs/1.15/modules/standard/DateTime.html)
* improved the initializer argument list and order for RandomStream  
  (see https://chapel-lang.org/docs/1.15/modules/standard/Random.html)
* converted the 'barrier' type from a class into a record  
  (see https://chapel-lang.org/docs/1.15/modules/standard/Barrier.html)
* added support for a .shape query on domains and arrays  
  (see https://chapel-lang.org/docs/1.15/builtins/internal/ChapelArray.html#ChapelArray.shape)
* added support for 'targetLocales' query to default rectangular arrays/domains
* made count() on arrays parallel by default
* added support for passing comparators to the domain.sorted() iterator  
  (see https://chapel-lang.org/docs/1.15/builtins/internal/ChapelArray.html#ChapelArray.sorted)
* made conjg() generate the same type as its argument  
  (see https://chapel-lang.org/docs/1.15/modules/standard/Math.html#Math.conjg)
* improved memory management for the 'List' module

Package Modules
---------------
* added initial support for some class-owner record patterns, Owned and Shared  
  (see https://chapel-lang.org/docs/1.15/modules/packages/OwnedObject.html  
   and https://chapel-lang.org/docs/1.15/modules/packages/SharedObject.html)
* added support for a new 'Futures' module supporting library-based futures  
  (see https://chapel-lang.org/docs/1.15/modules/packages/Futures.html)
* added BLAS level 1 and 2 routines to the previous support for level 3  
  (see https://chapel-lang.org/docs/1.15/modules/packages/BLAS.html)
* removed support for the 'ldA' arguments in the BLAS module
* added an early-draft 'LinearAlgebra' module  
  (see https://chapel-lang.org/docs/1.15/modules/packages/LinearAlgebra.html)
* added support for choosing between FFT implementations in the FFTW module  
  (see https://chapel-lang.org/docs/1.15/modules/packages/FFTW.html#FFTW.isFFTW_MKL)
* improved support for the 'MatrixMarket' module

Interoperability Improvements
-----------------------------
* improved 'require' statements to accept 'param' string expressions  
  (see https://chapel-lang.org/docs/1.15/technotes/extern.html#expressing-dependencies)
* now only 'require' statements in resolved code add requirements  
  (see https://chapel-lang.org/docs/1.15/technotes/extern.html#expressing-dependencies)

Performance Optimizations/Improvements
--------------------------------------
* improved parallel tasking performance using a hybrid spin/condwait strategy
* optimized the creation of tasks for certain coforalls with known trip counts
* moved argument bundles for tasks and on-clauses from the heap to task stacks
* switched qthreads to use Chapel's registered heap for its memory requirements
* reduced array overhead by eliminating reference counting overheads
* optimized 1D strided iterations
* reduced the overhead of slicing, rank-change slicing, and reindexing arrays
* reduced the amount of communication required for a number of idioms
* improved the precision of the array index optimization introduced in 1.14
* stopped limiting the number of ugni communication domains with slurm on Crays
* optimized a costly temporary array out of the BlockCyclic distribution
* added intra-locale parallelism for iterations over BlockCyclic distributions
* improved loop-invariant code motion for iterator expressions
* improved the cases handled by, and accuracy of, remote value forwarding
* removed redundant field initializations in init() routines
* improved the performance of casts from strings to numeric types
* optimized '<~>' overloads to avoid unnecessary reference counting

Memory Improvements
-------------------
* closed significant memory leaks caused by arrays, domains, and domain maps
* reduced the memory footprint of a non-stridable range
* made the 'list' type reclaim its memory on destruction
* fixed a memory leak in the push_back() routine

Example Codes
-------------
* added a new primer for 'void' variables and fields  
  (see $CHPL_HOME/examples/primers/voidVariables.chpl)
* made style and content improvements to the 'learnChapelInYMinutes' primer  
  (see $CHPL_HOME/examples/primers/learnChapelInYMinutes.chpl)
* made a number of LCALS cleanups and fixes including support for a SPMD mode  
  (see $CHPL_HOME/examples/benchmarks/lcals/)
* switched ISx's arrays to use anonymous domains for a performance boost  
  (see $CHPL_HOME/examples/benchmarks/isx/)
* added a new 'regexdna-redux' benchmark  
  (see $CHPL_HOME/examples/benchmarks/shootout/regexdna-redux.chpl)
* made a number of speed and clarity improvements to the 'fasta' benchmark  
  (see $CHPL_HOME/examples/benchmarks/shootout/fasta.chpl)
* made readability and correctness improvements to our 'pidigits' benchmark  
  (see $CHPL_HOME/examples/benchmarks/shootout/pidigits.chpl)
* fixed an off-by-one error in our 'binarytrees' benchmark
* fixed an assignment-to-const bug in binary-trees
* added missing Makefiles and fixed support for 'make -j'
* updated example codes to use new RandomStream() initializer
* updated example codes to reflect better const-checking
* updated example codes to use deinit() rather than destructors
* updated example codes to reflect that barrier is now a record
* removed the 'fastaredux' benchmark, which is no longer used by the CLBG

Documentation
-------------
* added new users guide sections on promotion, constants, type aliases, configs  
  (see https://chapel-lang.org/docs/1.15/users-guide/)
* revised QUICKSTART instructions for clarity  
  (see https://chapel-lang.org/docs/1.15/usingchapel/QUICKSTART.html)
* reorganized the doc/ directory in the release tarball  
  (see $CHPL_HOME/doc/README.md  
   or https://github.com/chapel-lang/chapel/blob/main/doc/README.rst)
* removed $CHPL_HOME/STATUS in favor of GitHub issues
* updated bugs.rst to refer users to GitHub issues  
  (see https://chapel-lang.org/docs/1.15/usingchapel/bugs.html)
* improved the Docker README information  
  (see https://hub.docker.com/r/chapel/chapel/)
* reorganized the platform-specific documentation pages into categories  
  (see https://chapel-lang.org/docs/1.15/platforms/)
* added documentation for dim() and dims() on arrays  
  (see https://chapel-lang.org/docs/1.15/builtins/internal/ChapelArray.html#ChapelArray.dims)
* fixed the documentation for string.strip()  
  (see https://chapel-lang.org/docs/1.15/builtins/internal/String.html#String.string.strip)
* updated documentation regarding reference counting of files and channels
* added an indication that IO is a module that is used by default
* updated documents to refer to download.html rather than install.html
* improved some entries in the "quick reference" document  
  (see https://chapel-lang.org/docs/1.15/_downloads/quickReference.pdf)

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* added a '--[no-]print-callgraph flag to print a Chapel program's callgraph
* added a '--[no-]div-by-zero-checks' flag to disable divide-by-0 checks
* added a '--strict-errors' flag for enabling strict error-checking
* added a '--[no-]infer-local-fields' flag to control wide pointer optimization
* removed the --[no-]optimize-array-indexing flag, now performed automatically

Locale Models
-------------
* added a locale model for KNL with support for different memory types  
  (see https://chapel-lang.org/docs/1.15/technotes/localeModels.html#knl-locale-model  
   and https://chapel-lang.org/docs/1.15/platforms/knl.html)
* for 'numa', arrays are now allocated using multiple per-numa-domain chunks  
  (see https://chapel-lang.org/docs/1.15/technotes/localeModels.html#numa-locale-model)

Portability
-----------
* added Chapel support for AWS EC2  
  (see https://chapel-lang.org/docs/1.15/platforms/aws.html)
* verified that Chapel works with the Windows 10 bash shell as with Ubuntu
* improved support for ARM processors including multi-locale support  
  (see https://chapel-lang.org/docs/1.15/platforms/arm.html)

Platform-specific Changes
-------------------------
* fixed an occasional cygwin failure caused by pthread_attr_init()

Cray-specific Changes
---------------------
* made Cray systems always default to CHPL_COMM=ugni
* stopped limiting the number of ugni communication domains under slurm
* tuned the amount of task spinning before sleeping for Crays
* CHPL_TASKS=muxed is now deprecated and will be removed in future releases
* removed extraneous/incorrect -O flags from cray-prgenv-cray command lines
* make the heap used by CHPL_COMM=ugni 'numa'-localized when appropriate
* fixed a problem when using 'muxed' tasking with 'gasnet' but no hugepages
* enabled support for CHPL_COMM=ugni for the pgi compiler
* fixed a bug in dynamic linking for gasnet-aries

Error Messages
--------------
* significantly improved const-checking in the compiler
* added an error message for re-assigning a 'param' after its initialization
* added an error when 'inline' is applied to a recursive function
* added an error when trying to cast to values rather than types
* added an error message for trying to capture generic functions
* added an error message for initializers that attempt to return a value
* added an error message for missing copy initializers
* made the compiler indicate illegal 'param' types more clearly
* added support for printing multiple 'param' errors before halting compilation
* added an error when using domain queries in field declarations
* added an error message for querying the 'IRV' of a non-sparse array
* added error messages for applying vector ops to non-1D rectangular arrays
* improved error messages for the $CHPL_HOME/util/chplenv/ scripts
* removed warnings for serialized assignments in some cases

Runtime Error Checks
--------------------
* added a runtime check for divide-by-zero by default
* added a runtime check for empty bounding boxes to the 'Block' distribution

Bug Fixes
---------
* fixed a number of bugs relating to array-of-array and sparse-array semantics
* fixed a bug in reading null bytes into strings when lengths are specified
* fixed a bug in resetting size when clearing sparse block-distributed domains
* fixed a bug in which 'uint **= uint' failed to resolve
* fixed a bug in the support of 'extern' blocks
* fixed a bug in which the wrong LD was selected by our Makefiles
* fixed a buffer overflow problem in the parser for long function signatures
* fixed a broken link to Quickstart.rst
* fixed a bug in which the LLVM back-end couldn't support multiple --ccflags
* fixed an off-by-one bug in string.split()
* fixed a bug related to extern procedures returning 'void'
* fixed a bug with arrays of c_strings in --no-local compilation mode
* fixed a bug in the order of module-scope variable deinitializations
* fixed a bug in the find() routine on arrays generalizing it to non-1D arrays
* fixed a bug in which type methods did not support default arguments well
* fixed a bug in pop_front() which caused the array to grow
* fixed a bug in which the --cpp-lines flag was sometimes ignored
* fixed a bug in 'Spawn' when one sub-process consumes another's output
* fixed a bug in BlockCyclic indexing
* fixed a bug in which user-defined initializers wouldn't accept array fields
* fixed a bug in creating virtual dispatch tables for generic class inheritance
* fixed a bug in recursive iterator inlining
* fixed a bug supporting 'stridable' queries on Replicated arrays
* fixed a copy propagation bug related to array allocation
* fixed a 'chplvis' bug that caused segmentation faults
* fixed a bug in which type methods were overly generic w.r.t. their receiver
* fixed a bug in casting reference expressions
* fixed a race condition in initializing locale models
* fixed bugs in the standalone parallel iterator for CSR domains
* fixed a bug related to module-scoped 'ref' declarations
* fixed a bug in which the number of CPUs was sometimes reported to be 0
* fixed bugs in the 'localSubdomain*' calls for local arrays/domains

Launchers
---------
* made the --spmd flag to the mpirun launcher default to '1'

Runtime Library Changes
-----------------------
* added the 'ugni' communication layer to the open-source repository
* added support for numa-localization of array memory
* switched qthreads to use Chapel's memory allocator
* changed our use of qthreads to initialize them in detached state
* updated massivethreads to make use of stack-allocated task bundles

File/Directory Structure
------------------------
* moved object files for the compiler and runtime into $CHPL_HOME/build
* changed the naming/structure of directories used to store binary files

Generated Code
--------------
* turned on --denormalize by default, resulting in shorter, cleaner code
* improved formatting of formal arguments in generated code for --gen-ids

Third-Party Software Changes
----------------------------
* updated to GASNet 1.28.0
* updated to qthreads 1.12
* updated to jemalloc 4.5.0
* updated to hwloc 1.11.6
* made GASNet build 'amudprun' using host compiler rather than target
* limited the maximum size of qthreads memory pools
* made 'hwloc' always use libnuma for non-flat locale models when available
* improved the portability of our libunwind support

Testing System
--------------
* added --multi-locale-only and --max-locales flags to 'start_test'
* added a '-dirs' option to paratest.server to specify directories to test
* added an '-env' flag to paratest.server for forwarding environment variables
* added the ability to filter on graph names in the performance tracker
* made the test system work even when CHPL_UNWIND is set
* added a checker for the ANNOTATIONS.yaml file used by performance tracking
* added overlays of the nightly performance graphs to the release-over-release

Developer-oriented changes: Configuration changes
-------------------------------------------------
* extended CHPL_LLVM to support new modes: llvm-minimal and system[-minimal]

Developer-oriented changes: Module changes
------------------------------------------
* refactored locale models code
* optimized out array fields used only in non-flat configurations using 'void'
* added 'export' to locale model routines to avoid widening arguments
* refactored rectangular I/O into a single helper routine
* moved c_void_ptr comparisons from CPtr to ChapelBase
* added a developer feature for specifying arrays' initialization approaches
* removed an unnecessary argument from _bulkGrow
* simplified the 'dsi' interface for slicing, rank-change, and reindexing  
  (see https://chapel-lang.org/docs/1.15/technotes/dsi.html)
* updated the 'dsi' interfaces for establishing new domains
* cleaned up how the MPI module deinitializes/finalizes itself

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* improved the robustness of 'make check'
* worked around a race condition in GASNet's Makefiles
* cleaned up the runtime include paths
* improved linking of libnuma when using the memkind library
* improved Makefile portability for Bourne and limited shells

Developer-oriented changes: Compiler Flags
------------------------------------------
* removed the --report-optimized-array-indexing flag, no longer required

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* made PRIM_GETCID return an int(32) rather than a bool
* replaced four FnSymbol fields and a flag with a std::map
* improved the compiler's opt-in verification checks
* updated the compiler's representation of 'ref' types to use qualified types
* fixed a segfault in list_ast() for type-less symbols
* changed more compiler data structures over to their STL equivalents
* made PRIM_WIDE_GET_ADDR return a c_void_ptr
* each symbol now stores a list of associated SymExprs
* made some fixes to for_vector, for_set, and for_queue
* fixed a bug in getVisibleFunctions relating to forall intents
* added an ADT for representing forall intents
* removed unnecessary code from inlineFunctions
* refactored codegen-related methods from AST/expr.cpp to codegen/expr.cpp
* minor improvements to the AstDumpToNode debugging output
* made compute_call_sites() re-entrant
* refactored code implementing inlining
* improved the implementation of destructors/deinitializers
* rewrote buildDefUseMaps and compute_call_sites to use SymExpr info in Symbols
* eliminated an unnecessary vector computed in flattenClasses
* refactored FnSymbol::tag_generic(), renamed to tagIfGeneric() for clarity
* cleaned up and simplified normalize, particularly w.r.t. initializers
* improved ability to modify code around a function's epilogue label
* fixed a minor bug in printResolutionErrorUnresolved()
* unified the number of memory descriptors created for --devel vs. --no-devel
* significantly refactored build_record_init_function()
* fixed a bug in which copies of AggregateTypes lost their initializerStyles
* reduced the degree to which init was implemented similar to constructors
* added a type method to be used to initialize object init() methods
* removed unused FLAG_SPECIFIED_RETURN_TYPE
* replace uses of buildDefUseMaps with SymExpr information in Symbols
* extended CallInfo to support generic initializers
* refactored elements of resolution to better support initializers
* refactored the initialization of configs away from traditional declarations
* added AggregateType::isGeneric()
* updated the logic for pruning unused module-scope variables
* removed the complex but not very useful single-yield iterator optimization
* removed Symbol::getFnSymbol()
* streamlined the normalization of many variable declarations
* removed a leak-based workaround in formalRequiresTemp()
* added cast-related functions to the compiler
* converted several parser buffers over to std::string
* reduced number of cases where the compiler treats certain records specially
* removed the wide-return optimization due to complexity and lack of impact
* added a new primitive, PRIM_INIT_VAR, for variable initializations
* removed the old compiler-based optimization of array access inner multiplies
* revised the code to generate default initializers for tuples
* disabled deadStringLiteralElimination without inlining or copy-propagation
* hoisted gdbShouldBreakHere() calls to get earlier compiler breakpoints
* improved the precision of canRHSBeConstRef() in inferConstRefs
* made isPrimitiveScalar() recognize bools of size BOOL_SIZE_SYS
* have internal actual-formal argument count mismatches print function name

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added an API for performing task ID comparisons
* moved stray .c files out of runtime/include
* fixed some issues in how privatization works
* updated some interfaces to use c_nodeid_t rather than int32_t
* removed some dead code in the qthreads tasking layer
* changed how and when the heap page size is computed

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* protected our jemalloc symbols to avoid conflicts with the memkind library



version 1.14.0
==============

Seventeenth public release of Chapel, October 6, 2016

Highlights (see subsequent sections for more details)
-----------------------------------------------------
* performance optimization highlights:
  - optimized array accesses for programs using simple/common array operations
  - dramatically improved performance of promoted expressions over aligned data
  - streamlined memory management through new jemalloc upgrades and features
  - optimized reductions by using an atomic spin lock rather than a sync var
  - enabled the bulk transfer of strided array slices by default
  - significantly optimized 'sync' variables when using 'qthreads' tasking
* standard library highlights:
  - added a new standard 'BigInteger' module providing value-based 'bigint's  
    (see https://chapel-lang.org/docs/1.14/modules/standard/BigInteger.html)
  - added new communication package modules for MPI and ZeroMQ
    (see https://chapel-lang.org/docs/1.14/modules/packages/MPI.html and  
     https://chapel-lang.org/docs/1.14/modules/packages/ZMQ.html)
  - added new package modules for BLAS, MatrixMarket, and range chunking  
    (see https://chapel-lang.org/docs/1.14/modules/packages/BLAS.html,  
     $CHPL_HOME/modules/packages/MatrixMarket.chpl, and  
     https://chapel-lang.org/docs/1.14/modules/packages/RangeChunk.html)
  - dramatically revamped the Sort and Search modules, including comparators  
    (see https://chapel-lang.org/docs/1.14/modules/packages/Sort.html and  
     https://chapel-lang.org/docs/1.14/modules/packages/Search.html)
* domain map highlights:
  - added support for Block-distributed sparse domains and arrays  
    (see https://chapel-lang.org/docs/1.14/modules/dists/BlockDist.html)
  - added a new 'StencilDist' distribution in support of stencil access patterns  
    (see https://chapel-lang.org/docs/1.14/modules/dists/StencilDist.html)
* implementation improvement highlights:
  - added a capability for generating stack traces on 'halt's  
    (see https://chapel-lang.org/docs/1.14/usingchapel/chplenv.html#chpl-unwind)
  - improved support for reduce intents on parallel loops  
    (see https://chapel-lang.org/docs/1.14/technotes/reduceIntents.html)
  - added the ability to implement Chapel's atomics using C atomics  
    (see https://chapel-lang.org/docs/1.14/usingchapel/chplenv.html#chpl-atomics)
  - added the ability to pass Chapel functions to extern C routines  
    (see https://chapel-lang.org/docs/1.14/technotes/extern.html#c-fn-ptr)
* documentation and example code highlights:
  - added the primer and "hello world" example codes to the online documentation  
    (see https://chapel-lang.org/docs/1.14/primers/ and  
     https://chapel-lang.org/docs/1.14/examples/)
  - completed and updated our suite of Computer Language Benchmark Game codes  
    (see $CHPL_HOME/examples/benchmarks/shootout/* and  
     http://benchmarksgame.alioth.debian.org/)
  - added several new pages to the online users guide  
    (see https://chapel-lang.org/docs/1.14/users-guide/)
* additional highlights:
  - made significant improvements to the 'chplvis' execution analysis tool  
    (see https://chapel-lang.org/docs/1.14/tools/chplvis/chplvis.html)
  - added support for a new .chplconfig file supporting default CHPL_* settings  
    (see https://chapel-lang.org/docs/1.14/usingchapel/chplenv.html)
  - clarified errors related to modifying 'const' intent-based shadow variables
  - updated versions of: jemalloc, GASNet, qthreads, hwloc, massivethreads  
    (see $CHPL_HOME/third-party/*)
  - closed several classes of memory leaks, most notably due to sync/single vars
  - improved the portability of the code base
  - numerous bug fixes

Configuration Changes
---------------------
* added support for a new .chplconfig file supporting default CHPL_* settings  
  (see https://chapel-lang.org/docs/1.14/usingchapel/chplenv.html)
* added an '--anonymize' flag to 'printchplenv' to hide potential sensitivities
* enabled 'jemalloc' by default on 'darwin' platforms using 'gnu' compilers
* enabled 'jemalloc' for target compilers 'pgi' and 'cray-prgenv-cray'
* changed the 'numa' locale model to use the 'distrib' scheduler for 'qthreads'

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* Chapel now permits trailing commas within tuples and array literals  
  (see 'Tuple Values' and 'Rectangular Array Literals' in the language spec)
* made casts between 'real' and 'imag' types preserve floating point values
* added support for empty 'only'/'except *' qualifiers on 'use' statements  
  (e.g., 'use M only ;' or 'use M except *;' requires qualified naming)
* added a new reduce= operator for intent-based reductions  
  (see https://chapel-lang.org/docs/1.14/technotes/reduceIntents.html)
* made assigning stridable ranges and domains to non-stridable an error
* stopped implicit 'use' of standard automatic modules within user sub-modules

Syntactic/Naming Changes
------------------------
* added the ability to specify an optional 'do' on 'otherwise' statements

New Features
------------
* added a capability for generating stack traces on 'halt's  
  (see https://chapel-lang.org/docs/1.14/usingchapel/chplenv.html#chpl-unwind)
* added support for iterating over, and querying the 'size' of enumerated types  
  (see 'Enumerated Types' in the language specification)
* added support for recursive record/class initializers
* added new .bulkAdd()/+= features for sparse domains supporting bulk index adds  
  (see https://chapel-lang.org/docs/1.14/builtins/ChapelArray.html)
* added support for reduce intents with different input/state/output types
* added an 'align' operator for domains  
  (see 'Domain Alignment' in the language specification)
* added casts and safeCasts to turn stridable ranges/domains into non-stridable
* added support for 'retType' and 'argTypes' queries to first-class functions  
  (see https://chapel-lang.org/docs/1.14/technotes/firstClassFns.html#reflection)
* added the ability to create serial iterators for types  
  (see 'The Method Receiver and the 'this' Argument' in the language spec)
* added early prototype support for class/record initializers (constructors)  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/chips/10.rst)

Feature Improvements
--------------------
* added support for a requestCapacity() method on associative domains  
  (see https://chapel-lang.org/docs/1.14/builtins/ChapelArray.html)
* added the ability to query locality information of domains and distributions  
  (see https://chapel-lang.org/docs/1.14/builtins/ChapelArray.html)
* improved the support for compilerError, compilerWarning, and compilerAssert  
  (see https://chapel-lang.org/docs/1.14/builtins/UtilMisc_forDocs.html)
* made promoted array assignments always use a parallel loop
* extended the number of indices that an associative domain can store
* added the ability to have 'param' formal arguments on parallel iterators
* preserved 'param' values within the context of 'forall' loops
* added support for casting from 'param' values to arrays

Interoperability Improvements
-----------------------------
* added the ability to pass Chapel functions to extern C routines  
  (see https://chapel-lang.org/docs/1.14/technotes/extern.html#c-fn-ptr)
* added support for casts to 'string' from 'c_void_ptr' and 'c_ptr'

Standard Modules/Library
------------------------
* added a new 'BigInteger' module providing a value-based 'bigint' type  
  (see https://chapel-lang.org/docs/1.14/modules/standard/BigInteger.html)
* strings:
  - improved the flexibility of arguments passed to join() calls  
    (see https://chapel-lang.org/docs/1.14/builtins/String.html#String.string.join)
  - made a version of split() that handles arbitrary whitespace  
    (see https://chapel-lang.org/docs/1.14/builtins/String.html#String.string.split)
  - made the 'ascii()' routine return uint(8)s rather than int(32)/int(64)s
  - changed the default binary string format to data_toeof
  - removed most library functions on c_strings
* Math module: added support for standard operations on 'complex' values  
  (see https://chapel-lang.org/docs/1.14/modules/standard/Math.html)
* Buffers module: added support for buffer.copyin/copyout methods  
  (see https://chapel-lang.org/docs/1.14/modules/standard/Buffers.html)
* Reflection module:
  - added getFieldRef() functions to obtain a reference to a field  
    (see https://chapel-lang.org/docs/1.14/modules/standard/Reflection.html)
  - added the ability to query whether a type method can be called  
    (see https://chapel-lang.org/docs/1.14/modules/standard/Reflection.html)
* DynamicIters module: added a dynamic iterator for domains  
  (see https://chapel-lang.org/docs/1.14/modules/standard/DynamicIters.html)
* GMP module: deprecated the 'BigInt' class in favor of 'bigint'

Package Modules
---------------
* added initial support for a 'BLAS' module supporting the level 3 routines  
  (see https://chapel-lang.org/docs/1.14/modules/packages/BLAS.html)
* added an MPI module supporting message passing between Chapel images/locales  
  (see https://chapel-lang.org/docs/1.14/modules/packages/MPI.html)
* added a ZeroMQ module supporting inter-application communication via 0MQ  
  (see https://chapel-lang.org/docs/1.14/modules/packages/ZMQ.html)
* added support for a 'MatrixMarket' module providing file serialization  
  (see $CHPL_HOME/modules/packages/MatrixMarket.chpl)
* added a new 'RangeChunk' package for dividing ranges into multiple chunks  
  (see https://chapel-lang.org/docs/1.14/modules/packages/RangeChunk.html)
* Sort module: dramatically revamped the module, including comparator support  
  (see https://chapel-lang.org/docs/1.14/modules/packages/Sort.html)
* Search module: dramatically revamped the module, including comparator support  
  (see https://chapel-lang.org/docs/1.14/modules/packages/Search.html)

Domain Maps (Layouts and Distributions)
---------------------------------------
* added a new 'StencilDist' distribution in support of stencil access patterns  
  (see https://chapel-lang.org/docs/1.14/modules/dists/StencilDist.html)
* added support for Block-distributed sparse domains and arrays  
  (see https://chapel-lang.org/docs/1.14/modules/dists/BlockDist.html)
* extended Block distributions to support strided bounding boxes

Performance Optimizations/Improvements
--------------------------------------
* optimized array accesses for programs that use simple/common array operations
* optimized the performance of promoted expressions over aligned data
* optimized memory management through new jemalloc upgrades and features
* optimized reductions by using an atomic spin lock rather than a sync var
* enabled the bulk transfer of strided array slices by default
* implemented 'sync' variables natively for 'qthreads' tasking
* optimized functions returning references to avoid widening them when possible
* optimized on-statements that end up being local
* optimized the implementation of decrementing remote task counters
* stopped heap-allocating variables due to on-clauses for 'fifo' and 'muxed'
* improved the performance of intrinsic-based floating-point atomic 'fetchAdd's
* fixed a potential performance issue when growing/shrinking arrays as vectors
* made modest improvements to the performance of associative domains
* optimized the implementation of .re and .im for complex values
* optimized base**exp operations when 'base' is a param power of two

Memory Improvements
-------------------
* obtained memory allocation improvements through 'jemalloc' upgrades and usage
* closed memory leaks caused by 'sync'/'single' variables
* closed a memory leak relating to 'args' arguments sent to main()
* closed a memory leak caused by module-scope detuple variable declarations

Example Codes
-------------
* added all remaining Computer Language Benchmark Game programs  
  (see $CHPL_HOME/examples/benchmarks/shootout/* and  
   http://benchmarksgame.alioth.debian.org/)
* significantly improved existing Computer Language Benchmark Game programs  
  (see $CHPL_HOME/examples/benchmarks/shootout/*)
* made improvements to LCALS for style and performance  
  (see $CHPL_HOME/examples/benchmarks/lcals/*)
* changed ISx to use low-level PCG interface to match the reference version  
  (see $CHPL_HOME/examples/benchmarks/isx/*)

Tool Changes
------------
* 'chplvis' improvements:
  - added a "settings" window
  - fixed undetected 'chplvis' regressions in 1.13
  - made significant improvements to the user interface
  - added new views of execution-time data  
  (see https://chapel-lang.org/docs/1.14/tools/chplvis/chplvis.html)
* 'chpldoc' improvements: improved formatting and handling of many situations

Documentation
-------------
* added the primer example codes to the online documentation  
  (see https://chapel-lang.org/docs/1.14/primers/)
* added the 'hello world' examples to the online documentation  
  (see https://chapel-lang.org/docs/1.14/examples/)
* added a new primer example for modules and 'use' statements  
  (see doc/release/examples/primers/modules.chpl)
* added a number of new sections to the user's guide  
  (see https://chapel-lang.org/docs/1.14/users-guide/)
* significantly re-worked the multi-locale execution and quickstart docs  
  (see https://chapel-lang.org/docs/1.14/usingchapel/multilocale.html and  
   https://chapel-lang.org/docs/1.14/usingchapel/QUICKSTART.html)
* moved information about execution on UDP-based systems into its own document  
  (see https://chapel-lang.org/docs/1.14/platforms/udp.html)
* added usage ('use ...') information to chpldoc-generated module documentation  
  (e.g., see https://chapel-lang.org/docs/1.14/modules/standard/Assert.html)
* added documentation for the 'chplvis' file format  
  (see $CHPL_HOME/tools/chplvis/TextDataFormat.txt)
* updated the steps required to build Chapel with newer HDFS sources  
  (see https://chapel-lang.org/docs/1.14/modules/packages/HDFS.html and  
   https://chapel-lang.org/docs/1.14/technotes/auxIO.html#setting-up-hdfs)
* added an archive of past language specification versions to the online docs  
  (see https://chapel-lang.org/docs/1.14/language/archivedSpecs.html)
* updated and fixed minor issues in the language specification
* fixed a plethora of spelling mistakes throughout the documentation
* fixed several online documentation formatting errors

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* added a new --denormalize flag that cleans up generated code before codegen
* stopped throwing --vectorize when --fast is thrown

Portability Improvements
------------------------
* improved the portability of the code base to gcc 6.x
* improved portability to FreeBSD, Solaris, illumos, OmniOS, Ubuntu
* added initial support for compiling single-locale programs for 64-bit ARM

Cray-specific Changes
---------------------
* removed an obsolete warning about having hugepage modules loaded on Crays

Syntax Highlighting
-------------------
* added instructions for using vim highlighting for Vundle and vim-plug users
* fixed portability of Chapel's emacs mode for emacs 24.x
* added support for nested block comments to emacs and 'highlight' highlighting
* fixed the highlighting of binary literals in Pygments
* updated our support for Andre Simon's highlighter to support version 3.x

Error Message Improvements
--------------------------
* added a clarifying statement for 'const' errors due to task/forall intents
* made string OOB messages print the offending index
* squashed C warnings considered to be noise in the back-end compiler
* added an error message for declaring constructors/initializers without parens
* added an error for user fields named 'outer'
* fixed some spelling errors in error messages
* removed warnings for assigning serial iterators/iterables to arrays
* removed a misleading warning about records and forall intents

Runtime Error Checks
--------------------
* added bounds checking to string index/slice operations

Bug Fixes
---------
* fixed a bug in which having CONFIG_SITE set could break third-party builds
* made 'compare_exchange' conform to memory order requirements on failure
* fixed incorrect 'fetchAdd' and 'fetchSub' implementations on atomics
* fixed a bug in which 64-bit atomic loads on 32-bit systems were not atomic
* fixed a longstanding but infrequent race condition in privatization
* fixed a bug in handling 'ref' return intents
* fixed a bug involving 'ref's to array elements
* fixed a bug for recursive functions that return records
* fixed a bug in accessing overridden methods
* fixed a bug in which reduce intents could not be applied to arrays
* fixed a bug in iterating over strided, unsigned domains and arrays
* fixed a bug in BlockCyclic array accesses for 3D+ arrays
* fixed a bug for membership queries in sparse CSR layouts
* fixed a bug when storing max(int) in an associative domain of ints
* fixed a bug in which arrays within records were incorrectly being localized
* fixed a bug in which (+/-1)**k was incorrect for negative values of k
* fixed a bug in advancing I/O channels
* fixed bugs in the mapping of GMP functions down to the underlying C library
* fixed a bug in which readline()'s 'amount' argument was used incorrectly
* fixed a bug in which writeln(str) and writef("%s", str) behaved differently
* fixed a bug related to using an 'enum' within a library module
* fixed a bug ignoring whitespace when casting strings to values
* fixed a bug in which the back-end compiler would warn about dead code
* fixed a bug in which 'printchplenv --sh' was missing some variables
* reduced cases when standard modules were automatically 'use'd in user code
* fixed some issues with copy propagation
* fixed an occasional compile-time failure in inserting wide references
* fixed a bug in which sleep() could under-sleep by 1 microsecond
* fixed some bugs with the --llvm-wide-opt flag
* fixed a race condition in the 'pbs-aprun' launcher
* improved how we handled environment variables with backtics in 'amudprun'
* fixed a bug related to locale models and order of resolution

Launchers
---------
* added an --spmd flag to the 'mpirun' launcher for SPMD Chapel+MPI runs
* added --walltime, --partition, --exclude flags to 'slurm_gasnet_ibv' launcher

Runtime Library Changes
-----------------------
* added the ability to implement atomics using C atomics ('cstdlib')  
  (see https://chapel-lang.org/docs/1.14/technotes/atomics.html and  
   https://chapel-lang.org/docs/1.14/usingchapel/chplenv.html#chpl-atomics)
* re-enabled support for massivethreads for single-locale executions
* added support for out-of-segment non-blocking puts and gets for 'gasnet'
* changed the 'fifo' tasking layer to allocate task stacks in heap memory

Generated Code
--------------
* improved generated code readability when using the new --denormalize flag
* added function IDs and a function ID -> name table to the generated code
* enabled the LLVM back-end compiler to produce debug information
* improved #line directives in the generated code when using --cpp-lines
* improved the generated code quality for 'local' blocks

Third-Party Software Changes
----------------------------
* added 'libunwind' as a new third-party package in support of backtraces
* upgraded jemalloc to version 4.2.1
* upgraded GASNet to version 1.26.4
* upgraded qthreads to version 1.11
* upgraded hwloc to version 1.11.4
* updated massivethreads to a new version
* enabled decay-based purging in jemalloc
* improved 'jemalloc's detection of 'librt' when using cray-prgenv-* compilers
* disabled 'jemalloc's statistics gathering features by default
* added support for the new Qthreads 'distrib' scheduler

Testing System
--------------
* added a 'close' button to the performance graphs to simplify screening them
* improved support for 'notest'ing and 'skipif'ing directories
* added the ability to perform multiple trials in correctness testing
* added the ability to limit the number of concurrently executing tests
* added the ability to squash email notifications by setting CHPL_TEST_NOMAIL
* fixed graph annotations for days without any associated data
* removed the need to provide an argument to '-[no]stdinredirect
* improved how compilation errors are reported for performance testing
* made the test system accept empty .compopts/COMPOPTS files
* avoided the use of spool files when using moab/torque via 'chpl_launchcmd.py'

Removal of Deprecated Features
------------------------------
* removed 'locale.numCores' which was deprecated in 1.13
* removed 'typeToString()', deprecated in 1.13 in favor of casts to strings
* removed support for 'setter', 'reader, 'writer', deprecated in 1.13
* removed support for 'fieldNumToName' & 'fieldValueByNum', deprecated in 1.13
* removed the deprecated 'AdvancedIters' module
* removed support for KNC

Developer-oriented changes: Module changes
------------------------------------------
* significantly refactored sparse domain map modules
* reimplemented 'sync' and 'single' variables as records
* made string code call more directly to mem* routines in C
* made the chpl_here_* routines more generic w.r.t. integral types
* added a 'PODValAccess' config param that returns POD array elements by value
* added a method to the 'bytes' type to get a raw pointer to memory
* adjusted printing within 'DefaultRectangular' to avoid IO dependencies
* cleaned up the use of '_desync' functions
* unified the formatting of the 'ChapelSyncVar' module

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* removed no-longer-used RUNTIME_GEN_C[XX]_FLAGS macros

Developer-oriented changes: Compiler Flags
------------------------------------------
* re-enabled support for the --minimal-modules flag
* added a --[no-]parse-only flag to optionally stop compilation after parsing
* added an experimental --incremental flag that generates multiple .o files
* added an experimental flag for performing CSE on array accesses  
  (see --[no-]replace-array-accesses-with-ref-temps

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* moved the handling of PROC_NEW to the resolution pass
* cleaned up the representation and handling of varargs
* refactored the remote value forwarding pass
* refactored the gatherCandidates stage of function resolution
* fixed a bug in tryStack when resolving constructor calls
* optimized away the creation of tuples for varargs functions in some cases
* refactored CallExpr::codegen()
* revised isSyncType() to be more consistent and meaningful
* moved the "direct on" optimization to the parallel pass
* stopped treating 'defaultInitializer' specially for iterators
* fixed some filename arguments that were still strings rather than 'int's
* stopped unnecessarily remote value forwarding values to task functions
* improved how sync/single operations are identified by remote value forwarding
* changed how the compiler represents parallel iterable expressions
* improved the number and quality of checks performed by the --verify flag
* replaced uses of homegrown containers with STL equivalents in the compiler
* added QualifiedType support to prepare for revamping representation of 'ref's
* fixed the indentation of --html output when viewed within Google Chrome
* added support for a simple 'ForallExpr' AST node, used only during parsing
* implemented certain reduction expressions using forall expressions

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added callbacks to the Chapel runtime's communication calls
* simplified and sped up the implementation of chpl_executeOnNB()
* eliminated type punning and use of volatile in the implementation of atomics
* refactored 'extern "C"' declarations to avoid crossing #include boundaries
* changed uses of 'atomic_flag's to 'atomic_bool's to match C11's atomics

Developer-oriented changes: Documentation
-----------------------------------------
* added developer support for console-/man-based chpldocumentation  
  ('make man-chapel')

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* changed many third-party directory structures to avoid using version numbers



version 1.13.1
==============

Update to sixteenth public release of Chapel, June 2016  
(see also changes below for 1.13.0)

Bug Fixes
---------
* fixed a race condition causing lossy behavior in reductions as of 1.13.0
* fixed bugs in extern block support for C function pointers and structs
* restored support for --cpp-lines when not saving the generated C code
* fixed a bug in the remove() method on arrays
* fixed a bug relating to the index sets used by vector operations on arrays
* fixed an idxType/eltType mix-up in 'shuffle()' in the 'Random' module
* fixed an issue with closing a spawn channel before wait()ing
* fixed a bug in open() when a path the path was stored remotely
* fixed a bug with the printing of real floating point values
* fixed a bug in the GMP BigInt.mod_ui() function
* fixed some bugs in the congruent family of functions in the 'GMP' module

Feature Improvements
--------------------
* add support for casting from c_string to c_void_ptr

Standard Library/Modules
------------------------
* added bounds-checks to vector operations on arrays by default

Memory Improvements
-------------------
* closed memory leaks within the 'RandomStream' class



version 1.13.0
==============

Sixteenth public release of Chapel, April 7, 2016

Highlights
----------
* string improvements:
  - dramatically improved string performance and reduced memory leaks
  - added standard library routines on strings  
    (see https://chapel-lang.org/docs/1.13/modules/internal/String.html)
* language feature highlights:
  - added support for filtering and renaming symbols with the 'use' statement
    (see 'The Use Statement' in the Chapel language specification)
  - added support for min/max reduce intents and reduce intents on coforalls  
    (see https://chapel-lang.org/docs/1.13/technotes/reduceIntents.html)
  - significantly improved memory management and reduced leaks for record types
  - added support for creating subclasses of generic classes
  - replaced 'locale.numCores' with a richer 'locale.numPUs()' interface  
    (see https://chapel-lang.org/docs/1.13/modules/internal/ChapelLocale.html)
  - added the ability to 'use' an enumerated type to avoid qualifying names  
    (see 'The Use Statement' in the Chapel language specification)
  - added support for casting types to strings and deprecated typeToString()  
    (see 'Explicit Type to String Conversions' in the Chapel language spec)
* standard library highlights:
  - added a new 'Reflection' module to support reasoning about code  
    (see https://chapel-lang.org/docs/1.13/modules/standard/Reflection.html)
  - added a new JAMA-based Linear Algebra matrix package  
    (see modules/packages/LinearAlgebraJama.chpl)
  - added a new PCG-based random number generator to 'Random' as the default  
    (see https://chapel-lang.org/docs/1.13/modules/standard/Random.html)
  - extended the 'HDFS' module to support libhdfs3  
    (see https://chapel-lang.org/docs/1.13/technotes/auxIO.html)
  - added additional routines to the 'FileSystem' and 'Path' modules  
    (see https://chapel-lang.org/docs/1.13/modules/standard/FileSystem.html  
     and https://chapel-lang.org/docs/1.13/modules/standard/Path.html)
* implementation improvement highlights:
  - made Chapel's default allocator 'jemalloc', resulting in better performance  
    (see https://chapel-lang.org/docs/1.13/usingchapel/chplenv.html#chpl-mem)
  - 'complex' types are now code generated as C99 complex rather than a record
  - added compiler flags for all of the traditional CHPL_* environment vars.  
    (see 'Compiler Configuration Options' in 'chpl --help' or the man page)
* added initial support for Intel Xeon Phi Knights Landing (KNL) processors  
  (see https://chapel-lang.org/docs/1.13/platforms/knl.html)
* added new Chapel ports of the ISx and LCALS proxy applications to the release  
  (see examples/benchmarks/isx and examples/benchmarks/lcals/)
* documentation highlights:
  - dramatically improved the organization of the online Chapel documentation  
    (see https://chapel-lang.org/docs/1.13/)
  - created web-based versions of the 'chpl' and 'chpldoc' man pages  
    (see https://chapel-lang.org/docs/1.13/usingchapel/man.html  
     and https://chapel-lang.org/docs/1.13/tools/chpldoc/man.html)
* performance improvement highlights:
  - made significant performance improvements for common use cases of 'reduce'
  - implemented amortized reallocation when resizing arrays due to vector ops
  - made significant performance improvements for 'ugni' communication on Crays
  - broadened the applicability of the bulk communication optimization
  - significantly improved the performance resulting from the LLVM back-end
* additional highlights:
  - renamed the 'etc/' directory 'highlight/' to better identify its contents  
    (see highlight/README)
  - made Chapel's scripts compatible with key versions of Python 2 and 3
  - unified the support of third-party packages and runtime options on Crays  
    (see  https://chapel-lang.org/docs/1.13/platforms/cray.html)
  - numerous error message improvements, bug fixes, feature improvements, ...

Configuration Changes
---------------------
* made 'jemalloc' the default allocator for most configurations  
  (see https://chapel-lang.org/docs/1.13/usingchapel/chplenv.html#chpl-mem)
* made 'cray-prgenv-cray' default to using 'qthreads'+'hwloc' and 'ugni'  
  (see  https://chapel-lang.org/docs/1.13/platforms/cray.html)
* added support for 're2' when using Cray and PGI compilers
* changed 'knc' to default to using 'qthreads'+'hwloc'
* deprecated 'knc' support  
  (see  https://chapel-lang.org/docs/1.13/platforms/knc.html)
* switched to using pgc++ rather than pgCC as the C++ compiler for 'pgi'
* removed stale support for Xcode

Syntactic/Naming Changes
------------------------
* added new keywords, 'as', 'except', and 'only', for filtering 'use'd symbols  
  (see 'The Use Statement' in the Chapel language specification)
* replaced 'locale.numCores' with a richer interface 'locale.numPUs()'  
  (see https://chapel-lang.org/docs/1.13/modules/internal/ChapelLocale.html)
* removed the 'Writer' and 'Reader' types in favor of unifying on 'channel's

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* added support for a 'const ref' return intent  
  (see "The Const Ref Return Intent" in "Procedures" in the Chapel spec)
* improved the handling of "return by ref" functions in setter/getter contexts  
  (see 'https://chapel-lang.org/docs/1.13/language/evolution.html  
   and 'The Ref Return Intent' under 'Procedures' in the language spec)
* made default I/O routines ignore 'param' fields as they have 'type' fields
* restricted 'sync'/'single' types to sufficiently simple types
* removed support for performing Chapel I/O on 'c_string's
* removed coercions from 'c_string's to 'string's

New Features
------------
* added a standard library of routines on the 'string' type  
  (see https://chapel-lang.org/docs/1.13/modules/internal/String.html)
* added support for filtering on 'use' statements with 'only' and 'except'  
  (e.g., 'use M only foo;' or '... except foo;' to restrict to / exclude 'foo')  
  (see 'The Use Statement' in the Chapel language specification)
* added support for renaming symbols made accessible by a 'use'  
  (e.g., 'use M only foo as M_foo;' causes 'foo' to be referred to as 'M_foo')  
  (see 'The Use Statement' in the Chapel language specification)
* added the ability to 'use' an enumerated type  
  (e.g., "...mycolor.green..." can now be written "use mycolor;  ...green...")
* added support for casting types to strings and deprecated typeToString()  
  (e.g., 'writeln(x.type:string);' can be used to print the name of x's type)
* added a capability to iterate over the fields in a class or record  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Reflection.html)
* added the ability to query whether a call can be resolved or not  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Reflection.html)
* added support for annotating an on-clause as being 'local'  
  (see https://chapel-lang.org/docs/1.13/technotes/local.html)
* added support for 'c_string' values  
  (e.g., "this is a Chapel string" while c"this is a C string")

Feature Improvements
--------------------
* added support for creating subclasses of a generic class
* added support for min/max reduce intents  
  (see https://chapel-lang.org/docs/1.13/technotes/reduceIntents.html)
* added support for reduce intents on coforall loops  
  (see https://chapel-lang.org/docs/1.13/technotes/reduceIntents.html)
* added the ability to pass sync/single variables via generic arguments
* improved the type signatures of min()/max() to support better type resolution  
  (see https://chapel-lang.org/docs/1.13/modules/internal/UtilMisc_forDocs.html)
* extended comparison operators (==, !=, <=, etc.) to support mixed int/uints  
  (see 'Expressions' in the Chapel language specification)
* added support for range slicing between mixed int/uint idxTypes
* added support for comparing between 'c_void_ptr' expressions and 'nil'
* added support for implicitly coercing 'c_ptr' types to 'c_void_ptr'
* added support for casting from fully-qualified enum strings to enum values  
  (e.g., '"mycolor.green":mycolor' now works where it wouldn't have previously)
* extended channel.readbits/writebits to accept other integral types  
  (see https://chapel-lang.org/docs/1.13/modules/standard/IO.html)
* added scalar versions of domain.exterior(), interior(), and translate()  
  (see https://chapel-lang.org/docs/1.13/modules/internal/ChapelArray.html)

Standard Library/Modules
------------------------
* started distinguishing between "standard Chapel modules" and "packages"  
  (see https://chapel-lang.org/docs/1.13/modules/modules.html  
   and https://chapel-lang.org/docs/1.13/modules/packages.html)
* added a new JAMA-based linear algebra matrix package  
  (see modules/packages/LinearAlgebraJama.chpl)
* added a new PCG-based random number generator to 'Random' as the default  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Random/PCGRandom.html)
* added a new 'Reflection' module supporting reflection about a program  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Reflection.html)
* extended the 'HDFS' module to support libhdfs3  
  (see https://chapel-lang.org/docs/1.13/technotes/auxIO.html)
* added support for skipping unknown fields when reading JSON records/classes  
  (see https://chapel-lang.org/docs/1.13/modules/standard/IO.html)
* made the default I/O routines for records/classes support arbitrary orders
* added 'basename', 'dirname', and 'splitPath' to the 'Path' module  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Path.html)
* added rmTree(), moveDir() to the 'FileSystem' module  
  (see https://chapel-lang.org/docs/1.13/modules/standard/FileSystem.html)
* added an optional time units argument to 'sleep()' in the Time module  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Time.html#Time.sleep)
* added support for sending signals to subprocesses for the 'Spawn' module  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Spawn.html)
* added an optional 'buffer' boolean to the 'Spawn' module's wait() routine  
  (see https://chapel-lang.org/docs/1.13/modules/standard/Spawn.html)
* added an isclosed() method to the 'channel' type  
  (see https://chapel-lang.org/docs/1.13/modules/standard/IO.html)
* improved the 'List' module to support JSON format
* improved error handling in the IO and Spawn modules
* added the ability to call exit() without arguments for a 0 default status
* renamed 'AdvancedIters' to 'DynamicIters' to better reflect its role
* removed deprecated functions from 'Memory' module

Performance Improvements
------------------------
* obtained notable performance improvements from the switch to 'jemalloc'
* made significant performance improvements to common uses of 'reduce'
* implemented amortized reallocation when resizing arrays due to vector ops
* made significant performance improvements for 'ugni' communication on Crays
* made bulk data transfers more likely to fire by removing a conservative check
* enabled bulk data transfers between portions of the same array
* generally improved the performance of string-based computations
* optimized iteration over anonymous range values of the form 'lo..#size'
* improved the performance of code generated by the LLVM back-end

Memory Improvements
-------------------
* dramatically reduced the compiler-generated leaks due to strings and records
* significantly improved construction/destruction/copy behavior for records
* stopped heap-allocating variables referred to within 'begin' scopes
* stopped heap-allocating variables referred to within non-blocking on-clauses
* stopped heap-allocating index variables of coforall loops

Documentation
-------------
* dramatically improved the organization of the online Chapel documentation  
  (see https://chapel-lang.org/docs/1.13/)
* created web-based versions of the 'chpl' and 'chpldoc' man pages  
  (see https://chapel-lang.org/docs/1.13/usingchapel/man.html  
   and https://chapel-lang.org/docs/1.13/tools/chpldoc/man.html)
* linked to the language specification and quick reference from the online docs  
  (see https://chapel-lang.org/docs/1.13/language/spec.html  
   and https://chapel-lang.org/docs/1.13/language/reference.html)
* converted a number of top-level README-style files to markdown format  
  (e.g., see $CHPL_HOME/CHANGES.md, CONTRIBUTORS.md, PERFORMANCE.md, ...)
* moved the Chapel evolution page from chapel-lang.org to the online docs  
  (see https://chapel-lang.org/docs/1.13/language/evolution.html)
* split the top-level README.rst file into README.rst and QUICKSTART.rst
* started writing a Chapel Users Guide, though much work remains  
  (see https://chapel-lang.org/docs/1.13/users-guide/)
* improved the accuracy of Chapel's prerequisites list  
  (see https://chapel-lang.org/docs/1.13/usingchapel/prereqs.html)
* improved wordings and descriptions in the language specification
* fixed many instances of broken links / formatting in online documentation

Example Codes
-------------
* added new Chapel ports of the ISx and LCALS proxy applications to the release  
  (see examples/benchmarks/isx/ and examples/benchmarks/lcals/)
* made correctness, performance, and style improvements to MiniMD in Chapel  
  (see examples/benchmarks/miniMD/)
* extended the linkedList example program to support additional methods  
  (see examples/programs/linkedList.chpl)
* fixed some typos and explanations in the primer examples  
  (see examples/primers/*.chpl)
* updated example tests to reflect the changes to the language and libraries
* removed README.features from the examples subdirectory

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* added compiler flags for all of the traditional CHPL_* environment variables  
  (see 'Compiler Configuration Options' in 'chpl's '--help' output or man page)
* made the --ldflags stack when used multiple times, similar to --ccflags
* made the --no-warnings flag reversible by changing it to --[no-]warnings

Execution Flags
---------------
* added support for specifying enum configs using fully-qualified names  
  (e.g., '--myColor=color.red' is now supported where only '--myColor=red' was)

Environment Changes
-------------------
* the setchplenv[.bash|.fish|.sh] scripts can now be sourced from any directory
* removed the CHPL_THREADS environment variable

Directory Structure Changes
---------------------------
* renamed the 'etc/' directory to 'highlight/' to better identify its contents
* split 'modules/standard' into 'modules/standard' and 'modules/packages'

Cray-specific Changes
---------------------
* streamlined 'ugni' resource management, dramatically improving performance
* hugepages are now optional with the 'ugni' communication layer  
  (see https://chapel-lang.org/docs/1.13/platforms/cray.html)
* improved the Spawn module to support 'ugni' when hugepages are not in use
* started statically linking 'chpl' in the Cray module to ensure portability

Portability Improvements
------------------------
* added initial support for Intel Xeon Phi Knights Landing (KNL) processors  
  (see https://chapel-lang.org/docs/1.13/platforms/knl.html)
* made Chapel's scripts compatible with key versions of Python 2 and 3
* improved the portability of the code base to gcc 5.1
* improved the portability of the code base to newer versions of Cygwin

Tool Changes
------------
* 'chpldoc' improvements:
  - made modules automatically list any submodules that they contain
  - it now generates a doc page per module rather than .chpl source file
  - it now only documents files listed on its command line by default
  - added a --[no-]html option to opt in/out of the rst->html phase
* added basic support for folding for 'vim' users
* added an option to disable chplvis tracing for a given run in 'VisualDebug'
* improved 'chpltags' support for older versions of 'ctags'

Error Message Improvements
--------------------------
* improved 'const' checking for domains and arrays
* added an error message for variable declarations over incomplete generics
* stopped warning about reductions being serialized -- that's completely legal
* added an error message for non-extern functions with no-op bodies
* reduced the degree to which internal module line numbers are named in errors
* implemented an error message for strings containing bad escape sequences
* improved the error message for bad CHPL_RT_NUM_THREADS_PER_LOCALE values
* improved error messages for illegal/incorrect 'use' statements
* added an error message for references to fields within 'with' clauses
* added an error message for 'real*2' suggesting the user wants '2*real'

Bug Fixes
---------
* fixed a bug in applying reduce intents to forall loops over ranges
* fixed a bug in zippered iteration over equivalent associative domains/arrays
* fixed the ability to declare a 'ref' to a domain or array
* fixed a bug in which overridden/overloaded methods were not resolved properly
* fixed a bug in assigning between distributed domains and non- with arrays
* fixed a bug in the computation of 'maxTaskPar' for the numa locale model
* fixed a bug in which generic types were not printed properly
* fixed a bug in which assignment between generic records did not work properly
* fixed a bug in which extern type declarations in generic procedures broke
* fixed a bug with isHomogeneousTuple*() queries when passed non-tuples
* fixed a bug with self-references in module use lists
* fixed a bug when calling exit() without arguments
* fixed the runtime sizes of boolean literals of varying bit widths
* fixed a bug w.r.t. reduce intents interacting poorly with on-clauses
* fixed a bug in which returning tuples of arrays did not work
* fixed a bug in the initialization of nearly-maximally-sized arrays
* fixed a bug in the Block and Cyclic parallel iterators for arrays of arrays
* fixed a bug in which subtype checking now handles transitive instantiation
* fixed bugs in default I/O routines for subclasses
* fixed a few bugs in the Spawn module's communicate() routine
* made some improvements to the Spawn module relative to QIO
* made some I/O functions more tolerant of EINTR
* fixed some bugs in which I/O routines executed on the wrong locale
* fixed a bug in formatted reads of digits
* fixed a bug preventing channel.itemWriter() from working
* improved the handling of C escapes in string literals
* fixed the handling of escape characters in compilerWarning()/compilerError()
* fixed a bug related to nested modules sharing a name, each defining main()
* fixed a bug in which Qthreads tasks weren't allocating sufficient storage
* fixed the line numbers reported for standalone iterators
* fixed a bug in which record fields were not properly widened
* fixed a bug in which records could be double-freed for out/inout arg passing
* fixed a bug in 'chpldoc' in the handling of multiline mid-variable comments
* fixed a bug in which failure to open files for codegen caused internal errors
* made the compiler resilient to usernames containing backslashes
* fixed a bug in the checking of definitions made in SysCTypes
* fixed the chpl-venv path to be based on the host platform rather than target
* fixed line numbers related to domain query expressions in formal arguments
* fixed a bug in which sleep() could result in tasks awakening prematurely

Cray-specific Bug Fixes
-----------------------
* 'ugni' now supports communication to/from any unregistered address
* resolved a rare program hang in 'ugni' communication
* fix 'ugni' memory mis-registration under CLE 6.*
* plug a memory leak in 'ugni' for certain remote on-statements

Third-Party Software Changes
----------------------------
* turned on optimizations when compiling 're2' for optimized builds
* enabled 're2' when using Cray and PGI compilers
* added jemalloc version 4.0.4 and retired tcmalloc and dlmalloc
* upgraded GASNet to version 1.26.0
* upgraded hwloc to version 1.11.2
  - and cherry-picked a /proc/mounts buffer overflow fix from hwloc master
* upgraded LLVM to version 3.7
* switched several third-party directories to a more Git-friendly organization

Runtime Library Changes
-----------------------
* updated the names of several runtime communication interface routines

Generated Code Cleanups
-----------------------
* started code-generating 'complex' types as C99 complexes rather than a record
* filenames are now represented a table + indices rather than string literals

Testing System
--------------
* added support for many files, such as compopts, to be executable scripts
* added .compenv files as a means of changing the compiler environment
* made 'make check' clean up after itself better
* made the test system no longer mail out the list of unresolved future tests
* parallel testing now ignores symbolic links to avoid infinite loops
* made the test system deal better with unexpected failures
* improved start_test's error message if CHPL_HOME is not set

Makefile Changes
----------------
* added an "always build chpldoc" capability via CHPL_ALWAYS_BUILD_CHPLDOC
* only generate 'tags' commands when CHPL_DEVELOPER or TAGS is set at make-time
* improved the logic for updating/re-building the 'chpl' version number

Developer-oriented changes: Process Improvements
------------------------------------------------
* changed the generation of the man page from txt2man into an rst-based scheme
* added a 'make check' option for Sphinx documentation to check for errors

Developer-oriented changes: Packaging Changes
---------------------------------------------
* reorganized files to better support packaging of Chapel
* began differentiating runtime launcher paths based on CHPL_COMM
* no longer specialize runtime library directories on CHPL_NETWORK_ATOMICS

Developer-oriented changes: Module improvements
-----------------------------------------------
* made use of 'local' on-clauses within internal modules targeting 'numa'
* changed a "c for loop" in DefaultRectangular into a direct range iterator
* refactored generation of unbounded range values
* changed some uses of c_calloc() to c_malloc()
* improved the extern declarations of the locale model chpl_mem* routines
* retired the ChapelLocale_forDocs.chpl workaround for documentation

Developer-oriented changes: Compiler Flags
------------------------------------------
* added --break-on-codegen-id to stop when a specific ID is code generated

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* introduced a new 'UseStmt' AST node for representing 'use' statements
* made all non-'flat' locale models outline on-clauses and use wide pointers
* removed the pragma form of 'export'
* added support for operator overloads on the bitVec type
* reworked how argument bundles are managed for begin- and on-functions
* changed wide_get_address mechanisms to return a 64-bit uint
* refactored duplicate code in buildForLoopExpr
* made addArgCoercion() sensitive to errors
* improve the compiler's handling of PRIM_ASSIGN
* improved the compiler's handling of POD types
* improved the compiler's handling of declared return types
* made the compiler remove casts from 'ref T' to 'T'
* unified the handling of 'by' and 'align' in the parser
* improved the handling of string varargs with default intent
* improved the normalization of initialization expressions
* added support for tracking the causes of wide pointers
* refactored the implementation of some reductions to use reduce intents
* removed the FLAG_FUNCTION_PROTOTYPE flag as not being interesting or useful

Developer-oriented changes: Generated code improvements
-------------------------------------------------------
* improved the representation of unions in the generated code

Developer-oriented changes: Runtime improvements
------------------------------------------------
* moved the Qthreads tasking shim into the Chapel runtime/ directory
* changed the communication interface to take sizes rather than elemsize+length
* fixed problems with GETs to unregistered remote memory
* simplified the interfaces for creating structured parallelism within Chapel
* removed deprecated code supporting Tilera processors
* extensively reworked debug support in 'ugni'

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* disabled OpenCL support in hwloc for the time being
* disabled libnuma in hwloc builds

Developer-oriented changes: Testing system improvements
-------------------------------------------------------
* added a script to help maintain .dat files when perfkeys change  
  (see util/devel/updateDatFiles.py)
* renamed 'grepgoods' to 'greptestoutputs' and had it span .good and .bad files



version 1.12.0
==============

Fifteenth public release of Chapel, October 1, 2015

Highlights
----------
* significantly expanded the coverage of our online documentation  
  (see https://chapel-lang.org/docs/1.12/ and "Documentation" below)
* added new 'Barrier', 'Spawn', and 'LAPACK' modules to the standard set  
  (see "Standard Library/Modules" section below)
* added chplvis: a new tool for visualizing Chapel communication and concurrency  
  (see https://chapel-lang.org/docs/1.12/tools/chplvis/)
* added a new chapter describing Chapel's memory consistency model in detail  
  (see 'Memory Consistency Model' in the language spec)
* added a 'vectorizeOnly()' iterator that vectorizes without task creation  
  (see https://chapel-lang.org/docs/1.12/modules/internal/ChapelIteratorSupport.html)
* new performance optimizations, particularly intra- and inter-node locality  
  (see "Performance Improvements" section below)
* removed the 'local' block from stream-ep based on the above optimizations  
  (see examples/benchmarks/hpcc/stream-ep.chpl)
* changed the default tasking layer on 'cray-x*' to 'qthreads' for performance
* added support for type methods and iterators  
  (see 'Classes::Class Method Calls::The Method Receiver and the this Argument')
* added support for public/private module-level variables, functions, modules)  
  (see 'Modules:Access of Module Contents::Visibility of Module's Symbols')
* domains in formal array arguments are now interpreted as a constraint  
  (see 'Arrays::Array Arguments to Functions' in the language spec)
* significantly revamped and improved correctness and performance testing system
* improved how internal error messages are displayed to users
* added Chapel Improvement Proposals (CHIPs) framework for proposing changes  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/chips/1.rst)
* made more bug fixes than any release since version 1.1  
  (see "Bug Fixes" section below)
* addressed portability issues for a number of platforms and compilers

Process Improvements
--------------------
* added Chapel Improvement Proposals (CHIPs) framework for proposed changes  
  (see https://github.com/chapel-lang/chapel/blob/main/doc/chips/1.rst)

Environment/Configuration Changes
---------------------------------
* 'printchplenv' now indicates which settings come from environment variables
* made the quickstart scripts turn CHPL_LLVM off by default
* removed dependencies on 'bc' and 'patch'

Tool Changes
------------
* added chplvis: a new tool for visualizing Chapel communication and concurrency  
  (see https://chapel-lang.org/docs/1.12/tools/chplvis/)
* chpldoc improvements:
  - improved handling of enum, real, imag, and complex initializers
  - 'chpldoc' now generates values for enum symbols
  - automatically skip documentation of 'private' symbols
  - squashed generation of 'inline' in output
  - added support for --print-commands with chpldoc
* chpl-ipe:
  - added a quit() primitive for clean exits from the environment

Syntactic/Naming Changes
------------------------
* changed 'use' to 'require' for header files and external libraries  
  (see https://chapel-lang.org/docs/1.12/technotes/extern.html)
* replaced the standalone format() routine, with string.format()  
  (see https://chapel-lang.org/docs/1.12/modules/standard/IO.html#IO.string.format)
* renamed memory diagnostics capabilities for clarity  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Memory.html)
* changed the '##.##' writef() pattern so that it requires '%{...}' around it  
  (see https://chapel-lang.org/docs/1.12/modules/standard/IO.html#specifiers)
* added support for form-feed characters ('\f') as whitespace  
  (see 'Lexical Structure::White Space' in the language specification)
* changed the term 'blank intent' to 'default intent'  
  (see 'Functions::Argument Intents::Abstract Intents::The Default Intent')

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* domains in formal array arguments are now interpreted as a constraint  
  (see 'Arrays::Array Arguments to Functions' in the language spec)
* Chapel no longer keeps referenced variables alive past their lexical scope
* c_strings are no longer made into strings when passed to generic extern args
* 'select' statements now only evaluate their argument expression once

New Features
------------
* added a 'vectorizeOnly()' iterator that vectorizes without using multitasking  
  (see https://chapel-lang.org/docs/1.12/modules/internal/ChapelIteratorSupport.html)
* added support for type methods and iterators  
  (see 'Classes::Class Method Calls::The Method Receiver and the this Argument')
* added support for public/private module-level variables, functions, modules)  
  (see 'Modules:Access of Module Contents::Visibility of Module's Symbols')
* added support for methods on enumerated types  
  (e.g., 'enum color {red};' permits 'proc color.foo() { ... } color.red.foo();')
* added support for hexadecimal floating point literals  
  (see 'Lexical Structure::Tokens::Literals' in the language specification)
* added the ability to rename extern records for use within Chapel  
  (see 'Interoperation::...::Shared Types::Referring to External C Structs')
* added support for -lchplmalloc for compilers supporting weak symbols  
  (see https://chapel-lang.org/docs/1.12/technotes/allocators.html)
* added the ability to use 'continue' statements in 'param' for-loops
* added support for == and != operators on domain maps

Standard Library/Modules
------------------------
* added a new 'Barrier' module defining a simple collective barrier capability  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Barrier.html)
* added a new 'Spawn' module for creating new subprocesses  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Spawn.html)
* added a new 'LAPACK' module that provides an interface to LAPACK  
  (see https://chapel-lang.org/docs/1.12/modules/standard/LAPACK.html)
* added support for common mathematical constants to 'Math.chpl'  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Math.html#Math.e)
* replaced standalone format() routine with string.format() in 'IO'  
  (see https://chapel-lang.org/docs/1.12/modules/standard/IO.html#IO.string.format)
* unified string.format() format strings with writef()  
  (see https://chapel-lang.org/docs/1.12/modules/standard/IO.html#formatted-i-o)
* added a getFileSize() routine to the 'FileSystem' module  
  (see https://chapel-lang.org/docs/1.12/modules/standard/FileSystem.html)
* merged the contents of the 'UtilMath' module into 'Math'  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Math.html)
* improved the 'Memory' module:
  - renamed memory diagnostics capabilities for clarity
  - added a --memLeaksByDesc flag to track only certain types of leaks
  - stopped tracking memory allocations not related to Chapel code by default  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Memory.html)
* errorToString(ENOERR) now portably returns "No error" in 'Error' module  
  (see https://chapel-lang.org/docs/1.12/modules/standard/Error.html)
* applied the 'private' keyword to standard modules as appropriate/possible

Performance Improvements
------------------------
* parallelized large numeric array initialization for better first-touch
* improved analysis and optimization of variables that are provably local
* fixed a bug in which non-blocking 'on's were counted as local running tasks
* improved task counting when one task is waiting for others to complete
* optimized task counts to use processor atomics when profitable
* made 'cray-x*' systems default to 'qthreads' over 'muxed'
* moved polling threads to the last available CPU to avoid contention
* made array allocation use calloc(), not malloc() for better first-touch
* enabled more optimizations and streamlined code when using the LLVM back-end

Memory Improvements
-------------------
* stopped leaking sync and single variables on all platforms except Cygwin
* eliminated leaks for heap allocated variables used in cobegin/coforall

Documentation
-------------
* mirrored many of the READMEs from the release onto our online documentation  
  (see https://chapel-lang.org/docs/1.12/usingchapel/ and .../1.12/technotes)
* added online documentation for built-in types, functions, methods  
  (see https://chapel-lang.org/docs/1.12/modules/builtins.html)
* added online documentation for standard domain maps (layouts and distributions)  
  (see https://chapel-lang.org/docs/1.12/modules/distributions.html and layouts.html)
* added a copy of the online html documentation to the release itself  
  (see $CHPL_HOME/doc/html)
* converted most READMEs to ReStructured Text (.rst) or markdown (.md)  
  (for example, see $CHPL_HOME/doc/* and $CHPL_HOME/doc/technotes/*)
* refreshed the contents of most former READMEs as part of this effort
* language specification updates:
  - added a new chapter on Chapel's memory consistency model
  - added documentation of the I/O operator, <~>
  - improved the specification's page numbering and format
  - retired standard library chapters from the spec now that they're online  
  (see https://chapel-lang.org/spec/spec-0.98.pdf)
* standard module documentation improvements
  - added a "Formatted I/O for C Programmers" table to the IO module  
    (see https://chapel-lang.org/docs/1.12/modules/standard/IO.html#formatted-i-o)
  - refreshed the documentation of other standard modules
* refreshed the contents of the C interoperability technical note  
  (see https://chapel-lang.org/docs/1.12/technotes/extern.html)
* retired README.format due to its documentation as part of a standard module  
  (see https://chapel-lang.org/docs/1.12/modules/standard/IO.html#IO.string.format)
* removed Tilera-specific documentation due to lack of use and testing

Example Codes
-------------
* rewrote the 'stream-ep' example to remove the now unnecessary 'local' block  
  (see examples/benchmarks/hpcc/stream-ep.chpl)
* added a copy of Chapel code from learnXInYMinutes site to examples/primers  
  (see examples/primers/learnChapelInYMinutes.chpl)
* added a primer for the new 'chplvis' tool  
  (see examples/primers/chplvis/README)
* added a primer for the new LAPACK module  
  (see examples/primers/LAPACKlib.chpl)
* added a new examples/patterns directory for storing common code patterns  
  (see examples/patterns/README)
* added patterns/recordio.chpl to demonstrate reading tab-delimited records  
  (see examples/patterns/recordio.chpl)
* updated shootout/nbody.chpl to use 'ref's rather than nested procedures  
  (see examples/benchmarks/shootout/nbody.chpl)
* replaced uses of format() with writef() in SSCA2 benchmark  
  (see examples/benchmarks/ssca2/)
* made the fileIO primer more tolerant of floating point roundoff  
  (see examples/primers/fileIO.chpl)
* made the FFTW primer self-validating w.r.t. numerical differences  
  (see examples/primers/FFTWlib.chpl)
* removed 'param' from lulesh loops that probably don't want/need it  
  (see examples/benchmarks/lulesh/)

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* redefined --fast to no longer imply --no-ieee-float
* added --[no-]ieee-float support for CHPL_TARGET_COMPILER 'clang' and 'intel'
* made --ccflags arguments stack rather than override one another
* added support for --print-emitted-code-size for the LLVM back-end

Execution Flags
---------------
* added a --memLeaksByDesc flag to track only certain memory categories
* made --memLeaks[ByDesc] be governed by the --memThreshold flag

Error Message Improvements
--------------------------
* improved how internal error messages are displayed to users
* improved error messages for runaway comments
* improved source location provided by 'noinit' warnings

Bug Fixes
---------
* forall loops over a single array now correctly use the standalone iterator
* fixed bugs with applying reduce intents to forall loops over domains/arrays
* fixed bugs with scope resolution's choice of which symbol to resolve to
* fixed a bug in which overloads of '|' broke internal modules
* fixed a bug related to extern variables of types like c_ptr(c_int)
* fixed an internal error when a class calls its parent class's destructor
* fixed a bug in which large array copies could overflow runtime arguments
* fixed a bug in which calls of the form '<type>(x)' would cause internal errors
* fixed a bug in I/O when skipping whitespace encountered illegal characters
* fixed printing/reading of integers with '%{##.##}' format
* made readf() calls without error arguments halt on mismatches
* fixed a bug in which trailing whitespace was being consumed too aggressively
* made default rectangular arrays print in JSON as arrays-of-arrays
* fixed EOF-related bugs in Reader/Writer
* fixed a bug in which channel.read(style) was ignoring its style argument
* fixed a bug in which non-blocking 'on's were counted as local running tasks
* fixed a compiler exception caused by dividing by param '0'
* fixed a bug in the is*() FileSystem functions when given an invalid path/link
* improved chpldoc's handling of failure to create output and tmp directories
* added an error message for too-long compiler flags rather than truncating
* fixed a bug in which calls to malloc/free/etc in extern blocks caused errors
* fixed 'text file busy' errors in certain situations when invoking 'chpl'
* fixed a bug in which overloading was being permitted based on argument intents
* fixed a segfault in the glob() iterator when following 0..0 with 0 matches
* fixed a bug in which bad source location info was passed to string routines
* preserved source location information for cobegins
* fixed a bug relating to inlined iterators and generic array fields
* fixed a bug relating to passing c_strings to extern C functions

Platform-specific Changes
-------------------------
* made 'cray-x*' systems default to 'qthreads' over 'muxed'
* 'muxed' tasking now supports stack guard pages for non-hugepage heaps  
  (see https://chapel-lang.org/docs/1.12/platforms/cray.html)
* added support for 'clang-included' to work with GASNet on Cray systems
* removed support for cray-prgenv-pgi from the module build on 'cray-x*'
* for cray-prgenv-cray compilations, stopped throwing -hipa2 by default

Platform-specific bug fixes
---------------------------
* fixed a stack underflow problem with 'muxed' tasking causing segfaults
* fixed a race in stack management for 'muxed' tasking

Portability Improvements
------------------------
* eliminated warnings related to [_BSD|_SVID]_SOURCE being deprecated
* improved portability of building the SysCTypes.chpl for Fedora 22
* removed symmetric address assumptions from error-handling code in the runtime
* fixed a number of I/O portability errors on cygwin
* fixed tcmalloc when compiled with clang 3.6 and used from C++
* fixed I/O for 32-bit Ubuntu 14.04
* added support for building GASNet with segment=fast on OS X
* fixed hwloc's cairo detection for certain OS X installations
* eliminated some Xcode-specific warnings

Third-Party Software Changes
----------------------------
* added 'fltk' to the third-party directory for use by 'chplvis'
* enabled the use of GMP with the LLVM back-end
* made LLVM build in non-debug mode and without asserts by default
* improved cross-compilation of third-party packages for 'cray-x*' platforms
* we're now storing RE2 in an unpacked form due to all of our local changes
* fixed a valgrind issue in RE2

Launcher-specific Changes
-------------------------
* improved 'slurm' launcher's handling of non-zero exit() codes
* changed how the 'amudprun' launcher deals with quoted arguments

Runtime Library Changes
-----------------------
* added support for out-of-segment put()/get() calls
* changed I/O to allocate buffer space out of the Chapel heap

Testing System
--------------
* rewrote 'start_test' and 'computePerfStats' in python
* replaced --suppress feature with .suppressif files
* added ability to write chpldoc tests using the .doc.chpl extension
* updated testing system to support testing of 'chpl-ipe'
* made the parallel testing system print an estimated end time
* added support for a -valgrindexe flag to 'paratest.server'
* made 'start_test' work when it's located outside of $CHPL_HOME/util
* added the ability to have multi-line COMPOPTS file
* improved support for #defines with quotes for C testing
* made C testing system more accepting of C compilers that print filenames
* specialized testing system to recognize some common launcher errors
* improved ability to use chpl_launchcmd.py from NFS-mounted Lustre filesystems
* extended timeout mechanism to work under Cygwin

Makefile Changes
----------------
* rewrote 'make check' to remove reliance on start_test/tcsh/python

Performance Testing/Graphing System
-----------------------------------
* added a 'screenshot' capability for performance graphs
* added the ability to annotate cray-xc performance graphs
* retired the old gnuplot-based graphing system
* reduced graphing system's reliance on CHPL_HOME being set
* improved graphing system's stability when there is no ANNOTATIONS.yaml file

Developer-oriented changes: Process Improvements
------------------------------------------------
* began using Jira for issue tracking

Developer-oriented changes: Documentation Improvements
------------------------------------------------------
* added notes about testing nightly scripts to util/cron/README

Developer-oriented changes: Compiler Flags
------------------------------------------
* added a --break-on-resolve-id flag for stopping when calling a function

Developer-oriented changes: Module improvements
-----------------------------------------------
* cleaned up how filename/line# information is attached to network atomics
* added support for casting directly to c_strings
* started using specific I/O read/write functions for int/real/imag types
* cleaned up handling of bool values in IO.chpl
* made initOnLocales() a standalone parallel iterator and added 'chpl_' prefix

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* added a top-level Makefile rule for building the parser

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* rewrote the compiler passes that widen references as necessary
* rewrote major portions of the scope resolution pass
* reduced reliance on homegrown ADTs with their STL equivalents
* improved the sharing of flags between 'chpl' and 'chpldoc'
* turned off sugaring of type names in --devel mode
* internal improvements to how tuples are handled
* removed unused flag FLAG_NO_USE_CHAPELSTANDARD
* renamed FLAG_PRIVATE to FLAG_LOCALE_PRIVATE for clarity
* retired the "auto destroy fn" pragma
* added tracking of zippered loops throughout compilation
* ensured the lexer returns a heap-allocated const char* for each literal

Developer-oriented changes: Runtime improvements
------------------------------------------------
* added support for task callbacks in the runtime
* eliminated reliance on `__always_inline`
* added chpl_mem_goodAllocSize() to runtime to support minimizing wasted memory
* added the ability to flag certain memory types to avoid tracking them
* added a capability to generate a header file #defining CHPL_* variables
* turned off remote caching for tasking layers where migration can occur

Developer-oriented changes: Third-party improvements
----------------------------------------------------
* cleaned up local modifications to Qthreads for contribution back to master
* updated third-party GMP/RE2 READMEs to refer to online module documentation



version 1.11.0
==============

Fourteenth public release of Chapel, April 2, 2015

Highlights
----------
* revamped 'chpldoc' and used it to create web docs for all standard modules  
  (see https://chapel-lang.org/docs/)
* added a new FileSystem standard module supporting operations on files/dirs  
  (see https://chapel-lang.org/docs/1.11/modules/standard/FileSystem.html)
* added a new FFTW standard module supporting key FFTW routines  
  (see https://chapel-lang.org/docs/1.11/modules/standard/FFTW.html)
* added task intents to forall loops, plus new intents such as 'in' and 'reduce'  
  (see 'Semantic Changes' and 'New Features' sections below)
* added support for standalone parallel iterators, used by non-zippered foralls  
  (see examples/primers/parIters.chpl)
* added support for vectorization of data parallel loops and operations  
  (see '--vectorize' flag in 'man chpl')
* optimized away communication code for module-scope variables and local arrays  
  (see release note slides at https://chapel-lang.org/releaseNotes.html)
* added an early prototype interactive/interpreted mode for writing Chapel code  
  (see doc/technotes/README.chpl-ipe.rst for more details)
* initial support for Python->Chapel interoperability via PyChapel  
  (see http://pychapel.readthedocs.org/ for more details)
* made 'ugni'/'muxed' the default comm/tasking choices for cray-x* module users  
  (see doc/platforms/README.cray and doc/README.chplenv)
* added a new 'chpltags' utility to generate emacs/vim tags for Chapel code  
  (see 'util/chpltags --help' and 'util/README')
* numerous other improvements for better performance and cleaner generated code  
  (see 'Performance Improvements' section below)
* improved portability to NetBSD and additional flavors of Linux  
  (see 'Portability Improvements' section below)
* upgraded the bundled versions of GASNet, hwloc, llvm, and dygraphs  
  (see 'Third-Party Software Changes' section below)
* numerous bug fixes  
  (see 'Bug Fixes' section below)

Environment/Configuration Changes
---------------------------------
* made the setchplenv.* scripts prepend to PATH and MANPATH rather than append
* made the "quickstart" scripts set CHPL_COMM to 'none' and not set CHPL_MEM
* improved the logic for auto-detecting when CHPL_ATOMICS should be 'intrinsics'
* added auto-detection of CHPL_*_PLATFORM for 'cray-xc'/'cray-xe' systems
* added support for building runtime/third-party with the bundled clang version  
  (see references to 'clang-included' in README.chplenv)
* split the 'cygwin' CHPL_*_PLATFORM value into 'cygwin32' and 'cygwin64'
* added new 'netbsd32' and 'netbsd64' values for CHPL_*_PLATFORM
* changed CHPL_COMM/TASKS to default to ugni/muxed when using the cray-x* module  
  (see doc/README.chplenv, doc/platforms/README.cray, and/or doc/README.tasks)
* made CHPL_TASKS default to 'fifo' for 'cray-prgenv-cray' CHPL_TARGET_COMPILER

Packaging Changes
-----------------
* updated Makefiles to support building Chapel in parallel via 'make -j'
* avoid rebuilding gmp and re2 speculatively when previous builds have failed

Tool Changes
------------
* added an early prototype interactive/interpreted mode for writing Chapel code  
  (see doc/technotes/README.chpl-ipe.rst for more details)
* revamped 'chpldoc' to create HTML files via Sphinx for documenting Chapel code  
  (see doc/technotes/README.chpldoc.rst and 'man chpldoc' for more details)
* added a new 'chpltags' utility to generate emacs/vim tags for Chapel code  
  (see 'util/chpltags --help' and 'util/README' for more information)

Syntactic/Naming Changes
------------------------
* removed the placeholder keyword 'refvar' in favor of the new keyword 'ref'
* removed support for the use of 'var' as a return intent (use 'ref' instead)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* added support for task intent clauses and semantics to forall loops  
  (see 'Data Parallelism: Forall Intents' in the language specification)
* added initial support for 'reduce' intents on forall loops  
  (see doc/technotes/README.reduceIntents)
* removed the 'type select x' syntax in favor of simply using 'select x.type'
* made read()s of sync/single variables result in a compiler error

New Features
------------
* added "blank", 'const', 'in', 'const in' and 'const ref' task intents  
  (see 'Task Parallelism: Task Intents' in the language specification)
* added "standalone parallel iterators", used by non-zippered forall loops  
  (see examples/primers/parIters.chpl)
* added support for aliasing of domains via the '=>' operator

New Interoperability Features
-----------------------------
* initial support for Python->Chapel interoperability via PyChapel  
  (see http://pychapel.readthedocs.org/ for more details)
* added a prototype capability to embed external dependencies to source via 'use'  
  (e.g., use "foo.h", "-lfoo"; is like adding these to the 'chpl' command-line)
* added support for passing multidimensional arrays to external routines  
  (see doc/technotes/README.extern)
* added munging of all user identifiers by default to avoid naming conflicts  
  (see --[no-]munge-user-idents in 'man chpl' and doc/README.executing)
* added an error when passing Chapel strings to C routines; use c_string instead

Standard Library/Modules
------------------------
* added a new module, FileSystem, containing numerous file system operations  
  (see https://chapel-lang.org/docs/1.11/modules/standard/FileSystem.html)
* added support for key 64-bit FFTW routines (single- and multi-threaded)  
  (see https://chapel-lang.org/docs/1.11/modules/standard/FFTW.html and  
   https://chapel-lang.org/docs/1.11/modules/standard/FFTW_MT.html)
* added parity() and rotate() operations to the BitOps module  
  (see https://chapel-lang.org/docs/1.11/modules/standard/BitOps.html)
* added parallel versions of the glob(), walkdirs(), and findfiles() iterators  
  (see https://chapel-lang.org/docs/1.11/modules/standard/FileSystem.html)
* started a new module, Path, supporting realPath(), curDir, parentDir, pathSep  
  (see https://chapel-lang.org/docs/1.11/modules/standard/Path.html)
* added a new module, Assert, defining a simple assertion capability  
  (see https://chapel-lang.org/docs/1.11/modules/standard/Assert.html)
* added support for C types c_ptrdiff, c_uintptr, and c_intptr to SysCTypes.chpl  
  (see https://chapel-lang.org/docs/1.11/modules/standard/gen/doc/SysCTypes.html)
* changed cwd() and chdir() from standalone functions to locale methods  
  (see https://chapel-lang.org/docs/1.11/modules/standard/FileSystem.html)
* made mkdir(parents=true) behave more like 'mkdir -p'
* added a .safeCast() method to integer types to value-check downcasts  
  (see https://chapel-lang.org/docs/1.11/modules/standard/Types.html)
* changed min(t) and max(t) to return 'param' values for integral types 't'  
  (see https://chapel-lang.org/docs/1.11/modules/standard/Types.html)
* parameterized RandomStream by an 'eltType' and updated its methods accordingly  
  (see https://chapel-lang.org/docs/1.11/modules/standard/Random.html)
* removed the parSafe arguments from RandomStream's methods in the Random module  
  (see https://chapel-lang.org/docs/1.11/modules/standard/Random.html)
* added support for escaping pattern-style format strings using %{}  
  (e.g., "writef("#%{##}", 10)" => "#10")
* added support for readf()/writef() of octal values
* changed 'BigInt' methods to use Chapel types rather than C types
* folded the prototypical 'Filerator' module into the new 'FileSystem' module
* retired the 'Containers' module in favor of vector operations on arrays  
  (see examples/primers/arrayVectorOps.chpl)

Performance Improvements
------------------------
* added support for vectorization of data parallel loops and operations  
  (see '--vectorize' flag in 'man chpl')
* optimized away the creation of anonymous ranges in loops  
  (e.g., 'for i in 1..10' no longer creates an anonymous range object for 1..10)
* optimized away communication code for module-scope variables and local arrays
* optimized iterations over ranges in data parallel constructs like 'forall'
* added standalone parallel iterators for ranges and default domain maps
* extended loop-invariant code motion to include certain global variables
* added an 'assertNoSlicing' config that can be used to optimize array accesses  
  (see $CHPL_HOME/PERFORMANCE)
* avoided creating new singleton tasks within serial execution contexts

Memory Improvements
-------------------
* reduced memory leaks due to compilerWarning()s and runtime string arguments
* distinguished between "owned" and "unowned" c_strings in implementation
* improved the handling of strings across multiple locales

Launcher-specific Changes
-------------------------
* in the 'pbs-aprun' launcher, removed reliance on the mpp* options
* added a --nodelist option to the 'slurm-srun' launcher
* in the 'slurm-srun' launcher, stopped using expect scripts

Platform-specific Changes
-------------------------
* fixed an issue in which Qthreads would not handle sleep() correctly for darwin
* added a micro-sleep when yielding threads on Cygwin to improve throughput
* changed CHPL_COMM/TASKS to default to ugni/muxed when using the cray-x* module  
  (see doc/README.chplenv, doc/platforms/README.cray, and/or doc/README.tasks)
* enabled 'ugni' tasking to be usable with 'qthreads' as well as 'muxed'
* reduced default heap size used for CHPL_COMM='ugni' to 2/3 free node memory  
  (see doc/platforms/README.cray)
* changed 'muxed' tasking to use # of threads equal to the # of CPUs by default  
  (see doc/platforms/README.cray)
* disabled optimizations by default for cray-prgenv-cray compilations
* split the 'cygwin' platform value into 'cygwin32' and 'cygwin64'
* split the 'netbsd' platform value into 'netbsd32' and 'netbsd64'
* made CHPL_TASKS default to 'fifo' for 'cray-prgenv-cray' CHPL_TARGET_COMPILER

Portability Improvements
------------------------
* fixed several portability issues on NetBSD platforms
* fixed the use of the --llvm flag on Mac OS X ('darwin') platforms
* fixed some portability issues with the use of hwloc and -lnuma for 'qthreads'
* fixed some static/dynamic linking issues with certain platforms/compilers
* fixed a gmp build issue for 32-bit platforms

Third-Party Software Changes
----------------------------
* updated the bundled version of GASNet to 1.24.0
* updated the bundled version of hwloc to 1.10.1
* updated the bundled version of llvm to 3.6.0
* upgraded the bundled version of dygraphs to version 1.1.0
* added support for dynamically installing Python packages required by 'chpldoc'  
  (see 'chpldoc-venv' in third-party/README)
* rearchitected scripting framework for third-party dependencies
* made the re2 build do a better job of propagating errors back to the Makefiles
* changed Qthreads to avoid using guard pages when mprotect() won't work
* fixed a bug in limiting the maximum size of Qthreads memory pools

Documentation
-------------
* added web-based docs for all standard modules and removed from spec/READMEs  
  (see https://chapel-lang.org/docs/)
* made some minor improvements to the Quick Reference document
* added documentation for class and record destructors to the spec
* removed an outdated distinction between function calls using () vs. [] in spec
* clarified that integer literals may be 'int' or 'uint' in the spec
* added a note for 'zsh' users to the top-level README
* added a note to CONTRIBUTORS noting mis-attributed code authors within GitHub
* improved the documentation of the slurm* launchers  
  (see doc/README.launcher, doc/platforms/README.cray)
* added a note about ugni memory registration and concurrency with slurm  
  (see doc/platforms/README.cray)
* added a note about a longstanding undocumented feature to squash ref counting  
  (see $CHPL_HOME/PERFORMANCE)

Example Codes
-------------
* added a new primer example demonstrating use of the FFTW module  
  (see examples/primers/FFTWlib.chpl)
* added standalone parallel iterators to the leader-follower primer and renamed  
  (see examples/primers/parIters.chpl)
* updated and renamed the chpldoc primer example to reflect chpldoc's changes  
  (see examples/primers/chpldoc.doc.chpl)
* updated the random numbers primer to reflect changes to the interface  
  (see examples/primers/randomNumbers.chpl)
* fixed a bug in our lulesh implementation when using the 3D representation
* updated miniMD's Stencil distribution to track changes in BlockDist
* changed miniMD to work around a bug in passing remote records by blank intent
* updated the HPCC FFT example to use new BitOps
* updated SSCA2 to reflect new intent semantics for forall-loops
* updated the regexdna shootout to accept extra arguments as used by framework
* made stream and ra save their problem sizes when performance testing
* replaced the use of format() in example codes with writef()

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* added --[no-]use-noinit to permit 'noinit' to be ignored
* added support for setting --fast via environment variable CHPL_FAST
* added --[no-]ignore-classes to disable local class optimizations
* added --[no-]vectorize to enable/disable generation of vectorization hints
* added --[no-]cast-checks to enable/disable value checking in safeCast methods
* added --[no-]munge-user-idents to control munging of generated identifiers
* removed all documentation-related options; use 'chpldoc' instead
* added a flag --[no-]task-tracking to enable/disable runtime task tracking

New Semantic Checks (for old semantics)
---------------------------------------
* improved 'const' checking for array/tuple fields and array/domain aliases

Error Message Improvements
--------------------------
* added an error when compiling for a configuration whose runtime is not built
* improved error messages for several range overflow conditions

Bug Fixes
---------
* fixed a bug with dynamically dispatched iterators
* fixed a bug with parallel iteration over non-naturally-aligned ranges
* fixed a bug in which record variables did not call user-defined constructors
* fixed a bug in which arrays of associative domains could cause a segfault
* fixed a bug in which user identifiers could easily conflict with C identifiers
* fixed a bug with formatted writes of integers using "###."
* fixed an infinite loop in binary reads of strings when EOF is reached
* fixed a bug preventing sparse domains from having 'uint' indices
* fixed a bug when casting param 'int(64)' and 'uint(?)' to 'c_string'
* fixed a bug in which secondary parentheses-less methods did not work well
* fixed a buffer overrun issue in certain I/O routines
* fixed a bug in which defining multiple destructors caused a segfault
* fixed some bugs in the standard Buffers module
* fixed a bug in which filenames generated by --cpp-lines would get corrupted
* fixed a bug in --cache-remote for 32-bit platforms
* fixed a bug with loop invariant code motion in the context of nested functions
* fixed a crash when using multiple formal type queries for primitives types
* fixed a bug in which iterators yielding locale types caused an internal error
* fixed a bug in which --no-remove-copy-calls would break certain extern records
* fixed a bug in the parser causing issues with &&= and ||= for --baseline
* fixed a bug in which developer pragmas were only attached to the first symbol

Platform-specific bug fixes
---------------------------
* fixed a bug in which I/O errors would print "unknown" for paths for 'cygwin'
* fixed a warning in our calls to glob() when compiling with 'prgenv-cray'
* fixed an issue in which generated identifiers could be too long for 'pgi'
* fixed a bug in which 'gmp' would not build cleanly for 32-bit Ubuntu systems
* fixed a bug in atomic operations on 'real' types for CHPL_COMM='ugni'

Runtime Library Changes
-----------------------
* enabled 'ugni' tasking to be usable with 'qthreads' as well as 'muxed'
* changed Qthreads to yield after uncontested sync var locks to avoid starvation

Compiler Performance
--------------------
* accelerated compilation times by disabling the task table by default  
  (see '--[no-]task-tracking' on the 'chpl' man page and doc/README.executing)

Testing System
--------------
* added support for specifying 'skipif' files as executable scripts
* added a mode in which only futures with .skipif files are tested
* check for .skipif conditions before wasting any effort on a test
* switched to a consistent and simpler naming scheme for test configurations
* added timing measurements to the log for various aspects of testing
* revamped emails sent by testing scripts for maintainability and spam avoidance
* made the test system less sensitive to line/versions #s in .bad comparisons
* added a --test-root flag, improving start_test when run from outside CHPL_HOME
* fixed a bug in which '-nl' was passed to C tests for multilocale testing
* added support for jUnit XML-style report generation to start_test and paratest
* made paratest.server's compopts/execopts accumulate rather than overwrite
* added CHPL_TEST_UNIQUIFY_EXE to support simultaneous test runs on a directory
* added the ability to set the default testing timeout via CHPL_TEST_TIMEOUT
* added support for CHPL_TEST_NUM_TRIALS to be set by a user's environment
* squashed duplicate error messages due to sub_test failures
* fixed a bug with stdin redirects for tests with multiple .execopts
* made start_test smarter about stdin and launchers for multilocale testing
* improved the testing system's handling of timeouts when launchers are used
* added validation for CHPL_NIGHTLY_LOGDIR in nightly testing
* fixed a bug for tests with multiple execopts settings that timed out
* permitted suppression files to contain blank lines
* fix bug in which suppression-based issues only appeared in the test summary
* fixed a bad interaction between env. vars. set in sub_test vs. execenv files
* made sub_test ignore OS errors during unlinking to quiet false negatives

Performance Testing/Graphing System
-----------------------------------
* allow scrolling of the list of graphs independently from graphs themselves
* embed more information in the URL of performance graphs for sharing purposes
* improved the portability of URLs from the performance graphing system
* added support for 'today' as a date in the perf graph system's URL encodings
* accelerated graphs by moving sorting of graphs' legends into genGraphs script
* track top processes between performance runs to look for causes of noise
* improved support for comparing multiple performance testing configurations
* started logging the sha values for performance runs, for historical reference
* changed performance graphs to use json rather than csv
* automatically strip punctuation characters from the end of graph keys

Developer-oriented changes: Utility Changes
-------------------------------------------
* added a new compiler gdb command 'locid' which prints an AST's source location
* made build_configs.py support parallel execution

Developer-oriented changes: Compiler Flags
------------------------------------------
* added --report-order-independent-loops to note loops with vectorization hints
* added --remove-unreachable-blocks to attempt early removal of dead code
* fixed a code pointer in the --help message for --log

Developer-oriented changes: Module improvements
-----------------------------------------------
* added a pragma for asserting that a class field is local to the object
* moved routines in support of iterators to a new module ChapelIteratorSupport
* split _build_range() into several routines with better names
* refactored overloads of range operator definitions
* changed Filerator routines to use new isLink(), isDir(), and isFile() routines
* removed requirement to add 'no ChapelStandard' pragma to internal modules

Developer-oriented changes: Makefile improvements
-------------------------------------------------
* added a "WARNINGS" macro that can be used to turn on C-level warnings
* moved check for standard C headers into the post-commit smoke test
* simplified and regularized third-party Makefiles

Developer-oriented changes: Compiler improvements/changes
---------------------------------------------------------
* changed the parser to a "pure push" style of parser
* changed the compiler to require bison 2.5 (or later)
* dramatically reworked representation and manipulation of loop AST nodes
* made more AST members private and increased the use of query methods
* added a new, prototype AST pretty-printer for Chapel-oriented output
* made improvements to list_view()
* made flags on a symbol print in a deterministic order
* extended DeadCodeElimination to reclaim degenerate C for loops
* made 'narrowWideReferences' its own compiler pass and refactor it
* moved the 'docs' pass earlier in compilation
* reorder localCopyPropagation to avoid a ref-before-def bug
* improved verification of expressions to check correctness of AList links
* fixed a bug in which failed chpl__tryToken resolutions could roll back too far
* removed flags: FLAG_LABEL_BREAK, FLAG_LABEL_CONTINUE, FLAG_USER_NAMED
* distinguished FLAG_WIDE from FLAG_WIDE_REF
* deprecated the use of the MOD_MAIN tag
* simplified code related to calling user-defined constructors vs. _defaultOf
* converted the collapsing of nested BlockStmts to use a visitor
* added a predicate to determine if an expression is a "statement expression"
* converted some uses of C arrays to std::vector in compiler
* added binary operators to the BitVec implementation
* replaced the basic block macros with private static functions
* fixed a bug in basic block analysis
* moved the handling of boolean short-circuiting from 'parse' to 'normalize'
* renamed 'by' operators in the compiler's IR to avoid naming conflicts
* refactored fix_def_expr() in the normalize pass
* refactored constant folding vs. dead code elimination for CondStmts
* fixed several code issues identified by coverity scan
* many other code refactorings and improvements

Developer-oriented changes: Runtime improvements
------------------------------------------------
* simplified interactions between locale models and the runtime
* improved the non-blocking communication interface
* added support for the main process to run Chapel tasks
* guarded against some src==dst calls to memcpy()
* for optimized builds of the runtime, set NDEBUG to turn off assertions
* fixed several code issues identified by coverity scan

Developer-oriented changes: Generated Code improvements
-------------------------------------------------------
* improved the spacing when printing IDs via --gen-ids



version 1.10.0
==============

Thirteenth public release of Chapel, October 2, 2014

Highlights
----------
* changed Chapel's license and contributor agreement to Apache 2.0  
  (see 'Licensing Changes' section below)
* made Qthreads the default tasking layer for Chapel on most platforms  
  (see doc/README.chplenv and doc/README.tasks for details)
* added initial support for Intel Xeon Phi Knights Corner (KNC) processors  
  (see doc/platforms/README.knc)
* added new standard modules for bit operations, prefetch, file/directory utils  
  (see 'Standard Modules' section below)
* extended auxiliary file system support for HDFS to include Lustre and cURL  
  (see doc/README.auxIO for details)
* added support for set-based operations on associative domains and arrays  
  (see doc/technotes/README.sets and examples/primers/associative.chpl)
* added draft support for vector methods on 1D arrays with a personal domain  
  (see examples/primers/arrayVectorOps.chpl)
* added the ability to query arrays for the subdomain(s) that the locale owns  
  (see doc/technotes/README.subquery and examples/primers/distributions.chpl)
* added the ability to pass contiguous Chapel arrays to extern procedures  
  (see doc/technotes/README.extern)
* performance boosts due to Qthreads tasking, improved LICM, less communication  
  (see 'Performance Improvements' below)
* several generated code cleanups including C for loops and fewer ref temps  
  (see 'Generated Code Cleanups' below)
* significantly improved const-ness checking for fields, indices, domains/arrays
* fixed the semantics for passing sync/single variables to generic arguments
* improved support for, and orthogonality of, constructor calls
* added a compiler flag to support specializing for the target architecture  
  (see descriptions of CHPL_TARGET_ARCH and --[no-]specialize below)
* added symbolic CHPL_RT_NUM_THREADS_PER_LOCALE values to support common cases  
  (see doc/README.tasks for details)
* added an --about flag to Chapel executables to print compilation information
* new primer examples for associative domains/arrays, vector ops, random numbers  
  (see 'Example Codes' below)
* two new shootout benchmarks and many improvements to the existing ones  
  (see 'Example Codes' below)
* split setchplenv.* source scripts into "quick start" and "production" modes  
  (see $CHPL_HOME/README)
* by default, attempt to build and enable RE2 and GMP when possible  
  (see doc/README.chplenv)
* updated versions of hwloc, tcmalloc, and gasnet third-party packages  
  (see 'Third-Party Software Changes' below)
* numerous bug fixes  
  (see 'Bug Fixes' below)
* many test system improvements including C-based testing and external timers  
  (see 'Testing System' and 'Performance Testing/Graphing System' below)
* many developer process improvements such as GitHub, Travis, Coverity, Jenkins  
  (see 'Developer-oriented Changes: Process Changes' below)
* many other developer-oriented improvements and refactorings  
  (see other 'Developer-oriented Changes: ...' sections below)

Licensing Changes
-----------------
* changed Chapel's license from BSD to Apache 2.0  
  (see $CHPL_HOME/LICENSE.chapel for details)
* changed Chapel's contributor agreement from a Cray agreement to Apache 2.0  
  (see https://chapel-lang.org/developers.html for details)

Packaging Changes
-----------------
* split the util/setchplenv.* scripts into quick-start and "production" versions  
  (see $CHPL_HOME/README and util/README for more information)
* for non-quickstart users, we now attempt to enable RE2 and GMP by default  
  (see doc/README.chplenv for details)
* removed the util/update-sources script which had fallen out-of-date

Environment Changes
-------------------
* changed the default value of CHPL_TASKS to 'qthreads' for most platforms  
  (see doc/README.chplenv and doc/README.tasks for details)
* added CHPL_TARGET_ARCH to describe the target processor architecture  
  (see doc/README.chplenv for details)
* added CHPL_AUX* environment variables for accessing HDFS, Lustre, and/or cURL  
  (see doc/technotes/README.auxIO)
* added symbolic physical/logical values for CHPL_RT_NUM_THREADS_PER_LOCALE  
  (see doc/README.tasks for details)
* generalized CHPL_RT_MAX_HEAP_SIZE to control GASNet's segment size  
  (see doc/README.executing for more information)
* generalized CHPL_RT_CALL_STACK_SIZE to control Qthread stack sizes  
  (see doc/README.executing for more information)
* renamed the CHPL_MEM setting previously called 'default' to 'cstdlib'

Portability Improvements
------------------------
* added initial support for Intel Xeon Phi Knights Corner (KNC) processors  
  (see doc/platforms/README.knc)
* fixed a bug in which newer versions of Cygwin weren't properly detected

Syntactic/Naming Changes
------------------------
* changed the syntax for task intents from 'ref(ident)' to 'with (ref ident)'  
  (see the 'Task Parallelism' chapter of the language specification for details)
* deprecated 'var functions' in favor of returning by 'ref' intent  
  (see the 'Procedures' chapter of the language specification for details)
* renamed the 'default' setting for CHPL_MEM to 'cstdlib'  
  (see doc/README.chplenv for details)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* made passing syncs/singles to generic arguments pass them by 'ref'  
  (previously, such calls would unwrap the sync/single, passing the value in)
* redefined op= on associative domains in terms of set operations  
  (see doc/technotes/README.sets for more information)
* made loops over ranges that rely on overflow undefined  
  (e.g., 'for i in 1..max(int) do ...' is not well-defined)
* make a more explicit distinction between the 'string' and 'c_string' types  
  (see doc/technotes/README.extern for more information on 'c_string')
* added support for the logical negation of integral types  
  (e.g., 'var x = 3;  if (!x) then ...' is now legal Chapel code)
* removed support for interpreting {D} as D for domain D  
  (given 'const D: domain(...) = ...;', '{D}' is not a domain of domains)

New Features
------------
* added support for Lustre and cURL file systems  
  (see doc/technotes/README.auxIO and README.curl for details)
* added support for standard set operations on associative domains and arrays  
  (see doc/technotes/README.sets and examples/primers/associative.chpl)
* added support for extending an associative array's personal domain via stores  
  (see examples/primers/associative.chpl)
* added draft support for vector methods on 1D arrays with a personal domain  
  (see examples/primers/arrayVectorOps.chpl)
* added the ability to query arrays for the subdomain(s) that the locale owns  
  (see doc/technotes/README.subquery and examples/primers/distributions.chpl)
* made the compiler call user-defined default constructors when defined
* added the ability to call constructors through type aliases  
  (e.g., 'class C { ... }  type t = C;  var myT = new t();' now works)
* added support for numerous type-oriented queries for expressions  
  (see doc/technotes/README.typeQueries)
* added octal literals  
  (e.g., 0o777)
* added support for 'noinit' on record and class variables  
  (see the 'Variables' chapter of the language specification)
* added experimental support for user-defined default values for record types  
  (e.g., 'proc _defaultOf(type t) where t:R { var r: t; r = ...; return r; })
* added locale.maxTaskPar to query the # of parallel tasks a locale can support  
  (see the 'Locales' chapter of the language specification)
* added initial support for 'ref' variables using a placeholder 'refvar' syntax  
  (e.g., 'var x = 3; refvar y = x; x = 5; assert(y == 5);' will not fail)

Changes to the Implementation
-----------------------------
* improved the current support for HDFS file systems  
  (see doc/technotes/README.auxIO and README.hdfs for more information)
* made 'dataParTasksPerLocale' default to 'locale.maxTaskPar'  
  (see the 'Data Parallelism' chapter of the language specification)

New Interoperability Features
-----------------------------
* added the ability to pass contiguous Chapel arrays to extern procedures  
  (see README.extern)
* extern C procedures should now take 'c_string' arguments rather than 'string'
* changed the return type of is_c_nil from c_int to bool

Standard Modules
----------------
* added a new standard module supporting some initial bitwise operations  
  (see modules/standard/BitOps.chpl)
* added a new standard module supporting a prefetch() operation  
  (see modules/standard/Prefetch.chpl)
* added some initial file/directory utility routines (more planned for 1.11)  
  (e.g., remove(), rename(), cwd(), chdir(), mkdir(), chown()
* added draft support for glob() and walking directory trees  
  (see modules/standard/Filerator.chpl -- feedback desired)
* added readstring()/readline() methods that read bytes into strings/arrays  
  (see modules/standard/IO.chpl)
* added an experimental sorted() iterator for sorting arrays or other iterables  
  (see modules/standard/Sort.chpl)
* added the ability to have the Sort.chpl module routines sort in reverse
* implemented new module NewString defining 'string_rec'  
  (prototype to replace 'string' in version 1.11)
* added a printMemLeaks() routine for printing out a memory leaks table  
  (see modules/standard/Memory.chpl)
* improved Random.chpl's SeedGenerator.currentTime to avoid duplicate seeds
* rewrote the AdvancedIters module to use 'atomic' rather than 'sync' vars
* removed the Profiling-related modules and source code

Documentation
-------------
* added doc/platforms/README.knc to describe using Chapel for KNC
* added doc/technotes/README.auxIO and .curl to describe new file system support
* added doc/technotes/README.sets to describe new associative domain set ops
* added doc/technotes/README.fileUtil to describe current file utility routines
* added doc/technotes/README.subquery to describe array subdomain queries
* added a description of CHPL_RT_MAX_HEAP_SIZE/GASNET_MAX_SEGSIZE to README.cray
* improved the specification of procedure arguments and returns
* added the proposed support for forall intents to the language specification
* fixed a spec code example that failed to use task intents as needed
* many updates, clarifications, and improvements to the language specification
* many updates and improvements to the READMEs in general

Example Codes
-------------
* added a new primer for associative domains/arrays and set operations on them  
  (see examples/primers/associative.chpl)
* added a new primer for vector operations on 1D arrays  
  (see examples/primers/arrayVectorOps.chpl)
* added a new primer for random number generation  
  (see examples/primers/randomNumbers.chpl)
* added two new shootout benchmarks: meteor-fast, regexdna  
  (see examples/benchmarks/shootout/meteor-fast.chpl and regexdna.chpl)
* replaced the fannkuch-redux benchmark with a parallel version  
  (see examples/benchmarks/shootout/fannkuch-redux.chpl)
* updated the mandelbrot benchmark to use a dynamic iterator  
  (see examples/benchmarks/shootout/mandelbrot.chpl)
* updated chameneos benchmark to use conditionals instead of select statements  
  (see examples/benchmarks/shootout/chameneosredux.chpl)
* removed some CHPL_RT knob-fiddling from the thread-ring benchmark
* fixed the portability of the pidigits benchmark to 32-bit systems  
  (see examples/benchmarks/shootout/pidigits.chpl)
* updated the fileIO primer to utilize/demonstrate whole-array I/O  
  (see examples/primers/fileIO.chpl)
* improved the locking strategy used in verification for the HPCC RA benchmark
* removed the unnecessary locking and error tolerance from ra-atomics.chpl
* changed HPCC RA benchmarks to print problem sizes before declaring arrays
* minor edits to the domains primer

Source Highlighting Changes (see etc/README)
--------------------------------------------
* updated vim, emacs, highlight, and source-highlight modes with new keywords
* other general improvements to vim and emacs modes
* added a pointer to the Chapel support for pygments  
  (see etc/pygments/README.rst)

Launcher-specific Notes
-----------------------
* improved the 'slurm-srun' launcher
* updated 'aprun' launcher to support KNC
* added environment forwarding for the 'amudprun' launcher

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* added a --[no-]specialize flag that supports CHPL_TARGET_ARCH specialization  
  (see doc/README.chplenv for details beyond those on the man page)
* added a --[no-]stack-checks flag to the compiler  
  (see README.tasks for details beyond those on the man page)
* made --fast imply --specialize and --no-stack-checks by default
* added a new --cache-remote flag to enable caching remote data
* --print-passes now prints additional timing information about passes

Flags on Generated Executables
------------------------------
* added an --about flag to print information about how a program was compiled

Error Message Improvements
--------------------------
* added an error message for function control paths that fail to return values
* added a warning if a hugepages module is/is not loaded as CHPL_COMM requires
* improved error messages for I/O failures
* improved the error message for assignments between unsupported type pairs
* improved resolution errors to distinguish between having 0 vs. 2+ candidates
* improved error messages for applying 'new' to incorrect expression types
* issue an error when using the --llvm flag when LLVM is not enabled
* fixed a warning message in which CHPL_GASNET_SEGMENT was mis-named

Performance Improvements
------------------------
* improved the performance of the Qthreads tasking layer
* improved the loop invariant code motion optimization for --no-local compiles
* improved the performance of the serial 1D array iterator
* optimized task counters to make use of network atomics when available
* reduced communication counts for several common code idioms
* added an experimental optimization for caching remote data with 'fifo' tasking  
  (see --cache-remote flag on 'chpl' man page)
* improved the performance of readstring()

Third-Party Software Changes
----------------------------
* made many improvements to our use of Qthreads in the 'qthreads' tasking layer
* updated snapshot of hwloc to version 1.9.1
* updated snapshot of tcmalloc to version 2.2 and patched to work with Chapel
* applied GASNet patches to fix pshm gemini/aries memory registration issues
* improved the portability of the re2 code base and regexp feature
* parallelized the build of the llvm and gmp packages to reduce build time
* reduced the number of llvm components we build to reduce build time

New Semantic Checks (for old semantics)
---------------------------------------
* improved const-ness checking for 'const' fields, loop indices, domains/arrays
* added checks for assignments to illegal l-values via op= operators
* added semantic checks to prevent against overflow in range iteration

Bug Fixes
---------
* fixed a bug in which int literals > max(int(32)) could not coerce to uint(32)
* fixed support for uppercase binary and hexadecimal literals  
  (e.g. 0B1101101 and 0Xbabe1055)
* fixed a bug in which ~1% of compiles would segfault on Macs
* fixed a bug relating to nested records and default constructors
* fixed a bug in which varargs functions with 'ref' intent did not work
* fixed a bug in which the compiler did not preserve param boolean sizes
* fixed a bug in 'noinit' initializations shared by multiple variables
* fixed a bug in which writef() was missing an overload
* fixed some bugs in readstring()
* fixed a race condition in associative domains' member() function
* fixed an internal error relating to record variables in param conditionals
* fixed some bugs in the GMP module
* fixed a bug in which multi-locale memory tracking was broken
* fixed a bug in loop-invariant code motion
* fixed several bugs in the LLVM backend

Runtime Library Changes
-----------------------
* refactored the runtime's auxiliary file system support to support many at once
* made the tasking layer specify the default value for dataParTasksPerLocale
* in 'qthreads' tasking, made the progress engine a pthread, not a task
* added new non-blocking communication functions to the runtime interface
* added yields to the communication layer's barriers to avoid wasting resources
* removed barrier-related communications from verbose comm output by default

Generated Code Cleanups
-----------------------
* changed the generated code to use C for-loops for ranges and certain arrays
* eliminated unnecessary reference temps in many common cases, like assignments
* added dead module elimination to reduce the amount of generated code
* removed extraneous chpl__readXX() calls from the generated code
* changed the mix of which compiler-generated functions are inlined vs. not

Compiler Performance
--------------------
* improved compilation speed by rewriting printchplenv and chplenv/* in Python
* consolidated the compiler's system calls to reduce compiler overhead

Testing System
--------------
* added the ability to add C-based tests to the test system
* added the ability for an *execopts file to redirect stdin as its last args
* added automatic squashing of internal module line numbers for .bad diffs
* the test system now logs a list of top CPU consumers if a test times out
* added a notion of a temporary test directory that is cleaned up after a run
* changed memory leaks test accounting to include strings
* added a --syspreexec flag to the start_test script
* added the ability to have locale-model-based .good files in testing
* added the ability to match against variants of an explicitly named .good file

Performance Testing/Graphing System
-----------------------------------
* add the ability to use different external timers in performance testing
* embedded the active graph list into the performance testing system's URLs
* removed duplicate checkboxes from the list of performance graphs
* fixed the support for annotating multiple graph series' at once
* made performance testing only run one trial for a higher-than-default timeout
* fixed a bug in which multiple performance test trials were replicating data
* made performance testing remove .exec.out.tmp on successful runs
* added the ability to graph .dat files listed by SVN revision rather than date
* made the default compiler performance directory unique by machine name
* avoided sync-ing performance graphs to the web if errors are encountered
* improved the behavior of the log-scale button's warning mode

Developer-oriented changes: Process Changes
-------------------------------------------
* migrated Chapel's repository from Subversion on SourceForge to git on github
* began using Travis for pre-commit sanity checks
* began using Coverity scan regularly to catch code quality issues
* converted testing from cron-based to Jenkins-based
* added a script to aid with building multiple Chapel configurations  
  (see util/build_configs.py --help for more information)
* added copyrights to sources within git (rather than tagging at release time)

Developer-oriented changes: Compiler Flags
------------------------------------------
* added a new --lldb developer flag for debugging with LLDB
* added a --print-module-resolution developer flag
* changed developer --version numbers to display the sha1 + branch
* made minor improvements to the --minimal-modules compilation mode
* removed the developer --ignore-internal-modules flag

Developer-oriented changes: Executable flags
--------------------------------------------
* added a -E flag for launchers to forward environment variables to _reals

Developer-oriented changes: Module improvements
-----------------------------------------------
* added an ability for developers to access 'param' and 'type' fields in Chapel
* merged internal ChapelRange and ChapelRangeBase modules/types together
* converted remaining assignment ops to use the new '=(ref x, y)' signature
* rewrote assignments to use PRIM_ASSIGN rather than PRIM_MOVE
* made ioerror return without exiting on ENOERR
* added a remote prefetch primitive
* extended network atomic interface to accept memory_order (currently ignored)
* fixed the return types of non-fetch network atomic methods to be 'void'
* refactored the reference counting code for domain maps, domains, and arrays
* converted internal use of external procedures to use 'c_string', not 'string'
* refactored Memory module to avoid injecting extern symbols into global scope
* refactored string support into new files  
  (see runtime/*/chpl-string.h/.c and modules/internal/String.chpl)
* moved privatized ID tracking from the runtime to the modules
* cleaned up deprecated file operations

Developer-oriented changes: Compiler improvements
-------------------------------------------------
* fixed a number of issues identified by Coverity and the Clang Static Analyzer
* created a "visitor" supporting a pre-order traversal of the IR
* rewrote the three viewing formats to use the new visitor capability
* added a PhaseTracker capability for taking timings within the compiler
* eliminated creation of order and coercion wrappers within compiler
* add memory fences to places that need them in the generated code and runtime
* added partial instantiation of generic functions to the resolution pass
* tightened up the use of function_exists() to avoid false matches
* significantly improved how default values are established by the compiler
* added an internal function for getting the first of an enum's values
* added a "ignore noinit" pragma to override noinit support
* squashed default initialization of certain compiler-introduced temp variables
* removed many compiler-introduced PRIM_MOVE operations
* improve how module uses are tracked and managed
* replaced the resolvedFns map with a flag on FnSymbols
* fixed the placement of an iterator tag argument
* removed some unnecessary scopeless block statements in the front-end
* replaced every procedure's nested BlockStmt with a single one
* moved module initialization function creation from parser to normalize
* various other code cleanups and refactorings

Developer-oriented changes: Compiler refactorings
-------------------------------------------------
* cleaned up the AST classes w.r.t. protected, private, const, etc.
* split statement AST nodes out from 'Expr' and into a new base class, 'Stmt'
* refactored view.cpp into three files matching its three viewing formats  
  (see compiler/AST/AstDump.cpp, ASTDumpToHTML.cpp, and view.cpp)
* refactored and cleaned up code related to specifying and running passes
* cleaned up the compiler's timer class
* cleaned up arg.cpp
* refactored logging related code into log.h/cpp
* moved insertWideReferences into its own file
* replaced Symbol class bool fields with flags
* removed dead code relating to garbage collection and the early interpreter
* removed dead FLAGs and memory descriptor types

Developer-oriented changes: Runtime improvements
------------------------------------------------
* refactored task-local runtime data into a single structure
* made the runtime code more resilient to mixing C++/C compilers



version 1.9.0
=============

Twelfth public release of Chapel, April 17, 2014

Highlights (see entries in subsequent categories for details)
-------------------------------------------------------------
* numerous performance improvements (see 'Performance Improvements' below)
* significant reductions in compiler-introduced memory leaks
* added five new Computer Language Benchmark Games to the examples/ directory
* improved operator precedence for '|', '^', '&', '<<', '>>', '..', and 'in'
* added the ability for a user to create overloads of the assignment operator
* implemented atomic variables using intrinsics for Intel and Cray compilers
* flipped the default nested parallelism policy via dataParIgnoreRunningTasks
* significantly improved the stability/generality of the LLVM back-end
* added a slurm-srun launcher for use with native SLURM and improved pbs-aprun
* added a 'make check' rule to the top-level Makefile to validate a build
* improved the symmetry of program startup and polling across the locales
* significant improvements to the testing system, esp. performance testing
* updates to the GASNet and GMP packages and new snapshots of hwloc and re2
* improved the code base's portability w.r.t. clang, gcc, Mac OS X, Debian 7.4
* numerous bug fixes (see 'Bug Fixes' below)

Packaging Changes
-----------------
* added a 'make check' rule to the top-level Makefile to validate a build
* removed the half-hearted support for Chapel syntax highlighting in emacs 21

Environment Changes
-------------------
* added a new CHPL_HWLOC environment variable to control the use of 'hwloc'  
  (see doc/README.chplenv)
* made CHPL_*_COMPILER default to 'clang' for CHPL_*_PLATFORM 'darwin'
* made CHPL_TASKS default to 'qthreads' when CHPL_LOCALE_MODEL == 'numa'
* made CHPL_HWLOC default to 'hwloc' when CHPL_TASKS = 'qthreads'
* established a 1:1 correspondence between CHPL_TASKS and CHPL_THREADS options
* deprecated the user-controlled CHPL_THREADS environment variable
* removed support for CHPL_TASKS=none due to lack of significant utility
* made GASNet use the 'large' segment by default for the 'ibv' conduit
* made CHPL_LAUNCHER default to 'gasnetrun_ibv' when using GASNet's mxm conduit  
  (see doc/README.launcher)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
* improved operator precedence for '|', '^', '&', '<<', '>>', '..', and 'in'  
  (see precedence tables in the 'Expressions' spec chapter or quick ref card)
* added the ability for a user to create overloads of the assignment operator  
  (see 'Statements' chapter in the language specification)
* added a 'noinit' capability to squash default initialization for basic types  
  (see 'Variables' chapter in the language specification)
* for a domain D, previously {D} == D; now it interprets it as 'domain(D.type)'
* added support for an expression-less 'serial' statement  
  (i.e., 'serial do' == 'serial true do')
* added support for dynamic casts of the 'nil' value, producing 'nil'  
  (see 'Conversions' chapter of the language specification)
* clarified that deleting a 'nil' value is OK and will have no effect  
  (see 'Classes' chapter of the language specification)
* added the ability to mark the 'this' as having 'ref' intent for methods  
  (see 'Classes' chapter of the language specification)

New Features
------------
* implemented support for the 'break' statement within param loops

Changes to the Implementation
-----------------------------
* dataParIgnoreRunningTasks is now 'false' by default for locale model 'flat'  
  (see doc/README.executing for details)
* changed the default size of the call stack size to 8 MiB for all task options  
  (see doc/README.tasks for details)

New Interoperability Features
-----------------------------
* extended c_ptrTo() to support 1D rectangular arrays
* added support for casts between c_ptr types

Standard Modules
----------------
* added support for abs() on imaginary types
* added isSubtype() and isProperSubtype() queries to the standard Types module  
  (see 'Standard Modules' chapter of the spec for details)

Documentation
-------------
* added descriptions of 'atomic' variables and 'noinit' expressions to the spec  
  (see the 'Task Parallelism and Synchronization' and 'Variables' sections)
* clarified specification of casting from numeric types to 'bool'
* reworked LICENSE files to clarify third-party licenses and isolate BSD text  
  (see LICENSE and LICENSE.chapel)
* refreshed and reorganized README.tasks
* documented that 'clang' is available as a CHPL_*_COMPILER option  
  (see doc/README.chplenv)
* improved description of Cray-specific runtime environment variables  
  (see doc/platforms/README.cray)
* clarified formatted I/O documentation regarding width/precision  
  (see doc/technotes/README.io)
* added a performance notes file (PERFORMANCE)
* removed the user agreement (AGREEMENT)
* generally refreshed README-based documentation
* general updates and improvements to the language specification

Example Codes
-------------
* added new Chapel ports of several Computer Language Benchmark Games (CLBG)  
  (see spectralnorm.chpl, mandelbrot.chpl, fannkuchredux.chpl, meteor.chpl,
   and pidigits.chpl in benchmarks/shootout/)
* added an improved/simplified version of the CLBG chameneos-redux example  
  (see benchmarks/shootout/chameneosredux.chpl)
* improved the release versions of RA to use atomic rather than sync vars
* made the examples/programs/tree.chpl example reclaim its memory
* made minor improvements to the MiniMD example and primer examples
* fixed a few incorrect statements in comments within primers/syncsingle.chpl

Cray-specific Notes
-------------------
* changed Cray XC Systems(TM) to use GASNet over the aries conduit by default
* added a slurm-srun launcher for use with Cray systems supporting native SLURM

Launcher-specific Notes
-----------------------
* added a slurm-srun launcher for use with native SLURM systems
* improved the pbs-aprun launcher for use with Moab/Torque
* made the gasnetrun_ibv launcher forward all CHPL_ environment variables
* made the 'aprun' launcher more careful about when it can correctly use '-j'

Portability of code base
------------------------
* improved code base's portability to newer versions of gcc
* improved code base's portability to Darwin/Mac OS X and Debian 7.4
* improved code base's portability for compilation with 'clang'
* enabled 'tcmalloc' to be built on Cray XC systems

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
* removed the --serial and --serial-forall flags; use serial statements instead
* started ignoring --static for Mac OS X since it isn't well-supported
* added a --print-passes-file flag to print passes to a specified filename

Error Message Improvements
--------------------------
* changed the wording of internal errors for succinctness

Performance Improvements
------------------------
* implemented atomic variables using intrinsics for Intel and Cray compilers
* optimized whole-array binary read/write operations for default domains/arrays
* extended global constant replication to additional types
* improved the compiler's ability to remote value forward values
* optimized away sublocale-related code for the 'flat' locale model
* improved 'numa' locale model performance for --local compilations)
* optimized blocking on sync variables for 'fifo' tasking based on # of tasks
* within serial sections, optimized forall loops over ranges, domains, arrays
* improved the task accounting for loops over Block-distributed arrays
* improved the loop-invariant code motion optimization's use of alias analysis
* removed unnecessary copies for formal arguments
* optimized program startup times in several ways

Locale Model Improvements
-------------------------
* improved the 'numa' locale model to reduce unnecessary changes in sublocale
* improved the 'numa' locale model's range, domain, and array iterators

Memory Improvements
-------------------
* reduced compiler-introduced memory leaks, particularly in I/O code
* reduced memory usage due to compiler-introduced copies on primitive types
* improved the reclamation of arrays of sync/single variables
* moved the end-of-program memory reporting to a point after the runtime exits

Third-Party Software Changes
----------------------------
* updated GASNet to version 1.22.0 with a patch to fix 'aries' conduit bugs
* added a snapshot of hwloc version 1.7.2 for compute node introspection
* added a snapshot of re2 (20140111) to the third-party directory
* added a snapshot of dygraphs to the third-party directory for perf graphs
* updated our snapshot of GMP to version 6.0.0
* various minor improvements to the Qthreads tasking layer
* disabled pshm for all non-udp GASNet conduits

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
* improved const-ness checking for const fields and const records/unions
* added a semantic check for tuple size mismatch when destructuring a tuple
* fixed a bug in which [u]int & imag literals were represented incorrectly
* fixed a bug where iterators with complex control flow could yield bad values
* fixed a bug in which timer.clear() did not reset the timer if it was running
* fixed a bug in which abs() on reals incorrectly called the complex version
* fixed a bug in converting between Chapel and C strings
* fixed a bug in which casts from ints/uints to bools were not always correct
* fixed some problems with the GMP random number routines
* fixed a bug on Cygwin for usernames with spaces in them
* extended global constant replication to additional types
* fixed a "read after freed" bug on domains used in nonblocking on calls
* fixed bug in loop invariant code motion related to aliasing in records/tuples
* fixed a subtle/minor race condition regarding accounting of tasks
* fixed Qthreads tasking layer bug resulting incorrect task placement
* fixed a bug in which Qthreads was asked for task-local storage prematurely
* fixed a potential race in task reporting (-t/--taskreport)
* fixed an optimization shortcut for array reindexing
* fixed a bug in which while loops warned about testing against local consts
* improved 'printchplenv' to avoid perl problems in unexpected cases

Runtime Library Changes
-----------------------
* improved the symmetry of program startup and polling across the locales
* improved descriptions of the runtime communication interface in chpl-comm.h
* simplified the implementation of the registry of global variables
* added ability for fifo tasks to implement thread-level storage using __thread

Generated Code Cleanups
-----------------------
* simplified the implementation of operations on homogeneous tuples
* removed the passing of wide strings by ref by default
* squashed the code generation of an unused program initialization function
* squashed redundant calls to initialize the ChapelStandard module
* folded out tautological comparisons between uints and 0s (e.g., myuint >= 0)

Compiler Performance
--------------------
* short-circuited the beautify pass if --savec is not specified
* short-circuited some logic in the parallel pass for --local compiles

Compiler Improvements
---------------------
* significantly improved the stability/generality of the LLVM back-end
* re-implemented copy propagation to handle aliases better
* made de-nested functions use 'const' arguments in more cases

Testing System
--------------
* added the ability to run multiple trials of each test to the testing system
* added support for sweeping current performance tests across past releases
* added the ability to track compiler performance during testing
* added a regexp-based correctness check capability for performance tests
* changed performance testing to support --fast by default
* added a script to splice .dat files created by performance testing
* permit SLURM to control the node list for parallel testing
* replaced 'paratest.server's -duplex flag with -nodepara for oversubscription
* added a capability to add annotations to performance graphs
* made performance testing compile with --static by default
* in generating performance graphs, the previous directory is now removed
* added a capability for the performance graphs to be rsync'd to SourceForge
* added a logarithmic/linear toggle to the generated performance graphs
* added a capability for the 'nightly' script to svn commit performance data
* added additional print messages to 'nightly' to better describe progress
* added a -retaintree option to 'nightly' to use the existing writable tree
* added support for testing the '--fast' flag in the 'nightly' script
* worked on making the testing system less Cray-centric in its design
* made test scripts send mail to the sourceforge mailing lists by default
* added options for naming test suites, specifying recipients, etc.
* unified the naming and structure of the cron job testing scripts
* removed reliance on tcsh-specific features for improved csh portability

Makefile Changes
----------------
* made all builds update Makefile dependencies, not just developer builds
* made Makefiles propagate CFLAGS/CXXFLAGS to third-party builds

Internal/Developer-oriented
---------------------------
* added dataPar* arguments to these() iterators for ranges/default rectangular
* made Block's leader iterator forward to DefaultRectangular
* made sure that arguments to exported functions are always local/narrow
* changed most assignment operator signatures to take the LHS by 'ref'
* added support for a "minimal modules" compilation mode for core language work
* added a developer flag --report-optimized-loop-iterators to track loop opts
* made internal errors appear as such in developer mode
* refactored the reference count code for domain maps, domains, and arrays
* switched to a symbolic initializer for locale IDs to improve flexibility
* refactored QIO and Regexp reference counting
* deprecated the internal InitPrivateGlobals module
* added config params to support program startup communication diagnostics  
  (see 'printInitVerboseComm' and 'printInitCommCounts')
* added a verification pass to ensure ref types for return types are available
* renamed NUM_KIND_FLOAT to NUM_KIND_REAL
* renamed 'Class'->'Aggregate' in the compiler sources when record|class|union
* switched to a bulk copy of flags when copying Symbol classes
* changed the representation of intents to support bitmasks
* moved the initialization of memory tracking from the modules to the runtime
* removed user-level memory leaks from example codes in the language spec
* created FLAG_COMPILER_GENERATED to separate functions/labels from FLAG_TEMP
* added PRIM_IS_ATOMIC_TYPE to query whether something is an atomic type
* added new primitives for querying whether a type is a tuple, sync, or single
* improved the internal use cases of 'printchplenv'
* removed redundant overloads of ==/!= for syserr and err_t
* improved the implementation when 'noRefCount' is true
* removed no-longer-necessary _ensure_reference_type() feature
* changed extern routines that take string arguments to take 'c_string' instead
* changed extern routines that take 'inout' arguments to 'ref' when appropriate
* numerous refactorings of the compiler code for clarity and/or efficiency



version 1.8.0
=============

Eleventh public release of Chapel, October 17, 2013

Highlights (see entries in subsequent categories for details)
-------------------------------------------------------------
- added initial support for user-defined locale models and a NUMA locale model
- added initial support for accessing HDFS file systems via files/channels
- improved tasking semantics w.r.t. references to variables from outer scopes
- added new example codes for MiniMD and the Computer Language Benchmark Game
- performance optimizations related to array base pointers, loop-invariant code
- removed a number of compiler-generated memory leaks
- added new types for interoperating with C: c_string, c_ptr(type), c_void_ptr
- improved support for small-int computations, ranges, domains, and arrays
- support for dygraph-based performance monitoring in the testing system
- updates to the GASNet, Qthreads, MassiveThreads, LLVM, and CLANG packages
- added a new 'cray-cs' platform to represent Cray Cluster Supercomputers
- made 'gemini' the default GASNet conduit for 'cray-xe' and 'cray-xk'
- added support for a SLURM + GASNet-over-Infiniband launcher

New Features
------------
- added initial support for specifying locale models ('hierarchical locales')  
  (see doc/technotes/README.localeModels)
- added support for a prototype NUMA locale model  
  (see doc/technotes/README.localeModels)
- added initial support for accessing HDFS file systems via files/channels  
  (see doc/technotes/README.hdfs)
- added new 'const in' and 'const ref' argument intents  
  (see the 'Argument Intents' section in the language specification)
- added built-in config params for all CHPL_* environment settings

Semantic Changes / Changes to Chapel Language
---------------------------------------------
- improved tasking semantics w.r.t. references to variables from outer scopes  
  (e.g., in 'var x=0; begin { ...x... }', 'x' is a const copy within the task)  
  (see 'Task Intents' section in the language specification)
- added 'ref' clauses to obtain the previous reference tasking semantics  
  (e.g., 'var x: int; begin ref(x) { ...x... }' causes '...x...' to refer to x)  
  (see 'Task Intents' section in the language specification)
- made blank intents for atomic variables get interpreted as 'ref'  
  (see the 'Argument Intents' section in the language specification)
- added support for ranges, domains/arrays with small-int index types  
  (e.g., 'range(int(8))' is now a supported type)
- added operator support for pairs of small int/uint types  
  (e.g., 'int(8) + int(8)' now generates an int(8) rather than int(32))
- added operator support for homogeneous tuple/scalar pairs  
  (e.g., (1,2,3) + 1 => (2,3,4))
- extended the member() method on domains to support varargs as well as tuples  
  (e.g., 'var D = {1..n, 1..n};' supports 'D.member(i,j)' and 'D.member((i,j))')
- the compiler now only creates '==' operators for matching record types
- made 'bool' types prefer dispatching to 'int' args over smaller-int options  
  (e.g., foo(true) will prefer to dispatch to foo(x:int) over foo(x:int(8)))

New Interoperability Features
-----------------------------
- added support for 'c_ptr(type)' and 'c_void_ptr' to refer to local C pointers  
  (see doc/technotes/README.extern)
- added support for a 'c_string' type to refer to local C char* pointers  
  (see doc/technotes/README.extern)

Deprecated Features
-------------------
- removed experimental GPU work to prepare for a revised approach to GPU support
- removed the callStackSize() query from the locale type
- removed certain config consts to control runtime arguments  
  (see "Flags on Generated Executables" section below)

Standard Modules
----------------
- added a new 'UtilReplicatedVar.chpl' standard module for replicated variables
- new 'HDFSiterator' and 'RecordParser' modules to help with parsing HDFS files

Documentation
-------------
- added a new README to describe the new locale model concept and NUMA model  
  (see doc/technotes/README.localeModels)
- added a new README.hdfs file to describe HDFS file system access in Chapel  
  (see doc/technotes/README.hdfs)
- made significant improvements to the README.cray file  
  (see doc/platforms/README.cray)
- refreshed the 'chpl' man page, particularly the SYNOPSIS/ENVIRONMENT sections
- refreshed the Chapel Quick Reference document
- major updates to the 'Task Parallelism' section of the spec for task intents
- made minor updates to several chapters in the language specification
- updated README.chplenv to reflect new CHPL_* environment variables
- minor updates to various README files

Example Codes
-------------
- added an initial port of the Mantevo MiniMD miniapp to Chapel  
  (see examples/benchmarks/miniMD)
- added Chapel ports of four codes from the Computer Language Benchmark Game  
  (see examples/benchmarks/shootout)
- fixed a bug in the atomics.chpl primer example
- cleaned up the beer.chpl example

Cray-specific Notes
-------------------
- added a new 'cray-cs' platform to represent Cray Cluster Supercomputers (CS)  
  (see doc/platforms/README.cray for more information)
- made 'gasnet' the default CHPL_COMM setting for all Cray platforms
- made 'gemini' the default GASNet conduit for 'cray-xe' and 'cray-xk' platforms  
  (see doc/platforms/README.cray)
- added support for the GASNet 'aries' conduit for the 'cray-xc' platform  
  (see doc/platforms/README.cray)
- made 'aprun' the default launcher for 'cray-x*' systems when available
- removed support for the 'xmt', 'x1', and 'x2' platforms and related features
- generated warning messages on cray-x* systems when no PrgEnv is loaded
- removed -target=linux flag from cray-prgenv-* compiler options

Launcher-specific Notes
-----------------------
- added support for a SLURM + GASNet-over-Infiniband launcher  
  (see 'slurm-gasnetrun_ibv' in doc/README.launcher)
- made the aprun-based launchers use the system's default number of CPUs
- brought the pbs launchers up-to-date with the current NCCS wrapper of qsub

Portability of code base
------------------------
- worked around a PGI portability issue with C structs in the generated code

Compiler Flags (see 'man chpl' for details)
-------------------------------------------
- added --[no-]warn-const-loops to control warnings about loops over constants
- added --[no-]loop-invariant-code-motion to enable/disable that optimization
- added --[no-]llvm-wide-opt to enable/disable LLVM wide pointer optimizations
- added warnings to '--[no-]serial' indicating its likely deprecation

Flags on Generated Executables
------------------------------
- replaced flags that govern runtime behavior with environment variables:  
    callStackSize       -> CHPL_RT_CALL_STACK_SIZE  
    commConcurrency     -> CHPL_RT_COMM_CONCURRENCY  
    numHardwareThreads  -> CHPL_RT_NUM_HARDWARE_THREADS  
    numThreadsPerLocale -> CHPL_RT_NUM_THREADS_PER_LOCALE  

Error Message Improvements
--------------------------
- improved const checking for actuals passed to out/inout/const ref/ref intents
- improved error messages for programs with bad type resolution cycles
- added a warning for while loops over constants
- errors for assignments to non-lvalues no longer halt compilation immediately

Performance Improvements
------------------------
- improved performance of local arrays by storing a shifted base pointer
- added a loop-invariant code motion optimization
- passed more things by value ('this', array/domain/domain map wrappers)
- made some improvements to the bulk copy optimization

Memory Leak Improvements
------------------------
- reduced memory leaked by strings by sharing them more aggressively
- improved support for destroying more automatic variables as they leave scope
- fixed a memory leak relating to inlining of iterators
- plugged memory leaks related to file types
- freed temporary buffers used for formatted I/O on complex values

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
- fixed bugs in extern blocks containing #define's
- fixed a bug when reading string literals that began with whitespace
- fixed a bug in which whitespace was written to binary files for array output
- fixed bugs related to writef() for complex values
- fixed size mismatches in IO code for 32-bit linux systems
- fixed a bug in the compareExchange implementation for atomic reals
- fixed bugs in Regexp convenience functions and the naming of string.split()
- fixed some bugs in BigInt functions in the GMP module
- fixed a bug in which AdvancedIterators would serialize if #chunks < #tasks
- fixed a bug related to 'ref' intents and the fast segment for GASNet
- fixed a bug related to using --make on the chpl command line
- bug fix for lost updates to fields of 'this' in certain scenarios
- fixed dead code elimination for blocks that are their own sole in-arc

Third-Party Software Changes
----------------------------
- updated to GASNet version 1.20.2 which improves the Cray native conduits
- updated to Qthreads version 1.10 and turned on support for stack overflow  
  (see reference to QT_GUARD_PAGES in doc/README.tasks for more information)
- updated to MassiveThreads version 0.95 with support for task-private data
- updated the LLVM back-end to use version 3.3 and packaged it with the release
- packaged CLANG 3.3 with the release rather than requiring a separate download

Runtime Library Changes
-----------------------
- made several interface changes to support locale models/hierarchical locales

Generated Code Cleanups
-----------------------
- declared non-exported symbols 'static' in generated code
- added support for targeting 'op=' operators in the back-end
- removed chains of unnecessary autocopy/autodestroy calls

Compiler Performance
--------------------
- disabled compiler internal verification by default to improve compile time

LLVM Back-end Changes
---------------------
- added wide pointer support for the LLVM back-end via CHPL_WIDE_POINTERS  
  (see doc/technotes/README.llvm and doc/README.chplenv)
- added support for LLVM-based communication optimizations via --llvm-wide-opt  
  (see doc/technotes/README.llvm)

Testing System
--------------
- changed performance graphing to use dygraphs
- added support for filing .bad files against futures to track behavior changes
- added support for setting environment variables on a per-test/-directory basis
- added the ability to use an external 'time -p' command for performance tests
- added directory-level PERFCOMPOPTS/PERFEXECOPTS files
- added a timeout feature for performance testing (separate from correctness)
- fixed a bug in which spec tests weren't being generated correctly
- added the capability for the test directory to clean itself up more thoroughly

Makefile Changes
----------------
- changed the naming scheme for intermediate object file directories
- added a 'cleanall' target between 'clean' and 'clobber'  
  (see README.building)
- made the 'clean' and 'cleanall' targets preserve a working installation
- accelerated the Makefile framework, particularly for no-op re-builds
- made the Makefiles smarter about rebuilding the compiler when necessary

Internal/Developer-oriented
---------------------------
- added a new 'createTaskFunctions' pass that creates functions defining tasks
- added a new 'resolveIntents' pass which resolves 'blank' and 'const' intents
- added a per-pass consistency/verification framework
- added a --verify compiler flag for running optional verification steps
- added an --ignore-errors-for-pass compiler flag for developers
- added a compiler analysis to compute dominators
- fixed a bug in isDefAndOrUse() for op= primitives
- rearchitected the QIO framework to support multiple file systems
- refactored the memory interface to better separate checking/tracking concerns
- switched to using 'ref' intents rather than 'inout' for I/O routines
- added "atomic type" flag for identifying atomic types to the compiler
- added "donor" function concept, making the callee responsible for deletion
- added "runtime type init fn" pragma to clarify overloaded "has runtime type"
- fixed a bug in which 'begin's in internal modules broke compilation
- restructured iterators so that not all yields would share the same variable
- improved cases where filename/line numbers aren't set correctly
- continued transition toward STL collections within the compiler
- added new capabilities to the bit vector class
- removed several instances of strcpy()s in the compiler
- added a functional interface for invoking remote functions by ID
- restructured #includes to avoid reliance on compiler-specific search policies
- added new features for debugging the compiler

Changes In Support of Hierarchical Locales
------------------------------------------
- made ranges and default rectangular domains/arrays use sublocales, if present
- made on-clauses get invoked through locale model module code in Chapel
- moved optimization of local on-clauses from the compiler to locale model code
- made task invocation flow through locale model module code written in Chapel
- mapped the tasking interface's support for hierarchical locales to Qthreads
- made hierarchical locale model compilations use wide pointers and on-clauses



version 1.7.0
=============

Tenth public release of Chapel, April 18, 2013

Highlights (see entries in subsequent categories for details)
-------------------------------------------------------------
- added support for regular expression operations on strings and channels
- added support for readf()/writef() routines for formatted I/O
- added support for injecting C declarations into Chapel via "extern blocks"
- added support for associative domain/array literals
- added a capability for main() to take arguments and return a status value
- added support for iteration over homogeneous tuples
- performance improvements related to stack-allocated and constant variables
- improved bulk transfer optimization (use -s useBulkTransferStride to enable)
- significant improvements to the Chapel version of LULESH
- enabled GMP using the system-installed version on Cray platforms by default
- switched to using processor atomics for reference counting on Cray systems
- numerous bug fixes and improvements to semantic checks and error messages

Environment Changes
-------------------
- renamed the platform 'cray-cascade' to 'cray-xc'
- renamed the platforms 'xmt'/'xmt-sim' to 'cray-xmt'/'cray-xmt-sim'
- enabled GMP support by default if it is already built in the third-party dir

Syntactic/Naming Changes
------------------------
- added support for associative domain/array literals  
  (e.g., {"red", "blue"} is an associative domain of strings)  
  (e.g., ["red" => 0, "blue => 1] is an assoc. array from strings to ints)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
- added support for injecting C declarations into Chapel via "extern blocks"  
  (see "Support for Extern Blocks" section of doc/technotes/README.extern)
- added support for iteration over homogeneous tuples  
  (see "Tuples" section of the Chapel spec)
- added a capability for main() to take arguments and return a status value  
  (see doc/technotes/README.main)
- added a 'requestCapacity()' capability to pre-size associative domains  
  (see "Domains:Predefined Functions" section of the Chapel spec)
- added a warning() routine to generate warnings, similar to halt(), assert()  
  (see "Standard Modules" section of the Chapel spec)

Newly Implemented Features
--------------------------
- added support for the .localSlice() method to take a domain argument  
  (e.g., A.localSlice({loRow..hiRow, loCol..hiCol}))

Deprecated Features
-------------------
- removed the tuple() function  
  (i.e., instead of tuple(x) or tuple(x,y,z), use (x,) or (x,y,z) instead)
- deprecated warning for old-style domain literals by default  
  (i.e., [1..m, 1..n] is an array of ranges; re-enable w/ --warn-domain-literal)

Standard Modules
----------------
- added support for regular expression operations on strings and channels  
  (see doc/technotes/README.regexp for details)
- added support for readf()/writef() routines for formatted I/O  
  (see doc/technotes/README.formattedIO for details)
- refactored communication diagnostics into its own module (CommDiagnostics)  
  (see doc/technotes/README.comm-diagnostics for documentation)
- added isDomainType(type t)/isArrayType(type t)/isRecordType(type t) queries

Documentation
-------------
- added README.formattedIO to describe support for writef()/readf() routines  
  (see doc/technotes/README.formattedIO)
- added README.regexp to describe support for regular expression operations  
  (see doc/technotes/README.regexp)
- added README.main to describe support for arguments/return values for main()  
  (see doc/technotes/README.main)
- updated README.extern to describe C type aliases and extern blocks
- changed READMEs that used csh-style syntax to use bash-style consistently
- fixed a semantic typo in README.atomics
- minor updates and fixes to various chapters in the language specification
- minor updates to several READMEs

Example Codes
-------------
- improvements to the Chapel implementation of LULESH  
  (see examples/benchmarks/lulesh/ for more details)
  - configuration improvements (see README for details):
    - added ability to compute the cube input set rather than reading from disk
    - support for 3D vs. 1D representations via 'use3DRepresentation'
    - support sparse vs. dense material representations via --sparseMaterials
    - added a --maxcycles config that can be used to stop the computation early
    - converted 'dtfixed' into a config const
    - added a per-iteration timing when doTiming and showProgress are enabled
  - code improvements:
    - refactored setup code into a helper module: luleshInit.chpl
    - changed the representation of nodesets to use a sparse subdomain
    - switched to using 'ref' intents rather than 'in' or 'inout'
    - converted vars to consts where appropriate
    - general code cleanup
  - performance improvements:
    - improved performance by avoiding an unnecessary reindexing operation
    - made some unnecessarily serial loops parallel
    - replaced error-oriented reductions with forall loops + halt
    - param-unrolled the loop in localizeNeighborNodes() for performance reasons
    - removed a redundant zero-initialization of an array
  - documentation improvements:
    - updated README to document new configuration options
    - added the LULESH callgraph to the README
- improved the Chapel implementation of RA:
  - added the ability to use an LCG random number generator via 'useLCG'
  - added a config const 'verify' that permits verification to be skipped
- fixed a typo in HPL that inflated the calculated GFLOPs by 10x
- improvements to the Chapel implementation of SSCA2:
  - fixed a bug in the torus representation
  - fixed a bug with VALIDATE_BC=true

Platform-specific Notes
-----------------------
- enabled GMP using the system-installed version on cray-x* platforms by default

Portability of code base
------------------------
- fixed an issue related to vsnprintf on OS X Lion
- fixed an assumption that platforms defining INT8_MIN will also define INT*_MIN

Launcher-specific Notes
-----------------------
- improved use of cnselect in launchers that use 'aprun'

Compiler Flags
--------------
- added --no- variants of the following compiler flags: --count-tokens, --llvm,
    --print-code-size, --print-commands, --print-passes, --print-search-dirs,
- added --[no-]warn-tuple-iteration to warn against old-style zipper iteration  
  (see man page for details)
- added --[no-]warn-special as a meta-flag for all old-style syntax uses  
  (see man page for details)
- improved support for environment variable setting of '--no-'style flags  
  (see man page for details)

Error Message Improvements
--------------------------
- improved type mismatch error messages when assigning scalars to arrays
- added an error for extern functions with formal arguments of array type
- made Ctrl-C and the like result in a user, rather than internal, error
- added an error for associative domains with unsupported index types

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
- fixed a bug in which sizeof() had leaked into the user namespace in v1.6
- fixed a regression in v1.6 in which type aliases of arrays were broken
- fixed a bug in which 0-element arrays of arrays would free domains prematurely
- fixed a bug related to writing out instances of the RandomStream class
- I/O bug fixes:
  - QIO_HINT_PARALLEL now works for new/zero length files
  - fixed bugs related to bit-oriented reads and writes
  - fixed a bug w.r.t. EOF and preemptive mmap
  - fixed portability bug related to Intel compilers
  - changed channels so that once EOF is hit, it will never read further
  - fixed issues related to ssize_t/int(64) mismatches on 32-bit platforms
  - fixed an issue related to reading empty strings
- fixed some bugs in the implementation of atomic variables
- fixed a bug in which AdvancedIters didn't default 'numTasks' as documented
- improved shape checking for array assignment
- restricted reshape() to be applied for rectangular domains only
- restricted reshape() to only work when the source and destination sizes match
- improved support for Cyclic distributions of idxType uint(64)
- fixed INFINITY and NAN to be of type 'real' rather than 'real(32)'
- fixed a bug with '/*/' within a nested comment
- fixed a bug in which uses of ** would dispatch to a user's pow() overload
- fixed a few bugs in the Buffers.chpl module
- fixed a bug in which memory leak tracking would mislabel some allocations
- fixed a bug with recursive iterator inlining
- fixed a bug in broadcasting large values at program startup

Packaging Changes
-----------------
- added Chapel mode support for emacs version 23.x (see etc/emacs/README)

Performance Improvements
------------------------
- switched to using processor atomics for reference counting on Cray systems
- improved bulk transfer optimization (use -s useBulkTransferStride to enable)
- put fewer variables on the heap in the presence of nested functions
- enabled remote value forwarding for more constants/arguments than before
- made atomic variables use compiler intrinsics for cray-prgenv-intel
- made associative domains of 'imag' indices more efficient

Runtime Library Changes
-----------------------
- split chpl_task_begin() to distinguish between new tasks and migrating ones
- improved the ability to build the Chapel runtime with a C++ compiler

Third-Party Software Changes
----------------------------
- updated to version 1.20 of GASNet
- updated to version 1.9 of Qthreads
- made the LLVM checkout script grab version 3.2 to ensure compatibility
- removed the nanox tasking layer due to lack of support/champion

Testing System
--------------
- extended the 'skipif' capability to support the ability to skip a subdirectory
- improved the robustness of start_test in cross-compiled environments
- added support for .no-local.good files for --no-local-specific test output
- fixed a bug in which the test system looked at incorrect .future files
- removed artificial limiting of stacksize in start_test
- refactored test system environment setup into util/test/testEnv
- made the test system use $cwd rather than 'pwd'
- made 'nightly' compopts/execopts get added to end of the command line
- made 'nightly' support a --no-futures option

Internal/Developer-oriented
---------------------------
- added some code that sets the groundwork for supporting hierarchical locales
- fixed portability of bswap.h (for once and for all?)
- restructured internal modules corresponding to specific runtime layers
- removed uses of alloca()
- removed PRIM_CHPL_ALLOC_PERMIT_ZERO
- deprecated 'make depend' and made use of gcc -MMD/-MP instead
- made 'rm -rf' commands a little safer in Makefile clean/clobber rules
- refactored Makefiles for Cray systems/compilers to avoid repetition
- added a map_view() function for printing out SymbolMaps
- removed some dead and possibly incorrect methods from Map and Vec classes
- refactored _cast functions for booleans
- made the _isPrimitiveType test more concise
- improved the mechanism by which line numbers are assigned to AST nodes
- factored sync/single out of ChapelBase.chpl and into ChapelSyncvar.chpl
- fixed the --gen-extern-prototypes flag
- improved the correspondence of FLAG_* and string forms of AST flags
- improved the correspondence of PRIM_* and string forms of primitives
- refactored chplrt.h
- added initial support for a .localAccess accessor to Block/Default arrays
- renamed compiler-generated types for classes in generated code
- refactored QIO code in the runtime
- converted macros in the compiler to inline functions for sanity/performance
- cleaned up the functions that build array/domain literals
- refactored and commented lowerIterators.cpp
- keep dtObject alive even if unused after function resolution
- added EOF to the list of reserved symbol names
- protected some C identifiers introduced by PGI when compiling with -Kieee



version 1.6.0
=============

Ninth public release of Chapel, October 18, 2012

Highlights (see entries in subsequent categories for details)
-------------------------------------------------------------
- syntax improvements:
  - added support for array literals using square brackets
  - improved domain literals to use curly brackets to suggest set notation
  - changed zippered iteration to use an explicit 'zip' keyword
- improved atomic variables: new methods, support for floating point atomics
- added support for 'ref' intents to support pass-by-reference arguments
- added support for user overloads of 'op=' and '<=>' assignments
- added a prototype of 'chpldoc', a code-based documentation feature
- added support for using LLVM as a back-end compiler target rather than C
- added support for a strided bulk communication optimization
- numerous performance improvements and bug fixes
- significant improvements to the SSCA2, RA, and LULESH example codes
- added a new tasking runtime that uses U Tokyo's MassiveThreads library
- network-based atomic variables for users of the Chapel module on Cray systems
- improved support for the Tilera chip architecture

Environment Changes
-------------------
- made compiler infer CHPL_HOME if unset, or complain if mis-set
- made util/setchplenv.* scripts more cleanly re-runnable
- added new platforms: 'cray-cascade' and 'cray-xk'  
  (see doc/platforms/README.cray)
- renamed 'xe-cle' and 'xt-cle' to 'cray-xe' and 'cray-xt', respectively
- renamed Cray PrgEnv compiler settings to be more platform-independent  
  (e.g., 'cray-xe-cray'/'cray-xe-gnu' -> 'cray-prgenv-cray'/'cray-prgenv-gnu')
- made CHPL_MEM default to 'tcmalloc' when CHPL_COMM is 'ugni'
- made CHPL_ATOMICS default to 'intrinsics' for CHPL_TARGET_COMPILER=PrgEnv-gnu

Syntactic/Naming Changes
------------------------
- changed domain literals to use curly brackets rather than square brackets  
  (e.g., '[1..n, 1..n]' would now be written '{1..n, 1..n}')
- introduced array literals using square brackets  
  (e.g., '[3, 5, 7, 11]' describes an array of type '[1..4] int')
- added a 'zip' keyword to express zippered iterations rather than using tuples  
  (e.g., 'for (a,b) in (A,B)' is now written 'for (a,b) in zip(A,B)')
- added a bidirectional I/O operator (<~>) for reading from/writing to channels  
  (e.g., 'myChannel <~> myStr;' will read/write 'myStr' from/to 'myChannel')
- added support for creating one-tuples using the syntax (x,)  
  (e.g., '(1.0,)' describes a tuple of type '1*real')
- re-established the underscore as the means of ignoring a tuple component  
  (e.g., '(x,,z)' would now be written '(x,_,z)')

Semantic Changes / Changes to Chapel Language
---------------------------------------------
- added support for 'ref' intents, supporting pass-by-reference arguments  
  (e.g., 'proc foo(ref x: int) ...' passes an int arg to 'foo' by reference)
- improved support for atomic variables
  - added support for floating point atomic types  
    (e.g., 'var x:atomic real;')
  - added waitFor(val) method  
    (e.g., 'x.waitFor(1.0)' would wait for x to hold the value 1.0)
  - added non-fetching variations of operations to avoid excess communication  
    (e.g., 'x.add(1)' is like 'x.fetchAdd(1)' but doesn't return a value)
  - added compareExchange() method as a shorthand for compareExchangeStrong()
- added support for user-defined overloads of '<=>' and 'op=' assignments  
  (e.g., 'proc <=>(ref x: t, ref y: t) ...' or 'proc +=(ref lhs:t, rhs:t) ...')
- added a '.size' method to arrays, domains, strings, and ranges
- made enum types behave more similarly to param ints (or collections thereof)
- removed certain expression forms as being valid types or standalone stmts

Newly Implemented Features
--------------------------
- added a prototype implementation of a code-based documentation feature  
  (see doc/technotes/README.chpldoc)
- added an LLVM-based back-end  
  (see doc/technotes/README.llvm)
- added support for degenerate reindexing of non-rectangular arrays

Deprecated Features
-------------------
- removed the '_extern' keyword; use 'extern' instead
- removed the ability to use blanks to drop tuple components -- use '_' instead

Standard Modules
----------------
- made Dimensional Block Cyclic distributions support non-default index types
- added HeapSort() to the standard Sort module
- added the ability to clear() timers without stopping them

Documentation
-------------
- added README.llvm to describe new LLVM back-end option  
  (see doc/technotes/README.llvm)
- added README.chpldoc to describe new chpldoc documentation option  
  (see doc/technotes/README.chpldoc)
- updated README.atomics to describe new capabilities for atomic variables
- added doc/platforms/README.tilera to describe using Chapel with Tilera chips
- noted that Python and bc are now required features to build Chapel  
  (see doc/README.prereqs and doc/platforms/README.cygwin)
- updated README.extern to utilize 'ref' intents rather than 'inout'
- updated language specification to describe new features and syntax changes
- minor updates and fixes to several chapters of the language specification
- updated the Quick Reference to illustrate new syntax, features
- improved command-line help for -d option
- minor updates to several READMEs

Example Codes
-------------
- extensive revisions to SSCA#2 including:
  - extensive performance and memory improvements
  - improved ability to 'make' with different options from the command line
  - changed the neighbor list representation to use 1D arrays of 2-tuples
  - added ability to read/write graphs from/to files in setting up
  - added support for distributed/parallel graph construction
  - fixed a bug in the TEPs computation when starting from a subset of vertices
  - added the ability to skip various kernels via configs
  - optimized and fixed a bug in the generation of filtered edge lists
  - converted uses of sync variables to atomic variables
- improvements to RA:
  - extended ra.chpl to use either on-clauses or direct array accesses
  - made verification updates lossless using synchronization variables  
    (see examples/benchmarks/hpcc/ra.chpl)
  - added a lossless version of RA that uses atomic variables  
    (see examples/benchmarks/hpcc/ra-atomics.chpl)
- improvements to LULESH
  - replaced 'sync' variables with 'atomic's
  - converted a global array into tuples to minimize communication
  - general code cleanup improvements
- examples/primer/ updates:
  - added a new primer to demonstrate the --docs/chpldoc capability  
    (see examples/primers/chpldoc.chpl)
  - updated atomic_vars.chpl primer to reflect recent changes
  - updated arrays.chpl primer to reflect array literal syntax
- updated all examples to reflect syntax changes

Platform-specific Notes
-----------------------
- improved support for the Tilera chip architecture  
  (see doc/platforms/README.tilera)
- added support for Cray Gemini- and Aries-based atomics to the ugni comm layer  
  (see doc/platforms/README.cray)

Launcher-specific Notes
-----------------------
- improved error handling of failed forked processes
- for aprun-based launchers:
  - made '-cc none' the default mode used
  - added -j option to aprun (for supported versions)
- for the pbs-aprun launcher:
  - fixed a timing bug
  - added a flag --generate-qsub-script

Compiler Flags
--------------
- added --docs and related flags for generating documentation for Chapel code  
  (see doc/technotes/README.chpldoc)
- added a --gen-extern-prototypes flag to cross-verify extern prototypes
- added an --llvm flag for targeting LLVM as the back-end compiler  
  (see doc/technotes/README.llvm)

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
- fixed a bug with type-inferred module-level domains/arrays
- fixed a bug relating to strings on distributed memory 32-bit platforms
- improved support for uint idxTypes in domains and arrays
- improved the ability to use user-defined constructors in derived classes
- fixed a bug in which the block-cyclic distribution didn't support 1D domains
- fixed several bugs in I/O:
  - one related to using stdin on Mac OS X
  - one related to bitwise writing
  - one related to writing to/reading from a Writer/Reader from a remote locale
  - one related to issues on Cygwin
- fixed a bug in which classes were improperly considered unused and removed
- fixed a bug in tcmalloc when computing reallocation growth and shrinkage

Packaging Changes
-----------------
- simplified the etc/emacs/ directory organization to avoid duplication  
  (emacs users may need to update their .emacs settings -- see etc/emacs/README)
- added a 'chpldoc' alias to the 'chpl' compiler to just generate documentation
- added setchplenv.fish to the release (intended for 1.5.0, but mis-packaged)
- made the subdirectories used to store object files more unique

Performance Improvements
------------------------
- added a strided bulk communication optimization, disabled by default  
  (to enable, compile with -s useBulkTransferStride)
- replaced internal sync var counters with atomics when appropriate
- made initialization of remote array access caches lazy to reduce setup time
- removed a level of pointer indirection in the implementation of array data
- reduced the runtime cost of creating array aliases
- optimized reindexing for the case when the original and new domains match
- optimized the performance of equality/inequality on identical domains
- made most associative domain/array ops to occur on the owning locale
- enabled remote-value forwarding of array descriptors in the presence of syncs

Runtime Library Changes
-----------------------
- added support for MassiveThreads-based tasking (courtesy U Tokyo)  
  (see doc/README.tasks)
- added the ability to implement atomic variables using network-based AMOs
- made counters used for communication diagnostics 64 bits to avoid overflow
- turned off the cooperative comm/task non-blocking get interface for GASNet

Third-Party Software Changes
----------------------------
- updated Qthreads to version 1.8
- updated GASNet to version 1.18.2
- added MassiveThreads 0.3beta to the third-party directory
- added a directory to download creoleparser into for use with chpldoc  
  (see doc/technotes/README.chpldoc)

Testing System
--------------
- reordered the order in which execution options are passed to tests  
  (see #comments at top of start_test for details)
- added a 'lastexecopts' capability to require an execution option to come last
- improved the 'timedexec' script to kill the child's process group

Internal/Developer-oriented
---------------------------
- significantly refactored the code generation pass
- began the process of replacing homegrown ADTs with STL classes
- removed pragma "inline" (use 'inline' keyword instead)
- renamed some primitives: 'get ref' -> 'deref' and 'set ref' -> 'addr of'
- fixed type-punned pointers in comm-gasnet.c
- fixed a case of deleting global type symbols prematurely
- fixed a use-before-def warning for default-initialized vars of extern type
- added consistency checking to basic block analysis
- made use of BLOCK_TYPE tag more consistent
- reduced reliance on primitives and locale internals in standard modules



version 1.5.0
=============

Eighth public release of Chapel, April 19, 2012


Highlights (see entries in subsequent categories for details)
-------------------------------------------------------------
- completely revamped and improved Chapel's I/O features
- added support for atomic bool/int/uint variables to Chapel
- added a version of the LLNL/DARPA LULESH benchmark
- improved GMP support for integer types
- added an initial implementation of a 2D Dimensional distribution
- added Cray XE (TM)-specific tasking/thread/communication layers for
  the Cray XE module (binary only)
- updated GASNet from 1.16.2 to 1.18.0 which includes initial ugni support
- made integers default to 64-bits in most contexts rather than the previous 32-bits
- numerous performance improvements, bug fixes, and documentation improvements

Environment Changes
-------------------
- added support for fish shell users (http://fishshell.com)  
  (see $CHPL_HOME/README and $CHPL_HOME/util/setchplenv.fish)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
- completely revamped and improved Chapel's I/O features  
  (see examples/primers/fileIO.chpl, doc/technotes/README.io, I/O spec chapter)
- added support for atomic bool/int/uint variables to Chapel  
  (see doc/technotes/README.atomics, examples/primers/atomics.chpl)
- added support for /* ... */-style comments to be nested  
  (e.g., /* in comment! /* in nested comment! */ still in comment! */)
- made integers default to 64-bits in most contexts rather than the previous 32-bits
  - integer literals are now of type int(64)/uint(64) by default
  - the default 'int'/'uint' types now correspond to int(64)/uint(64)
  - the default idxType for ranges, domains, and arrays is now int(64)
  - a number of locale-oriented capabilities now use/return 64-bit ints:
    - numLocales, LocaleSpace, locale.id
    - locale.numCores, locale.callStackSize
    - numThreadsPerLocale, maxThreadsPerLocale
    - locale.*Threads(), locale.*tasks()
- the 'by' and '#' operators now accept int(w)/uint(w) args for w-bit idxTypes
- param arguments now play a role in disambiguation between function overloads  
  (see the 'Function Resolution' section in the Chapel language specification)

Newly Implemented Features
--------------------------
- added an initial implementation of a 2D Dimensional distribution  
  (see examples/primers/distributions.chpl)
- added support for reading arrays, domains, ranges, and tuples  
  (e.g., var A:[1..10] real;  read(A); )
- added support for an iterator's arguments to have intents
- added a new getCommDiagnosticsHere() routine for querying local communications  
  (see doc/technotes/README.comm-diagnostics)

Deprecated Features
-------------------
- removed support for tensor iteration from the Chapel compiler  
  (e.g., 'forall (i,j) in [foo(), bar()]' no longer supported; use nested loop)
- removed volatile types in favor of atomic types
- removed the ability to use 'def' to define functions; use 'proc' or 'iter' now

Standard Modules
----------------
- improved GMP support for integer types  
  (see doc/technotes/README.gmp)
- changed sgn() in Math.chpl to return an int(8)/uint(8)

Documentation
-------------
- major updates to the I/O chapter of the spec to reflect new capabilities
- added a new technical note describing support for atomic types  
  (doc/technotes/README.atomics)
- revamped technical notes for I/O and GMP to reflect revamped features  
  (doc/technotes/README.io, doc/technotes/README.gmp)
- minor updates to several other chapters of the language specification
- minor fixes and updates to several READMEs

Example Codes
-------------
- added a version of the LLNL/DARPA LULESH benchmark  
  (see examples/benchmarks/lulesh/README)
- numerous updates to the Chapel version of SSCA#2
  - store visited children in forward pass to avoid recomputing in backwards
  - use hand-coded task-private variables to store private variables
  - replaced arrays of sync vars with arrays of atomics in most instances
  - fixed a number of on-clauses that referred to a poor choice of locale  
  (see examples/benchmarks/ssca2/README)
- updated hpcc/hpl.chpl to use Dimensional distributions and replicated storage
- moved ssca2 and hpcc examples into a new benchmarks/ subdirectory
- fixed some bugs in hpcc/hpl.chpl
- in ra.chpl, copied manual optimizations from timed loop into verification loop
- updated the arrays.chpl primer to deprecate tensors and improve explanations

Platform-specific Notes
-----------------------
- added Cray XE-specific tasking/thread/communication layers to the
  Cray XE module (available using 'module load chapel', see
  doc/platforms/README.xe-cle-system-specific-layers)
- fixed GASNet executions on Mac OS X Lion
- generated C identifier lengths are now capped to avoid PGI warnings

Compiler Flags
--------------
- added --max-c-ident-len to cap the length of C identifiers in generated code

Error Message Improvements
--------------------------
- in most contexts, the compiler now prints out a fully-specified type  
  (e.g., where before it printed 'int', it now prints 'int(64)')
- line number reporting has been improved in certain cases

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
- added a compile-time error for incorrect domain slicing cases
- fixed an issue in which users couldn't use 'this' as an identifier
- fixed the ability to delete an object located on a remote locale
- fixed a non-deterministic seg fault for parent classes with types/params only
- fixed a race condition in the implementation of halt()
- fixed an issue in which a .exe filename could not be specified using -o
- the --explain-calls flag now properly displays 'param' intents as such
- protected a user's ability to name variables j0, j1, jn, y0, yn

Performance Improvements
------------------------
- changed array/domain reference counting to use atomics rather than syncs
- made Chapel allocation/free routines inline to reduce overheads
- optimized local on-clauses to reduce overheads by avoiding chpl_comm_fork()
- optimized bulk transfers for Block-distributed arrays that share a domain
- optimized the creation of simple Block- and Cyclic- array aliases

Runtime Library Changes
-----------------------
- no longer count communication threads against numThreadsPerLocale for pthreads
- removed assumption that globals in generated code will have identical addrs
- added support for keeping builds for multiple GASNet segments in one tree
- moved most Chapel module initialization from main() to first task
- simplified the tcmalloc memory layer to support use with GASNet
- added dlmalloc support for communication layers other than GASNet-fast
- broke GASNet AM_signal handler request/reply to use short messages
- fixed a bug in which non-blocking gets could seg-fault
- simplified the initialization and shutdown of the communication layer
- fixed a potential race in broadcasts at program startup

Third-Party Software Changes
----------------------------
- updated GASNet from 1.16.2 to 1.18.0 which includes initial ugni support
- made third-party packages build automatically when needed by the runtime
- updated Qthreads from version 1.7.0 to 1.7.1
- added support for a UTF-8 decoder from Bjoern Hoehrmann for use in the new I/O
- added support for Nanos++ tasking to yield when firing off an active message
- added support for the 'serial' statement to Nanos++ tasking layer
- turned off tcmalloc's tendency to print messages for large allocations

Testing System
--------------
- added the ability for a skipif file to check for substrings in an env. var.
- fixed several bugs in the testing system:
  - when using named .good files in compopts files
  - when using multiple compopts files and no execopts files
  - in the generation of performance data filenames
- condensed how compilation/execution options are identified in testing logs
- added a --logtmp flag to start_test to support single-node parallelism

Internal/Developer-oriented
---------------------------
- fixed an issue in which internal modules resulted in too many circularities
- changed module initialization code so that modules initialize those they use
- added a pragma to control implicit inclusion of ChapelStandard.chpl
- added support for automatically mapping external C types to Chapel types
- added the ability to dump the compiler IR using a text-file format
- added filenames back into the BaseAST class to preserve info during inlining
- added chpl__unsignedType(), chpl__maxIntTypeSameSign() utility functions
- added a typeToString() overload to catch common error cases
- removed debugWrite* capability
- fixed a bug in the compiler's basic block analysis framework
- made existing tests much less sensitive to ordering of output
- added a --[no-]preserve-inlined-line-numbers flag to control inlining behavior
- added a "no instantiation limit" pragma/flag to the compiler
- added an isParameter() method to the ArgSymbol class
- removed strcmps against types to normalize scalar type queries (e.g., int(?w))
- made several refactorings to functionResolution.cpp
- refactored common flag queries into helper query functions
- refactored creation of wrapper functions
- fixed get_int()/get_uint() to avoid reliance on underspecified C int sizes
- made external classes less like Chapel classes within the Chapel compiler
- cleaned up the memory tracking enums associated with the communication layer
- removed chpl_error_noexit primitive
- added code to trace through the disambiguation logic of function resolution
- refactored Makefiles, replacing CHAPEL_ROOT with CHPL_MAKE_HOME
- made third-party/*/Makefile rules more consistent



version 1.4.0
=============

Seventh public release of Chapel, October 20, 2011

Highlights (see below for details)
----------------------------------
- added 'extern', 'export', and 'inline' keywords
- new optimizations for whole-array assignments and remote array accesses
- improved support for Qthreads and Nanos++ tasking, including multi-locale
- added dynamic range iterators via an 'AdvancedIters' module
- continued improving range semantics and implementation
- added support for # operator on dense rectangular domains and arrays
- made associative domain index modifications parallel-safe
- added --static/--dynamic linking flags
- improved communication diagnostics capabilities
- new example codes: SSCA2; primers on sync vars, leader-follower iterators
- updated documentation
- many bug fixes

Syntactic/Naming Changes
------------------------
- renamed '_extern' keyword to 'extern'
- renamed 'maxThreadsPerLocale' to 'numThreadsPerLocale'  
  (see doc/README.tasks and doc/README.executing for new definitions)
- made it illegal for a string literal to contain an unescaped newline
- renamed dsiIndexLocale to dsiIndexToLocale in domain map standard interface  
  (see doc/technotes/README.dsi)
- reserved 'ref' as a keyword for future use
- renamed 'iterator' enumeration to 'iterKind' for leader-follower iterators
- renamed 'follower' argument to follower iterators 'followThis'

Semantic Changes / Changes to Chapel Language
---------------------------------------------
- added 'export' keyword to support calling Chapel functions from C
- added 'inline' keyword to force a function to be inlined
- added support to # operator for dense rectangular domains and arrays
- removed support for tensor iteration from the language definition
- removed the realm concept from the language
- ambiguous ranges are now == if their representations match
- disabled promotion of the '..' operator

Newly Implemented Features
--------------------------
- improved qthreads and nanox task layers to support multilocale execution  
  (see doc/README.tasks)
- adding and removing indices from associative domains is now parallel-safe
- updated the communication diagnostics interface  
  (see doc/technotes/README.comm-diagnostics)

Standard Modules
----------------
- added an 'AdvancedIters' module with various dynamic scheduling algorithms
- added floor/ceiling/mod functions for integers to 'Math' module
- added new sorting routines to standard 'Sort' module
- added a 'UtilMath' module with other integer ceiling/floor functions
- added a param version of abs() for integers to 'Math' module

Documentation
-------------
- spec updates:
  - added a new chapter on 'Interoperability'
  - refreshed 'Data Parallelism', 'Task Parallelism', and 'Conversions' chapters
  - updated 'Ranges' chapter significantly
  - minor updates to 'Domains', 'Arrays', and 'Classes' chapters
  - split 'Memory Consistency Model' into its own chapter (still poorly defined)
  - documented new Advanced Iterators and Sort routines in 'Standard Modules'
- added documentation about the compiler's module search path to man page/technotes  
  (see 'man chpl' and doc/technotes/README.module_search)
- added note about parallel safety to doc/technotes/README.extern
- generally refreshed README* and other text-based documentation files

Example Codes
-------------
- added a(n in-progress) implementation of SSCA2 to the release examples  
  (see examples/ssca2)
- added a primer for sync and single variables  
  (see examples/primers/syncsingle.chpl)
- added a primer on leader-follower iterators (user-defined forall scheduling)  
  (see examples/primers/leaderfollower.chpl)
- added an example of creating a private locale view to distributions primer  
  (see examples/primers/distributions.chpl)
- improved the ranges primer  
  (see examples/primers/ranges.chpl)
- added a description of subdomains to the domains primer  
  (see examples/primers/domains.chpl)
- minor wordsmithing for the procedures primer  
  (see examples/primers/procedures.chpl)

Platform-specific Notes
-----------------------
- improved Makefile settings for IBM/AIX platforms and compilers

Feature Improvements
--------------------
- several improvements to the implementation of ranges  
  (see 'Ranges' chapter of spec for details)
- made casts-to-string produce the same string as write() does

Compiler Flags
--------------
- added --static/--dynamic flags to specify how the binary should be linked

Interoperability Changes
------------------------
- made 'extern' a keyword; '_extern' is deprecated

Error Message Improvements
--------------------------
- added a compiler warning for param functions with declared return types
- improved a few other difficult compiler error messages

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
- fixed the result widths of complex math operations
- improved parsing of escaped characters in string literals
- deleting a record now generates an error
- added a variety of bug fixes for range operations
- fixed a bug with passing strings to external functions for --no-local cases
- fixed a bug for var functions that returned nothing
- fixed a bug related to terminating a CHPL_COMM=gasnet program early
- fixed a bug in which ref temps were not inserted for virtual method calls
- fixed a bug related to removing a label from the AST but not its goto
- fixed bug with applying serial statement to optimized coforall+on loops
- fixed bugs regarding single variables not being treated like sync
- fixed a bug related to incorrect complaints about ambiguous module paths
- fixed a bug related to followers accepting empty ranges
- fixed a few reference-after-deallocation bugs in the compiler
- fixed a bug related to flattening var functions multiple times

Packaging Changes
-----------------
- removed the second-level 'chapel/' directory that releases used to have
- updated emacs/vim modes to bring syntax up-to-date
- util/setchplenv.* scripts now permit $CHPL_HOME to be other than 'chapel'
- added the util/ directory to PATH in the setchplenv.* scripts
- improved make 'clean' and 'clobber' rules for third-party directories

Third-Party Software Changes
----------------------------
- removed requirement to specify LD_LIBRARY_PATHs for qthreads and nanox tasks
- updated to GASNet version 1.16.2 (see third-party/gasnet/README)
- updated Qthreads to version 1.7 (see third-party/qthreads/README)
- added tcmalloc version 1.7 (see third-party/tcmalloc/README)
- updated dlmalloc to version 2.8.5

Runtime Library Changes
-----------------------
- split the 'none' task layer into 'none' and 'minimal'  
  (see doc/README.tasks)
- added a tcmalloc-based memory layer to the runtime
- improved program initialization order and sequence
- made nanox/qthreads task layers use a #threads==#cores by default
- increased the default callstack size for qthreads tasks
- removed pthread calls from the gasnet communication layer
- began process of unifying runtime file and directory names
- standardized our threading layer interface
- made tasking layers more robust to early calls during program setup
- moved Chapel code in the runtime/ directory into internal modules

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- added a block transfer optimization for whole-array assignment
- reduced the number of communications for remote Block or Cyclic array access
- added an optimization to remove dead code blocks

Testing System
--------------
- valgrind testing with CHPL_COMM!=none now valgrinds the child processes

Internal
--------
- the threading layer of the runtime now has its own header file
- added a --library flag for creation of a standalone Chapel library
- made normalize_returns() able to be called multiple times
- fixed a bug related to internal module dependencies of depth > 2
- added capabilities to help debug deleted AST nodes  
  (see --break-on-delete-id and --log-deleted-ids-to)
- removed --runtime flag from compiler
- added a compilerAssert() capability



version 1.3.0
=============

Sixth public release of Chapel, April 21, 2011

Highlights (see below for details)
----------------------------------
- split 'def' keyword into 'proc' (for procedures) and 'iter' (for iterators)  
  (see '$CHPL_HOME/util/convert-defs --help' for help updating existing codes)
- added 'Replicated' distribution and improved 'Block-Cyclic' distribution  
  (see "Standard Distributions" in spec and examples/primers/distributions.chpl)
- added single-locale task layers for Nanos++ (BSC) and Qthreads (Sandia)  
  (see doc/README.tasks)
- major reworking of range semantics and implementation  
  (see "Semantic Changes / Changes to Chapel Language" below for detail)
- initial support for volatile types: bool, int, uint, real, imag  
  (see doc/technotes/README.volatile)
- support for extern consts and classes (pointers-to-structs)  
  (see doc/technotes/README.extern)
- improved support for data parallelism on the Cray XMT
- extensive improvements to the sample codes in the examples/ directory  
  (see 'Example Codes' below and examples/README)
- added most code examples from the spec to a new examples/ directory  
  (see examples/spec/*)
- added a technical note describing the user-defined domain map interface  
  (see doc/technotes/README.dsi)
- extensive updates to the language specification  
  (see 'Documentation' below)
- several improvements to the runtime tasking and communications layers  
  (see "Runtime Library Changes" below)

Syntactic/Naming Changes
------------------------
- split 'def' keyword into 'proc' (for procedures) and 'iter' (for iterators)  
  (see '$CHPL_HOME/util/convert-defs --help' for help updating existing codes)
- renamed 'arithmetic' domains/arrays to 'rectangular' domains/arrays
- added support for floating point literals of the form '1.e...'  
  (previously, only '1e...' and '1.0e...' were supported)

Semantic Changes / Changes to Chapel Language
---------------------------------------------
- several improvements to ranges (see 'Ranges' chapter in the language spec):
  - added a concept of alignment to indicate an alignment modulo |stride|
  - added an 'align' operator and query to ranges to specify/query alignment  
    (e.g., '1..10 by 3 align 2' => '2, 5, 8' since 2 == 5 == 8, mod 3)
  - defined == on ranges in terms of the integer sequences they generate
  - defined ident(r1, r2) to say whether r1 and r2 are semantically identical
  - defined '# k' for k < 0 as meaning "count from the end of the range"
  - added 'first', 'last', 'alignedLow, 'alignedHigh' methods to ranges  
    (e.g., '1..10 by -2' => first==10, last==2, alignedLow=2, alignedHigh=10)
  - added support for a variety of new range query functions  
    (e.g., alignLow(), hasFirst(), hasLowBound(), isAligned(), boundsCheck()...)
- added support for volatile bool, int, uint, real, and imag types  
  (see doc/technotes/README.volatile)
- added an end-of-file check to the file type  
  (e.g., 'while !infile.eof ...')
- removed support for treating 'return' in iterator as a 'yield'  
  (e.g., change 'iter foo() { return x; }' to 'iter foo() { yield x; return; }')
- added support to referencing modules without first 'use'-ing them  
  (e.g., module M1 { var x...} module M2 { ...M1.x... } is now legal)
- added a callStackSize query to the locale type  
  (e.g., 'here.callStackSize' returns the call stack size on the current locale)
- removed the previously-required semicolon from the end of enum declarations  
  (e.g., 'enum colors {red, blue, green}' is now legal; previously needed ';')
- added support for a single trailing comma at the end of enum lists  
  (e.g., 'enum colors {red, blue, green, }' is now legal)
- removed support for +/- operators on rectangular domains; use translate()

Newly Implemented Features
--------------------------
- implemented ==/!= for rectangular, associative, and sparse domains

Standard Distributions
----------------------
- added a first-draft 'Replicated' distribution for storing data redundantly  
  (see examples/primers/distributions.chpl)
- improved 'Block-Cyclic', sufficient to correctly implement HPCC PTRANS and HPL  
  (see examples/hpcc/ptrans.chpl, hpl.chpl; examples/primers/distributions.chpl)
- removed redundancy in specification of leader iterators between domains/arrays

Standard Modules
----------------
- added INFINITY and NAN constants to the Math.chpl module  
  (see 'Math' under "Standard Modules" in language spec)
- added isinf() and isfinite() test routines to the Math.chpl module  
  (see 'Math' under "Standard Modules" in language spec)
- added a half dozen more routines to the GMP.chpl module

Documentation
-------------
- added a new technical note describing the user-defined domain map interface  
  (see doc/technotes/README.dsi)
- made many improvements to the language specification
  - major revisions to the Domains chapter to improve clarity/accuracy
  - improved and unified structure of Records and Classes chapters
  - major revisions to the Domain Maps chapter to improve clarity/accuracy
  - named example codes to provide cross-reference to examples/spec/ programs
  - clarified the legality of label/break/continue in parallel loops
  - updated the descriptions of read[ln]/write[ln]
  - fixed some problems in file fields ordering
  - reformatted the specification as a 'book' in LaTeX
  - various minor fixes of typos/mistakes
  - improved definitions/descriptions of several terms
  - added documentation of locale.name
  - and many other changes...
- updated quick reference document to include def->proc/iter change, align op.
- rewrote/reorganized README.extern to clarify explanations and bring up-to-date
- added a README describing the 'local' statement (doc/technotes/README.local)
- added a README describing volatile types (doc/technotes/README.volatile)
- updated README.comm-diagnostics to mention fast fork statistics
- updated various README files

Example Codes
-------------
- placed most code examples from the language spec. to a new spec/ subdirectory
- improved the primers/ directory:
  - added a new primer for using procedures (primers/procedures.chpl)
  - added a basic primer for domains (primers/domains.chpl)
  - renamed the locales primer to locales.chpl and improved it
  - improved the distributions primer and added Block-Cyclic and Replicated uses
  - updated the range primer (primers/range.chpl)
  - improved the iterators primer (primers/iterators.chpl)
  - improved the reductions primer (primers/reductions.chpl)
  - added getCurrentTime() to the timers primer (primers/timers.chpl)
  - added descriptions of type aliases and config types to variables primer  
    (see primers/variables.chpl)
- improved hpcc/ benchmarks directory
  - added first version of HPCC PTRANS to hpcc/ directory (ptrans.chpl)
  - added cleaner version of HPCC HPL to hpcc/ directory (hpl.chpl)
  - added a variants/ subdirectory to examples/hpcc to exhibit other approaches
    - added stream-promoted.chpl to show use of promotion in global STREAM Triad
    - added ra-cleanloop.chpl to show cleaner (but currently slower) RA kernel
- improved top-level examples:
  - renamed existing "hello, world" examples to suggest a logical reading order  
    (see examples/hello*.chpl)
  - added data parallel and distributed data parallel hello, world examples  
    (see examples/hello3-datapar.chpl, examples/hello4-datapar-dist.chpl)
  - added comments to the various hello, world examples (examples/hello*.chpl)
- updated all examples to current language semantics
  - use 'proc'/'iter' rather than 'def'
  - update to reflect new range semantics

Platform-specific Notes
-----------------------
- for Cray XT/Cray XE, improved the aprun and pbs-aprun launchers  
  (see "Launcher-specific notes" below)
- for Cray XMT, added support for parallel loops over ranges
- for Cray XMT, added generation of noalias pragmas to forall loop variables
- added support for BSC's MareNostrum including docs and a special launcher  
  (see doc/platforms/README.marenostrum)

Launcher-specific notes
-----------------------
- added launcher-specific options to --help capability
- improved propagation of exit status codes through launchers
- changed launchers to support exec-based (rather than system-based) commands
- made launchers use 'unlink' rather than system('rm') to remove temporary files
- added a launcher for BSC's MareNostrum
- reduced number of temporary files used to capture output of 'system' commands
- aprun launcher improvements:
  - added a --cc flag to specify CPU assignment w/in a node
  - added a -q flag to run the launcher in quiet mode
  - added debug capability via CHPL_LAUNCHER_DEBUG to keep tmp files around
- pbs-aprun launcher improvements:
  - added a --cc flag to specify CPU assignment w/in a node
  - added debug capability via CHPL_LAUNCHER_DEBUG to keep tmp files around
  - cleaned up output to get rid of some extraneous printing
  - made launcher support our testing system
  - added --walltime and --queue flags to launcher as alternatives to env. vars.

Compiler Changes
----------------
- made the compiler print 'true'/'false' out in type signatures rather than 1/0
- added config param 'noRefCount' to disable reference counting (may leak memory)

Compiler Flags
--------------
- added a --print-callstack-on-error flag to show what led to a bad call
- added a --no-codegen flag to skip the code-generation and linking phase

Interoperability Changes
------------------------
- added support for extern C "classes" (pointer-to-struct types)
- added support for extern consts (see README.extern)

Error Message Improvements
--------------------------
- added a warning orphaned 'use' statements outside of declared modules  
  (e.g., 'use M1; module M2 { }' should typically be 'module M2 { use M1; }')
- made parse-time error message use the standard 'filename:lineno:' format
- generated an error message for referring to a class name in a primary method
  (e.g., 'class C { def C.m() {...} }' now generates an error message)

Bug Fixes / New Semantic Checks (for old semantics)
---------------------------------------------------
- prevented config types from being set using execution time command-line flags
- fixed the compiler's ability to handle unions with no fields
- fixed the minloc/maxloc reductions to handle empty ranges/subranges of values
- fixed a bug in which the 'path' argument to file constructors was ignored
- made empty unions work correctly
- fixed an overflow issue in chunking up ranges for distribution/parallelization
- fixed a bug involving support for empty extern record types
- fixed a bug involving extern functions that return records
- fixed a bug related to copying external records
- fixed implementation of +/- operators on associative/sparse domains
- fixed a bug relating to filename-based module names containing multiple '.'s
- added error messages for expand/exterior/interior on irregular domains
- added an error for constructors/destructors with a specified return type
- fixed a pair of bugs relating to the 'fast on' optimization
- added a check against constructing classes without specifying generic fields

Packaging Changes
-----------------
- added syntax highlighter code for GNU source-highlight  
  (see etc/source-highlight/README)
- improved emacs coloring support for version 22.x  
  (see etc/emacs/README)
- updates to vim syntax coloring to reflect new 'proc'/'iter' keywords  
  (see etc/vim/README)
- added a script for converting existing codes' use of 'def' to 'iter'/'proc'  
  (see $CHPL_HOME/util/convert-defs)
- removed multirealm examples & documentation for the time being

Third-Party Software Changes
----------------------------
- updated GASNet to version 1.16.1
- added copies of BSC's Nanos++ and Sandia's Qthreads  
  (see third-party/README)
- made a post-install step for GASNet that changes absolute paths to relative
- removed PVM for the time being due to instability

Runtime Library Changes
-----------------------
- added single-locale task layers for Nanos++ (BSC) and Qthreads (Sandia)
- several improvements to the runtime tasking layer:
  - added a new interface for having the tasking layer call chpl_main()
  - changed tasking init function to take maxThreadsPerLocale/callStackSize args
  - added a task yield capability to the tasking layer interface
  - improved runtime code to avoid using sync vars before initializing tasking
  - removed macro-ized form of tasking interface; using standard names instead
  - unified naming of all task layer routines to chpl_sync_*() and chpl_task_*()
  - removed requirement to implement the single variable interface
  - moved termination of threads from fifo tasking layer to pthreads threading
  - simplified implementation of sync variables in the pthread threading layer
  - moved responsibility for thread counts from fifo tasking to pthread threading
- several improvements to the runtime communication layer:
  - restructured the communication interface to support length/type arguments
  - added an interface for non-blocking get operations to the comm. interface
  - unified all remote get operations to use CHPL_COMM_GET() macro
  - refactored/renamed the communication interface headers

Testing System
--------------
- vastly improved the performance testing and graphing capabilities  
  (see comments at the front of start_test for documentation)
- improved the testing system's support for cleaning up after itself
- added ability to avoid using any indirection of stdin
- added an option to provide a system-wide prediff option
- added ability to use a launcher's native timeout feature rather than Python's
- improved how the testing system kills a test that times out
- fixed a bug in which .preexec files only worked if '.' was in your path

Internal
--------
- added a --break-on-id compiler flag for developers to locate AST node creates
- improved organization of util/ directory contents
- changed the way version numbers are computed/displayed for SVN-based users
- added support for task-/thread-specific module code
- added a capability to print the AST counts allocated between each pass
- added a new gdb alias to compiler --gdb: 'loc' prints an AST node's location
- greatly improved implementation of pragmas/flags to avoid error cases
- removed several instances of unnecessary string comparisons in the compiler
- removed error-prone use of CHPL_TASKS and CHPL_THREADS as preprocessor symbols
- added bestPractices documentation for developers (not included in release)
- changed internal munging of '=' and '==' to 'ASSIGN' and 'EQUALS' respectively
- added a --print-id-on-error developer flag to print AST ID on errors
- improved the strictness of C++ prototype checking
- added external contributor agreements to the SVN tree (not in release)
- added a notion of internal types used by the compiler but not the user



version 1.2.0
=============

Fifth public release of Chapel, October 21, 2010

High-Level Themes
-----------------
- single- and multi-locale task parallelism
- improved single- and multi-locale data parallelism
  - single- and multi-locale parallelism for arithmetic domains/arrays
  - single-locale parallelism for sparse and associative domains/arrays
  - serial reference version of opaque domains/arrays
- improved stability and portability

Highlights
----------
- support for parallel iteration over sparse and associative domains and arrays
- added support for the Cray XE6 (TM) and Cray CX1000 (TM)
- improved parallelization of loops for the Cray XMT (TM)
- support for config types and improved support for config params
- improved support for external C types, vars, and functions
- initial support for first-class and anonymous functions
- prototype implementation of a GMP multiprecision math module

Environment Changes
-------------------
- renamed the 'cx1-linux' platform variable to 'cx-linux'

Syntactic/Naming Changes
------------------------
- renamed the range's index type from 'eltType' to 'idxType'
- made string length a parentheses-less method rather than a standalone function  
  (i.e., 'length(mystring)' should now be written 'mystring.length')

Semantic Changes/Changes to Chapel Language
-------------------------------------------
- added initial support for first-class and anonymous functions  
  (see doc/technotes/README.firstClassFns)
- added support for config types
- enabled config params to support very general command-line expressions
- added support for param 'this' arguments to methods
- added support for assigning tuples of ranges to arithmetic domains
- added support for .stridable and .stride queries on domains
- changed the range's stride type from an int to a signed int of the index type  
  (e.g., range(uint(64)) and range(int(64)) now store an int(64) stride value)
- made the by operator for a range accept the range's idxType or its stride type
- added min()/max() functions for tuples that fill the tuple with min/max vals  
  (see 'Tuples' chapter of language spec)
- added isTupleType(type t) param function that tells whether t is a tuple
- made a dataParTasksPerLocale value of '0' evaluate to here.numCores
- converted dataParMinGranularity from a uint to an int and made its default '1'
- made numBits/numBytes for default-width bools generate a compiler error

Newly Implemented Features
--------------------------
- added support for parallel iteration over sparse domains/arrays
- added support for parallel iteration over associative domains/arrays
- added support for sparse strided domains
- added support for printing of default layout arrays with negative strides
- fixed iteration over/printing of default layout arrays with negative strides
- implemented initialization of strided arrays by tuples
- added the ability to slice a domain with another domain
- added support for localSlice method on arrays with default layout
- added support for indexToLocale method on the default layout

Standard Domain Maps
--------------------
- made default sparse and associative domains/array layouts support parallelism

Standard Modules
----------------
- added a prototype GMP (GNU Multiple Precision Arithmetic) module  
  (see doc/technotes/README.gmp)

Platform-specific notes
-----------------------
- added support for the Cray XE6 (TM) via a new platform variable xe-cle  
  (see doc/platforms/README.xe-cle)
- added support for the Cray CX1000 (TM) as part of the cx-linux platform  
  (see doc/platforms/README.cx-linux)
- added support for using LSF as a launcher for cx-linux via lsf-gasnetrun_ibv
- for xt-cle/xe-cle:
  - made MPI the default conduit due to portals conduit issues in GASNet 1.14.x
  - added support for specifying dynamic vs. static linking  
    (see doc/platforms/README.xt-cle or .../README.xe-cle)  
  - made the default launcher depend on the availability of pbs/aprun
    (see doc/platforms/README.xt-cle or README.xe-cle)
- for xmt:
  - improved the parallelization of operations on default layout arrays/domains
  - made XMT compilations ignore dmapped annotations on domains

Documentation
-------------
- improved the language specification to improve clarity, fix bugs
- updated the various READMEs, text files, and man page

Example Codes
-------------
- switched hpcc benchmarks to use sugared form of dmapped for clarity

Packaging Changes
-----------------
- moved test system helper scripts from test/Bin to util/test
- added ability for multiple communication substrate builds to coexist at once

Compiler Changes
----------------
- converted the compiler version to the format: major.minor.update

Third Party Changes
-------------------
- updated to GASNet version 1.14.2
- added GMP (the GNU Multiple Precision Arithmetic Library)

Runtime Library Changes
-----------------------
- improved the implementation of the fast fork optimization
- removed the mutex-related calls from the tasking layer interface

Launcher-specific notes
-----------------------
- made the pbs-aprun launcher use options to qsub rather than a script file

Compiler Flags
--------------
--report-scalar-replace : print statistics about scalar replacement
--scalar-replace-limit : sets the max size of variables replaced (default=8)
--[no-]tuple-copy-opt : enables tuple assignment optimization
--tuple-copy-limit <limit> : limits size of tuples for --tuple-copy-opt

Execution Flags
---------------
--callStackSize : specify the task call stack size  
  (see doc/README.executing and doc/README.tasks)

Interoperability Changes
------------------------
- improved ability to express external C functions, types, and variables:
  - added support for external type and variable declarations
  - added support for expressing and passing external C array types
  - added support for type arguments to an external function  
  (see doc/technotes/README.extern)

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- fixed a bug in multiplying two imag values
- added a check to prevent comparisons between types and values using == or !=  
  (e.g., 'var x = ...;  type t = ...; ...(x == t)...' is now illegal)
- added a check to ensure tuple-style decls match the size of their initializer  
  (e.g., 'var (x, y) = (1, 2, 3);' will now generate an error)
- fixed a pair of nil pointer dereference bugs in the Cyclic distribution
- made string.length return an 'int' as documented rather than an 'int(64)'
- fixed a bug in which the compiler seg faulted if no .chpl files were given
- generate a compiler error when applying '#' to a completely unbounded range  
  (i.e., ".. # 10" is now a compiler error)
- fixed a bug in which queried argument types sometimes became void incorrectly
- made values of dataParTasksPerLocale and dataParMinGranularity < 0 an error
- added a check to make sure maxThreadsPerLocale >= 0
- fixed a race condition in the initialization of the fifo tasking layer
- fixed a bug in which functions returning enums were flagged as not
- fixed a bug in which failing to capture an iterator caused it not to be called
- removed a race condition on calling halt() from multiple tasks in a locale

Error Message Improvements
--------------------------
- 'illegal use of a function that does not return a value' now says which fn.

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- improved the compiler's ability to narrow wide references when possible
- optimized small tuple assignment to use scalar assignment rather than memcpy
- turned the --localize-global-consts flag on by default
- removed empty records from the compiler's intermediate representation
- improved scalar replacement for nested records

Testing system
--------------
- added ability for testing system to generate graphs in performance mode  
  (see comments in start_test for details)

Internal
--------
- added documentation on compiler arch. to doc/developer/compilerOverview (SVN)
- refactored the $CHPL_HOME/util directory into several subdirectories
- refactored third-party directory and Makefiles
- generally removed file extensions from shell scripts
- made internal version number take the form: major.minor.update.svnrev
- made the compileTest script more robust w.r.t. -I, -M, .h, etc. arguments
- cached the number of processor cores in the locale type
- added versions of compilerError and compilerWarning that take a call depth
- reduced the number of runtime files that get rebuilt when the compiler changes
- simplified the implementation of associative arrays to reduce copies/temps
- removed the 'size' field from the default arithmetic array class
- made our implementation of Norm.chpl use slicing rather than rank change
- replaced the isEnumType primitive with calls to _isEnumeratedType()
- replaced several primitives with extern functions
- added a new repositionDefExprs pass to make local variables safe on XMT
- added --local-temp-names flag to use a different temp naming scheme
- changed the --gen-communicated-structures developer flag to --heterogeneous



version 1.1.2
=============

Update to fourth public release of Chapel, September, 2010  
(see also changes below for 1.1.1 and 1.1)

Platform-specific notes
-----------------------
- added an xe-cle PLATFORM to support the XE6 (currently using GASNet over MPI)  
  (see doc/platforms/README.xe-cle for details)



version 1.1.1
=============

Update to fourth public release of Chapel, July 8, 2010  
(see also changes below for 1.1)

Platform-specific notes
-----------------------
- removed dependence on linking against libpct on Cray XTs
- fixed a bug in which linux did not use 'make' if 'gmake' was unavailable

Bug fixes
---------
- fixed a race condition in our mutex initialization code
- fixed a bug in fillRandom() in which using a clock-based seed did not do so



version 1.1
===========

Fourth public release of Chapel, April 15, 2010

High-Level Themes
-----------------
- single- and multi-locale task parallelism
- improved single- and multi-locale data parallelism
  - all data parallel operations on arithmetic arrays are now parallelized
  - improved control over task quantity and granularity for data parallelism
  - improved completeness and stability of Block and Cyclic distributions
- bug fixes

Environment Changes
-------------------
- added CHPL_TASKS to select the tasking layer to use (was CHPL_THREADS)  
  (see doc/README.chplenv and doc/README.tasks for details)
- CHPL_THREADS now describes lower-level threading and is typically inferred  
  (see doc/README.tasks)
- changed the name of the default tasking layer from 'default' to 'fifo'  
  (see doc/README.chplenv and doc/README.tasks)
- added CHPL_TIMERS to select between timer implementations  
  (see doc/README.chplenv)
- changed the CHPL_*_PLATFORM string for 32-bit linux from 'linux' to 'linux32'  
  (see doc/README.chplenv)

Syntactic/Naming Changes
------------------------
- several changes related to the naming and syntax of distributions:
  - renamed "distributions" to "domain maps" (or 'dmap's in Chapel syntax)
  - redefined the term "distributions" to refer to multi-locale domain maps
  - defined the term "layouts" to refer to single-locale domain maps
  - replaced placeholder 'distributionType'/'distributionValue' with 'dmap'  
    (e.g., 'const D = distributionValue(...)' => 'const D = new dmap(...)'
  - changed the 'distributed' keyword to 'dmapped'
  - added a syntactic sugar to drop 'new dmap(new' for anonymous domain maps  
    (e.g., '...dmapped new dmap(new Block(...))...' => '...dmapped Block(...)')  
  (see 'Domain Maps' chapter of language specification for more information)
- renamed maxThreads to maxThreadsPerLocale (see README.tasks)
- renamed the 'ind2loc' method on domain maps to 'idxToLocale'
- renamed the Cyclic constructor 'low' argument to 'startIdx'  
  (see 'Standard Distributions' chapter of the specification)
- replaced the use of underscore (_) to ignore things to leaving the space blank  
  (e.g., '(_, x) = getTuple()' => '( , x) = getTuple()')
- made underscore (_) a legal identifier
- changed name of the Random module's SeedGenerator from clockMS to currentTime  
  (see 'Standard Modules' chapter of the specification)
- added support for empty (no-op) statements within a class declaration
- added ability to elide the # of arguments specification/query from varargs fns  
  (e.g., can now do 'def f(x...)' in addition to 'def f(x...?n)'/'def f(x...n)')

Semantic Changes/Changes to Chapel Language
-------------------------------------------
- added config consts to control the number of tasks used for data parallelism  
  (see README.executing and 'Data Parallelism' chapter of specification)
- redefined enumerated domains to be a special case of associative domains
  (see 'Domains' chapter of specification)
- made iteration over enumerated domains/arrays use the enum's declaration order  
  (see 'Domains' chapter of the specification)
- removed the ability to assign array aliases to normal array variables  
  (e.g., 'var A => B;' is legal but 'var A: [1..n] real;  A => B;' is not)
- added initial support for passing array aliases to default class constructors  
  (e.g., 'class C {var X: [1..n] int;} var A: [1..n] int; var c = new C(X=>A);')
- removed the sugar for declaring array types with forall expressions:  
  (e.g., 'var A:[i in 1..n] real =...' => 'var A:[1..n] real = [i in 1..n] ...')
- defined reindexing to ignore the domain map of the indexing domain
- specified that minloc/maxloc reductions return the lowest matching index  
  (e.g., 'minloc (A, 1..3)' for A = '5 0 0' would return (0, 2))
- type aliases may now only be used after they are defined  
  (e.g., 'var x: t; type t = int;' is now illegal)
- changed resolution to favor functions with where clauses over those without  
  (e.g., for 'foo(3)', 'foo(x)' is not as good a match as 'foo(x) where x:int')  
  (see 'Function Resolution' section of the specification)
- added the ability to index into 1-dimensional arithmetic arrays using 1-tuples  
  (e.g., 'var i: 1*int;  ...  A(i)' where A is a 1D arithmetic array)
- added the ability to query the component types of formal tuple arguments  
  (e.g., 'def f(t: (real, ?t)) { ... }')
- redefined order-of-evaluation of tuple assignments to avoid array temps  
  (see 'Tuples' chapter of specification)
- added support for indexing into tuples using any integral type, not just 'int'  
  (e.g., given a tuple variable t, 'var i = 1:uint; ...t(i)...' is now legal)
- added support for 1-tuple detupled variable declarations for completeness  
  (e.g., in 'var (x): 1*int;', x is of type 'int')
- redefined assignments to evaluate the left-hand side before the right  
  (e.g., in 'x = y;', x is evaluated first and then y)

Newly Implemented Features
--------------------------
- whole-array assignment now results in parallel execution for arithmetic arrays  
  (e.g., 'A = B; and 'A = B + alpha * C' now result in parallel execution)  
  (see 'Data Parallelism' chapter for details)
- added support for assigning to a variable of dmap type if it has no domains  
  (e.g., 'var myMap: dmap(Block(2)); myMap = new dmap(new Block([1..10]));')
- can now apply domain maps to domain values rather than simply domain types  
  (e.g., 'const Dom1 = [1..10] dmapped ...')
- added support for sparse domain assignment (executed serially with a warning)
- added support for removing indices from a sparse domain (not thread-safe)
- added support for declaring formal tuple arguments of explicit tuple types  
  (e.g., 'def f((x, y): (int, real)) { ... }')
- improved support for zippering domains/arrays with distinct domain maps

Standard Domain Maps
--------------------
- the Block and Cyclic distributed domain maps are now feature-complete
- added reindexing and rank change operations to the Block distribution
- reordered Block's constructor args so that rank and idxType can be inferred  
  (e.g., 'new Block(rank=1, idxType=int(64), [1..n])' => 'new Block([1..n])')
- similarly reordered Cyclic's constructor args and renamed 'low' to 'startIdx'
- made int(32) the default idxType for standard distributions like Block
- moved all standard domain maps into modules/layouts/ and .../distributions/
- factored common routines for arithmetic domains into ChapelArray.chpl  
  (e.g., nothing about exterior() is specific to a domain map's implementation)
- refactored helper functions for distributions into a new file: DSIUtil.chpl

Standard Modules
----------------
- refactored the code in the Random module and improved the implementation
- changed the Random module's SeedGenerator to an enumerated type
- added support for filling random vectors of imaginary types

Platform-specific notes
-----------------------
- added an mtarun launcher for the Cray XMT
  (see README.launcher)
- on the Cray XMT added support for platform-specific timing routines
  (see README.chplenv)
- for the Cray XMT, fixed a bug with uninitialized variables and poison bits

Portability of code base
------------------------
- ported code base to recent versions of NetBSD (thanks to Phil Nelson)
- removed hard-coded paths to perl and bash in scripts, relying on /usr/bin/env
- added parentheses around some expressions to avoid compiler warnings

Documentation
-------------
- updated the STATUS file
- added the first description of using domain maps to the specification
  (see 'Domain Maps')
- performed a major restructuring of the language specification:
  - split the 'Domains and Arrays' chapter into two distinct chapters  
    (see the 'Domains' and 'Arrays' chapters)
  - split the 'Parallelism and Synchronization' chapter of the spec into two  
    (see 'Task Parallelism and Synchronization' and 'Data Parallelism')
  - moved the 'Reductions and Scans' chapter of the spec into 'Data Parallelism'
  - moved discussion of promotion into the 'Data Parallelism' chapter
  - split the 'Locales and Distributions' chapter of the spec into three  
    (see 'Locales', 'Domain Maps', and 'User-Defined Domain Maps')
  - reordered the chapters of the specification for clarity
  - added a placeholder chapter to the specification for user-defined reductions  
    (see 'User-Defined Reductions and Scans')
  - added a 'Standard Distributions' chapter that describes Block and Cyclic
  - added a placeholder chapter for 'Standard Layouts'
- improved the specification:
  - added a publication date to the title page of the specification
  - updated the operator precedence table in the specification  
    (see 'Lexical Structure' chapter)
  - improved the specification's syntax diagrams for [co]for[all] loops
  - minor improvements to the 'Modules' chapter of the specification
  - made major improvements to the 'Tuples' chapter
  - improved the accuracy of the description of function resolution
  - reorganized/rewrote the 'Domains' and 'Arrays' chapters (more remains)
  - improved the consistency of prototypes in the 'Standard Modules' chapter
  - updated the description of the Random number module to reflect changes
  - fixed several bugs in example codes within the specification
- added doc/platforms/README.xmt to describe the use of Chapel on a Cray XMT
- added doc/platforms/README.sgi to describe the use of Chapel on an SGI Altix
- updated READMEs based on task/thread change
  (see doc/README.tasks and doc/README.executing)
- added a README to the $CHPL_HOME/util directory to describe its contents
- updated READMEs for clarity and accuracy
- reformatted the CONTRIBUTORS file to reflect contributors to a given release
- updated the quick reference card's contents

Example Codes
-------------
- added a new example 'distributions.chpl showing use of Block and Cyclic
- removed 'block2D.chpl' example, considered redundant with the above
- added a new example to show simple multitasking (hello-multicore.chpl)
- renamed the 'examples/tutorials' directory 'examples/primers'
- rewrote the taskParallel.chpl primer example program
- updated all examples to reflect language changes:
  - to reflect new dmap/dmapped syntax for specifying domain maps
  - the change of Block and Cyclic's default idxType to int(32)
  - to remove reliance on the 'A:[i in ...]' syntactic sugar for array decls
  - to remove the use of underscores to represent ignored values
  - to track the changes to the Random module interface
  - to reflect the new controls for specifying degree of data parallelism
  - to reflect the new constructor argument orders for Block and Cyclic
  - to reflect the renaming of ind2loc to idxToLocale
- renamed helper files in hpcc/ subdirectory to match the modules they define
- updated comments in ra-randstream.chpl, quicksort.chpl
- stopped unrolling a loop in ra-randstream.chpl's computeM2Vals routine
- added hpcc/stream-ep to the Makefile and README (overlooked in last release)

Packaging Changes
-----------------
- pushed tarball directory structure down one level  
  (i.e., chapel-1.1/chapel)
- moved non-user scripts from $CHPL_HOME/util/ to $CHPL_HOME/util/chplenv/

Compiler Changes
----------------
- added warnings for most serialized data parallel operations
- added warnings for array reindexings using strided ranges/domains
- improved orthogonality of parsing type expressions in expression contexts
- turned off optimizations by default for CHPL_COMM=gasnet; use -O to enable
- reimplemented scans to remove the creation of a temporary array

Runtime Library Changes
-----------------------
- reorganized the runtime directories to use better hierarchies  
  (e.g., 'runtime/foo-bar' => 'runtime/src/foo/bar'
- broke the threading layer of the runtime into tasking and threading layers
- renamed most external tasking/threading routines in the runtime interface
- added support for different timer implementations and platform-specific timers
- renamed chapel_code.chpl to chpl_rt_utils.chpl
- exposed sleep() calls to the tasking layer

Launcher-specific notes
-----------------------
- added an mtarun launcher for the Cray XMT

Compiler Flags
--------------
- --conditional-dynamic-dispatch-limit flag for using vtables vs. conditionals
- --[no-]fast-followers to control optimization of aligned parallel iterators

Interoperability Changes
------------------------
- added initial support for declaring external C struct types
  (see doc/technotes/README.extern for details)

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- removed the ability to assign values to types
- added a check that config param enums are set to a legal value for the enum
- added a check that tuple assignments are between tuples of matching size
- added a check that iterators are not defined to yield types or params
- added a check to ensure zippered sparse domains/arrays share the same domain
- added an error message for param for loops that iterate over non-param ranges
- fixed a bug in which a shared initializer was evaluated multiple times  
  (e.g., 'var x, y, z = foo()' called foo() three times rather than one)
- fixed a bug in which yield statements could omit the expression to yield  
  (i.e., 'yield;' is not a legal statement in Chapel)
- fixed a bug in which applying .locale to a global variable always returned #0
- fixed a few race conditions in the runtime tasking layer
- fixed an integer overflow problem in the locale.physicalMemory() query
- fixed a runaway recursive error message in erroneous CHPL_COMM=gasnet exits
- fixed a bug in associative domains in which stale array values were not reset
- fixed bugs in which argument coercion and promotion broke extern functions
- fixed a bug in which a 'use' in a module-level non-function scope leaked names
- fixed a bug where returning a sync var was flagged as not returning anything
- fixed a bug in which generic class member types could not be queried
- fixed a bug in which a class' type declaration could not define multiple types
- fixed a bug in which printing an empty record would print an internal field
- fixed a bug in which recursive fns in local blocks led to infinite compilation
- fixed bugs in function resolution that led to choosing a poorer match
- fixed implementation of type aliases to evaluate them during fn resolution
- fixed a bug in the visibility of parallel iterators in promotion wrappers
- fixed a bug in dead code elimination considered already eliminated code
- fixed a bug in which compiler warnings were sometimes not generated
- fixed a bug in which standalone forall loops incorrectly localized references
- fixed a bug in flattening nested functions that removed non-dead references
- fixed a bug in which the compiler would incorrectly drop line#/filename info
- fixed a bug in which duplicating a loop would not update its labels
- fixed the instantiation point for compiler-introduced wrapper functions
- fixed a bug in which "false" where clauses were counted as instantiations

Error Message Improvements
--------------------------
- squashed "too many instantiation" error messages for internal types/functions
- somewhat improved the error message for applying 'new' to a non-class

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- turned on optimizations of on-clauses by default (--optimize-on-clauses)
- re-implemented homogeneous tuples to use C arrays rather than structs
- generated new loop idioms to replace fragile static alignment analysis
- Cyclic distributions now result in similar performance to Block for e.p. codes
- added the ability to use a virtual method table for dynamic dispatch

Compiler Performance and Cleanup
--------------------------------
- reordered compiler optimizations to improve performance
- rewrote copy propagation to remove a quadratic aspect of the algorithm
- changed conditional-based dynamic dispatch to use statements rather than exprs
- improved performance of function resolution
- improved performance of the reaching definitions analysis

Cleanup of Generated Code
-------------------------
- made generated code less sensitive to small changes to better support diffs
- broke user code within chpl_main() into its own function: chpl_user_main()

Testing system
--------------
- added ability to test properly formatted codes embedded in the specification
- changed sub_test script to use Python for better flexibility/maintainability
- fixed the redundant cleaning of directories when tests are explicitly named
- made sub_test clean up executables for .noexec tests

Internal
--------
- added a developer optimization to localize global constants (off by default)
- added a new helper function gen() that serves as a printf for codegen
- added a debugging function printCallStack() for use during function resolution
- added a new mechanism for building the IR after parsing, before normalization
- refactored parser to treat types and expressions more uniformly
- refactored parsing of serial and parallel loops to share more code
- simplified the implementation of operator overloading on tuples
- cleaned up the implementation of reductions
- reimplemented Math.chpl routines using _extern rather than primitives
- reimplemented most Memory.chpl routines using _extern rather than primitives
- generalized a mechanism for soft-resolving a possibly erroneous function call
- added a displayRepresentation method to dmap, domain, and array classes
- removed the unused 'reindexed' param from default arithmetic arrays
- added the "dsi" prefix to methods that are part of the dmap standard interface
- better distinguished between thread and task IDs
- added getValType(), getRefType(), getWideRefType() helper functions
- added support for _isSignedType() and isUnsignedType() helper param functions
- moved the implementation of queries in formal types to function resolution
- simplified the generation of BUILD_VERSION for non-developers



version 1.02
============

Update to third public release of Chapel, November 12, 2009  
(see also changes below for version 1.01 and 1.0)

High-Level Themes
-----------------
- single- and multi-locale task parallelism
- single- and multi-locale data parallelism
- improved performance and scalability
- bug fixes

Packaging Changes
-----------------
- added GASNet 1.14.0 to third-party/ though 1.12.0 is still the default
  (see third-party/gasnet/README)

Runtime Library Changes
-----------------------
- vastly improved the performance of CHPL_COMM=pvm, esp. when oversubscribing

Documentation
-------------
- removed the HPCC-related PDFs from doc/ as they seem better suited for the web

Example Codes
-------------
- added an EP version of stream to showcase Chapel in an SPMD-like mode
  (see $CHPL_HOME/examples/hpcc/stream-ep.chpl)
- added local blocks to ra.chpl and fft.chpl to assert regions of locality
- changed fft.chpl to use both Block and Cyclic arrays to optimize for locality

Standard Distributions
----------------------
- optimized the Block distribution via privatization and remote value forwarding
- added support for a .localSlice() operation for Block and Cyclic array
- optimized away some extraneous copies from standard distributions

Compiler Flags
--------------
- added --[no-]optimize-on-clauses and --optimize-on-clause-limit

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- fixed a bug in which wide references weren't removed from local blocks
- fixed a bug in which range slicing resulted in divide-by-zero due to overflow
- fixed a bug in which Block misdistributed indices at sufficiently large sizes
- fixed a bug in which multirealm PVM runs could set up locales in wrong order

Error Message Improvements
--------------------------
- improved the error messages for failed pvm launches

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- added an optimization to execute on-clauses using a remote locale's listener
  (see --[no-]optimize-on-clauses and --optimize-on-clause-limit)

Internal
--------
- added initial support for recursive leader iterators
- added support for generating Chapel errors in terms of C line/file
- refactored and cleaned code in PVM launcher and comm layer (more remains)
- added Makefile.tau for experimental use of Chapel with Tau



version 1.01
============

Update to third public release of Chapel, October 30, 2009  
(see also changes for version 1.0)

High-Level Themes
-----------------
- multi-locale task parallelism
- support for single- and multi-locale data parallelism
- improved scalability and stability
- prototype implementation of realms for hybrid computing in Chapel
  (see doc/technotes/README.multirealm)

Packaging Changes
-----------------
- added a utility script, chpl-multirealm, to help with multi-realm compilation
- added PVM to the third-party directory to support multi-realm computation

Newly Implemented Features
--------------------------
- added support for multi-realm features to support heterogeneous computation
- extended replication of global constants to include record types

Platform-specific notes
-----------------------
- made XT GASNet compiles use "cc" without the full path discovered by GASNet

Documentation
-------------
- updated .emacs excerpts in etc/emacs/README to use more modern idioms

Example Codes
-------------
- added an example demonstrating multirealm computation features
- cleaned up RA to refer to TableDist in on-clauses rather than T.domain.dist

Standard Distributions
----------------------
- made the default distributions throttle parallelism based on #tasks running
- improved the Cyclic distribution to support strides and slicing
- added initial support for a "Private" distribution with one index per locale

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- fixed a bug in which distributions deadlocked when numLocales > maxThreads
- fixed a bug with parallel iteration when problem size ~= #cores
- fixed some bugs with slicing and querying the length of degenerate ranges
- fixed some bugs in distributions when iterating over degenerate ranges

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- reduced the number of communications required to set up distributions
- reduced the time required to set up Block distributions
- reduced the time required to create privatized data structures
- optimized iterators for Block- and Default-distributed Arithmetic arrays
- optimized the expression .locale.uid to avoid communication
- optimized .dist methods on default domains to return the private distribution

Testing system
--------------
- softened the signal used by our timeout script from -9 to -15

Internal
--------
- fixed some const char* issues in strstr, strchr, strrchr calls
- added verification that gotos are in same functions as their labels



version 1.0
===========

Third public release of Chapel compiler, October 15, 2009

High-Level Themes
-----------------
- multi-locale task parallelism
- improved support for single- and multi-locale data parallelism
- improved stability and portability
- improved memory utilization of compiler-generated code
- target audience: general public

Environment Changes
-------------------
- added emacs/vim modes to release -- see $CHPL_HOME/etc/README

Changes to Chapel Language
--------------------------
- removed implicit coercions from primitive types to strings to avoid confusion
- a default array variable can now be made to alias another via the => operator
- accesses to variable x in module M using 'M.x' must now follow a 'use M'

Newly Implemented Features
--------------------------
- forall loops over ranges & arithmetic domains/arrays are now parallelized
- improved support for and correctness of record and class destructors
- array declaration+initialization syntax now results in parallel evaluation  
  e.g., var A: [i in D] real = foo(i);  will be evaluated in parallel
- added == and != for imag and complex types; added >, >=, <, <= for imag types

Portability of code base
------------------------
- improved support for the Cray compiler on XT systems (cray-xt-cray)
- reduced warnings for gcc > 4.3
- improved portability with respect to Intel icc/icpc v11.x
- removed outdated assumptions about Sun compiler environments
- removed the makechpl script for Mac users because of portability issues

Platform-specific notes
-----------------------
- added a PBS launcher for the Cray CX1 named pbs-gasnetrun_ibv

Launcher-specific notes
-----------------------
- several improvements to the pbs launcher (see README.launcher/README.xt-cle)
  - environment variables are now propagated to the application
  - a queue can be specified via the CHPL_LAUNCHER_QUEUE environment variable
  - a wallclock limit can be specified via CHPL_LAUNCHER_WALLTIME
  - the NCCS pbs launcher no longer uses the debug queue by default
- added support for CHPL_LAUNCHER_SUFFIX to launch a file other than ..._real

Semantic Changes
----------------
- changed distributions from having class/reference semantics to value semantics
- made module initialization occur at program startup rather than use statements
- only modules specified on the command-line are candidates for the main module
- added support for returning locally scoped arrays from variable functions
- changed interpretation of method definitions on scalar types  
  e.g., 'def int.foo()' now defines foo() for default-sized ints, not all ints

Syntactic/Naming Changes
------------------------
- renamed MultiBlockDist.chpl to BlockDist.chpl
- removed the Block1D distribution since Block subsumed it
- added placeholder notation for creating new distribution values  
  e.g., new Block(...) => distributionValue(new Block(...))
- renamed the pbs launcher for Cray XT to pbs-aprun since it wraps both packages

Compiler Changes
----------------
- improved support for slicing [strided] domains/arrays with [strided] slices
- improved flushing of writeln() statements to the file being written to
- removed support for goto from the compiler's front-end

Runtime Library Changes
-----------------------
- improved pthread setup, termination, and cleanup for non-erroneous exits
- refactored threading runtime to support code reuse for pthread-like threads
- added support for memory tracking for multi-locale executions

Documentation
-------------
- improved the Types, Modules, and Ranges chapters of the language specification
- added mention of 'delete' to language specification
- improved the Label, Break, and Continue subsection of the language spec
- minor changes to other chapters of the language specification
- updated README.xt-cle and README.launcher to reflect new pbs features
- updated the various READMEs to reflect minor changes and wording

Example Codes
-------------
- changed fft to use a Block distribution
- changed reference to MultiBlockDist module in block2D.chpl to BlockDist
- changed distributions to use the placeholder value type notation
- changed default value of tasksPerLocale in HPCC benchmarks to avoid reductions
- changed RA's constant array m2 into a constant scalar for performance reasons
- changed follower iterator in ra-randstream.chpl to accept tuple of ranges
- deleted classes in example programs to reclaim memory
- increased problem size for reductions.chpl to avoid bug w/ 5+ cores per locale

Standard Modules
----------------
- added printMemStat() to the standard Memory module; improved printMemTable()
- added start/stopVerboseMem[Here]() to the Memory module for tracing memory use
- improved reference counting of domains and arrays
- removed the (undocumented) Schedules module

Standard Distributions
----------------------
- merged Block1D and Block since the latter subsumed the former
- removed the default rank of 1 for the Block distribution
- added support for a multidimensional target array of locales to Block
- improved support for strided domains/arrays in the Block distribution
- added support for slicing to the Block distribution
- added support for member(), order(), and position() to the Block distribution
- added initial support for a Cyclic distribution
- added very preliminary support for a Block-Cyclic distribution
- improved the support for the CSR distribution to match the default sparse case
- unified leader/follower iterators to always work on tuples of ranges
- removed subBlocks() from the standard distribution interface

Compiler Flags
--------------
- added support for a module path flag (-M) to search for modules via filenames
- added a flag to print the module search path (--print-search-dirs)
- added a flag to print module files being parsed (--print-module-files)
- added support for a -I flag to specify a search directory for C headers

Generated Code Flags
--------------------
- added support for specifying configuration variables/constants without =  
  e.g., you can now use './a.out --n 4' in addition to ./a.out --n=4'
- improved flags for tracking memory utilization (see README.executing)
- improved error messages to indicate the argument number
- made compiler-generated generic type names deterministic
- improved robustness of --numLocales flag

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- added an error for using => on non-array types
- added an error for using (...x) on non-tuple types
- added a semantic check against tuples sized by 0 or a negative value
- made labels on statements other than serial loops be errors
- made break and continue only applicable within serial loops
- improved error checking when assigning between ranges of different boundedness
- fixed a bug in which breaks in serial loops gave errors in parallel contexts
- fixed a bug in which tuple copies sometimes aliased the original tuple
- fixed a bug in which generic fields were incorrectly aliased in constructors
- fixed a bug in which we were accidentally supporting illegal parameter casts
- fixed a bug in which string parameter members broke the compile
- fixed a bug in which indices were inadvertently shared/non-local in promotions
- fixed a bug in which pbs launchers did not work with shell prompts ending in $
- fixed a bug in which the compiler attempted to clone external functions
- for Cray XT, fixed default setting of GASNET_MAX_SEGSIZE to specify size in KB
- fixed a race in the creation of private, replicated distribution classes
- fixed a bug in which tensor iteration resulted in internal errors
- removed a subtle race condition in program startup
- fixed a bug in which we called default constructors by name
- fixed deletion of list elements in List module
- added support for generating the implicit Program module in --html view

Error Message Improvements
--------------------------
- fixed line numbers in errors involving dynamic dispatch and [con/de]structors

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- vastly reduced amount of memory leaked due to compiler-allocated data
- improved performance of loops using Block distributions
- improved performance and reduced memory requirements for memory tracking

Cleanup of Generated Code
-------------------------
- embedded information about compilation options to the generated code

Testing system
--------------
- improved precedence of execution options specified via .execopts or EXECOPTS
- made parallel testing place -nl x flags at the end of the command line
- added support for PVM-based testing to the test script

Internal
--------
- replaced uses of "[unsigned] long long" with [u]int64_t for sane portability
- some unification of reserved names, though more remains
- improved Chapel's launcher runtime interface to be more general
- added a mechanism for intercepting printf/fprintf calls if required
- Makefile refactorings working toward supporting parallel make
- refactored runtime/mem- directories to decrease duplicated code
- renamed runtime files to improve standardization, though more remains
- removed linked list pointers from memory tracking table
- reduced amount of runtime code linked into the launcher binary
- made the use of chpl_globals_registry more consistent across locales
- relaxed compiler assumptions about classes with the "data class" pragma
- added support for generating type and offset information for communications
- some initial work toward supporting execution on heterogeneous architectures
- some initial work toward supporting CPU<->GPU computations in Chapel
- some initial work toward supporting profiling tools with Chapel
- removed "valid var" pragma
- made wrapper functions use blank intent rather than inheriting from wrappee
- changed strategy for determining when value types should be copied/destroyed
- made domain and array classes always have reindexed set to true by default
- added a developer flag for disabling compiler-introduced memory frees
- removed support for _init functions from the compiler
- removed assumptions that replicated global constants are stored symmetrically
- added thread cancel and join functions to the threading runtime interface
- added a type, chpl_threadID_t to pass thread IDs between C and Chapel
- changed point at which variables are put on the heap
- made all built-in modules be filename based
- refactored directory structure of $CHPL_HOME/modules into standard/internal...
- added optimizations to remove unnecessary autocopy/autodestroy calls
- improved robustness of internal modules that use standard ones
- changed the scan implementation to generate an array rather than a list
- changed array assignments to use array iteration rather than random access
- made --no-cpp-lines the default for -g for developers
- improved handling, robustness of built-in configuration variables
- split chpl_comm_md.h into two files to permit platform- and comm- overrides



version 0.9
===========

Second public release of Chapel compiler, April 16, 2009

High-Level Themes
-----------------
- multi-locale task parallelism
- very initial/limited support for data parallelism, distributed arrays
- improved stability, portability, and performance
- target audience: general public

Environment Changes
-------------------
- added a script to print out set and inferred CHPL env vars
  (see util/printchplenv.pl)
- added support for the IBM xlc/xlC compilers by setting CHPL_*_COMPILER to ibm
- added an environment variable for naming a queue for the PBS launcher
  (see doc/platforms/README.xt-cle)
- added an environment variable for specifying #cores/locale to pbs/aprun
  (see doc/platforms/README.xt-cle)
- improved the logic for inferring host and target compilers for xt-cle

Changes to Chapel Language
--------------------------
- added a typeToString() function for converting a static type into a string

Newly Implemented Features
--------------------------
- added queries for task/thread counts per locale for CHPL_THREADS=pthreads
  (see doc/README.threads)
- added a printMemTable() routine to the Memory module for use in Chapel
  (see doc/README.executing)
- added a prototype multidimensional Block distribution: MultiBlockDist.chpl
  (see examples/tutorials/block2D.chpl)

Portability of code base
------------------------
- improved our general method of building and using GASNet for portability
- improved portability of GASNet configure + build steps for xt-cle
- improved the heuristic for setting GASNET_MAX_SEGSIZE for xt-cle
  (see doc/platforms/README.xt-cle)
- added initial support for IBM Power5 and Power6 systems
  (see doc/platforms/README.ibm)
- made flex and bison generate .cpp files rather than .c files for portability
- added capabilities to build Chapel on Macs using xcodebuild
  (see doc/platforms/README.macosx)
- added a -d option to our use of aprun in the aprun and pbs launchers
- removed the assumption that function pointers are identical between nodes

Syntactic/Naming Changes
------------------------
- disallowed identifiers that start with $
- removed compilerError and compilerWarning as keywords
- permitted binary and hex literals to be written using uppercase B/X
- renamed classes used for defining distributions

Runtime Library Changes
-----------------------
- added support for communication diagnostics and debugging
  (see doc/technotes/README.comm-diagnostics)

Documentation
-------------
- added a new ACKNOWLEDGEMENTS file for financial and machine time support
- refactored the doc directory, pushing platform & technical notes into subdirs
- minor changes and improvements to the language specification
- minor edits to many of the README files
- updated the man page

Example Codes
-------------
- pushed most top-level examples into tutorials/ and programs/ subdirectories
- added new tutorial examples for variables, ranges, classes, generic classes
- added new tutorial examples for timers and the prototype Block distribution
- changed quicksort to ensure levels beyond thresh do not re-enable parallelism

Compiler Flags
--------------
- added a flag to disable/enable the remote value forwarding optimization

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- fixed a number of spurious errors caused by how we were using GASNet
- fixed problems in how we terminated multithreaded GASNet programs
- added the ability for _chpl_comm_fork[_nb] to handle large arguments
- applied a GASNet patch that fixes an x86 alignment error
- fixed a bug which had previously limited execution to 1024 locales
- fixed a bug in which arrays could only store 2**31 elements
- eliminated a race condition when two tasks initialize the same module
- fixed a bug in which integer exponentiation was being computed using pow()
- fixed a bug in which slicing via .. could only be done for int(32) indices
- fixed a bug with Block1D domains that exceed the bounding box argument
- added a check to ensure that return statements are not used at module scope
- improved verification of formal/actual argument types
- fixed a bug in which long program names broke the PBS launcher
- fixed a bug with incorrectly spacing operators in generated code
- fixed Chapel error messages that referred to C's errno variable
- fixed a bug with accidentally shared state during parallel iterations
- fixed a bug related to reductions involving forall expressions

Error Message Improvements
--------------------------
- added a runtime error message if the launcher binary can't find the _real one

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- improved the correctness and effectiveness of remote value forwarding
- optimized performance of local communications
- optimized parallel iteration for Block1D to minimize remote references
- parallelized declarations of Block1D distributions, domains, and arrays
- optimized implementation of broadcasts used to initialize private data
- optimized away a thread per locale used for progress+termination
- improved reclamation of compiler-allocated memory
- improved the correctness and effectiveness of re-privatization optimizations
- privatized the default distribution object
- removed array/domain wrapper records

Compiler Performance and Cleanup
--------------------------------
- removed hand-baked and occasionally incorrect integer types int32, int64
- fixed an infinite loop when inlining recursive iterators
- fixed cases in which compiler temps were used outside the variable's scope

Cleanup of Generated Code
-------------------------
- removed redundant reference types from the generated code

Internal
--------
- switched iterator implementation to use records rather than classes
- improved the naming of identifiers in the runtime and generated code
- removed compiler support for (undocumented) anonymous record types



version 0.8
===========

First public release of Chapel compiler, November 14, 2008

High-Level Themes
-----------------
- multi-locale task parallelism
- improved task parallel correctness, features, thread management
- improved stability of core features
- very initial/limited support for data parallelism, distributed arrays
- target audience: general public

License Changes
---------------
- switched from MIT to BSD license (see LICENSE)
- updated user agreement text (see AGREEMENT)

Environment Changes
-------------------
- changed the identifier for the Cray XT platform from xt-cnl to xt-cle
- added a CHPL_MEM setting to select memory allocators (see README.chplenv)

Changes to Chapel Language
--------------------------
- changed operator precedence for : vs. **, bitwise ops, reduce, !, unary +/-
- added destructors and a 'delete' keyword for destroying class instances
- removed open interval syntax in which [0..n) == 0..n-1
- added range operator # that counts a number of elements  
  e.g., 0..#n == 0..n-1;  0.. by 2 #5 == 0, 2, 4, 6, 8
- added support for locale.name to query a locale's node name
- added support for overriding iterators within a class hierarchy
- added the capability to declare generic formals for gen. classes with defaults  
  e.g., "x: range" expects a default range; "x: range(?)" expects a generic one
- added the ability to query argument types without naming the queried type  
  e.g., "x: ?" rather than "x:?t"
- added support for +/- on (arith. domain, index) and + on (index, arith. domain)
- removed support for * and / on (range, integer) and - on (integer, range)
- added support for .clear() on arithmetic domain vars to reset to degenerate
- added .order() and .position() methods to ranges and domains  
  e.g., (1..3).order(3) == 2;  ([1..3, 1..3]).position((2,1)) = (1,0)
- added support for variable-width boolean types
- added support for ~ on bool types
- initial support for a local block that asserts code requiring no communications  
  e.g., on Locale(1) { const x: int;  local { x = x + 1 } }
- added initial support for leader/follower iterators supporting zippered foralls
- added initial support for distributed domains and arrays using a Block1d class
- added initial support for parallel reductions and forall expressions

Newly Implemented Features
--------------------------
- added support for tuples of lvalues  
  e.g., "for (a,b) in (A,B)" where A and B are arrays
- array initializer expressions can now be used for array class members
- added support for user-defined constructors for generic classes
- added support for overriding methods using subtype return types
- added support for querying the eltType of an array  
  e.g., def foo(A: [D] ?t) { ... }
- added support for .remove() on opaque domains
- added support for explicitly naming a function's module at the callsite
- added support for freeing compiler-introduced heap-allocated variables
- added initial support for freeing value type memory (records, arrays, domains)

Portability of code base
------------------------
- added support for the Cray CX1 platform running Linux  (see README.cx1-linux)
- improved level of support for the Cray XT platform (see README.xt-cle)

Semantic Changes
----------------
- disallowed calling a method on a nil reference as previously permitted
- changed the instantiation point for dynamically-dispatched methods
- permitted partially-bounded out-of-bounds degenerate ranges to be legal, empty  
  e.g., var A: [1..10] real;  A[11..] == A[11..10] == a legal, empty slice of A
- on clauses are now evaluated for side effects when using the --local flag
- made single-statement sync statements create a new scope
- added support for param string comparisons, concatenation, and other ops
- added support for casting an integer to a string at compile time
- made the implicit 'setter' argument in var functions constant and foldable

Syntactic/Naming Changes
------------------------
- all non-compound single-statement conditionals/loops now require then/do
- functions now require a block statement unless they only contain a return stmt
- added support for a single-statement serial statement  
  e.g., "serial test { foo(); }"  =>  "serial test do foo();"
- removed "opaque" from the list of reserved words--it is now a type like "int"
- 'distributed' clauses no longer require parentheses

Compiler Changes
----------------
- the compiler now requires CHPL_HOME to be set
- added support for opaque types for use when interfacing with extern functions

Third Party Changes
-------------------
- updated GASNet version to GASNet 1.12.0
- added support for using dlmalloc as a memory allocator

Runtime Library Changes
-----------------------
- all tasks in a cobegin are now set up before any start executing for pthreads
- made the task that starts a cobegin/coforall help execute the component tasks
- made the task that enters a sync statement help execute the component tasks
- added "launcher" capability to wrap job launch mechanism (see README.launcher)
- improved the thread-safety of declaring arrays over a domain

Documentation
-------------
- improved the --help descriptions of --[no-] flags
- updated and improved the language specification
  - improved the specification of instantiated fns: visibility & point-of-inst.
- updated the various README files
- updated the man page

Example Codes
-------------
- added a hello-multiloc example to run a "Hello, world!" on multiple locales
- improved hpcc codes from our 2008 HPC Challenge entry and added HPL (hpl.chpl)
- made the stream.chpl and ra.chpl benchmarks use Block1D-distributed domains
- added support for the stream and ra benchmarks to use multiple tasks per locale
- improved the verification step of stream.chpl to make it stronger
- improved the taskParallel example to reduce the likelihood of races

Standard Modules
----------------
- added a Norm module for computing vector and matrix norms
- added a Containers module for standard container classes
- added a day of week enumeration and getCurrentDayOfWeek() to the Time module
- fillRandom() calls in the Random module now fill Block1D arrays in parallel

Compiler Flags
--------------
- improved the parsing of single-dash compiler flags to avoid common errors  
  e.g., -abcd != -a -b -c -d; -hepl != -h -e -p -l
- renamed --no-expand-iterators-inline-opt to --[no-]inline-iterators
- renamed --no-single-loop-iterator-opt to --[no-]optimize-loop-iterators
- removed the --chplhome flag
- removed the --flow-analysis flag
- made all optimization control flags into --[no-] flags
- added --[no-]dead-code-elimination to turn dead-code elimination off/on
- added --[no-]live-analysis to turn live variable analysis off/on

Generated Code Flags
--------------------
- added a -b/--blockreport flag to help debug deadlocked 1-locale programs
- added a -t/--taskreport flag to print a list of tasks for 1-locale programs
- made the -v flag print node names for locales on which code is executing
- made the -v flag print the commands used by the launcher

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- fixed some subtle race conditions in the pthreads version of the runtime
- fixed a bug in which write statements would not print atomically as intended
- fixed a bug in which multidimensional tuple-to-array assignment was failing
- fixed support for readXX() on single variables
- added some runtime checks to try and avoid integer wraparound in malloc sizes
- improved support for range slicing at extreme integer values
- made 1-tuple-style declarations illegal:  var (x) = ...;
- fixed a number of bugs related to generic function instantiation points
- fixed a bug in which casts on return expressions were ignored
- fixed a bug related to iterating over a single iterator class multiple times
- fixed a bug in which param functions with multiple returns corrupted constants

Error Message Improvements
--------------------------
- improved an error message related to illegal assignments of domains to arrays
- added an error check to prevent iteration over a type
- improved error messages related to bad tuple index types
- improved error messages related to iterators and promoted expressions
- added a warning about cobegin statements with fewer than two statements

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- made "here" into a per-locale variable, reducing communication
- optimized read-only non-local accesses to value types
- added initial support for privatizing global domain/array descriptors
- added initial support for optimizing zippered iteration over aligned arrays
- optimized coforall...on and begin...on idioms to reduce thread requirements
- added reference counting to domain classes to aid in freeing them

Compiler Performance and Cleanup
--------------------------------
- rewrote the compiler's symboltable
- added support for a BitVec class to save space and time
- tightened up memory leaks in the compiler
- specialized parameter tuple indexing for performance and fewer special cases
- reimplemented the IR traversal mechanism
- removed def/use information from the Symbol class to save space
- removed filename references from IR nodes to save space
- removed unused fields from internal classes
- reimplemented the caching data structures used in function resolution
- streamlined function instantiation when a function is not a viable candidate
- refactored and cleaned up the wrapper/generic function caching code
- applied reference propagation to functions just prior to inlining
- moved the prune pass prior to optimizations to save time
- optimized the verification pass by hoisting out back pointer checks
- optimized reference propagation to build smaller use/def sets
- optimized the scalar replacement pass to localize the iterative aspects
- improved the set of live references added/omitted from iterator classes
- eliminated lots of dead code

Testing System
--------------
- made the test system execute .numlocales tests on 1 locale for CHPL_COMM=none
- made the testing system set the CHPL_* environment variables if they aren't
- made the test system generate its output using relative paths
- fixed a bug in the testing system's "skipif" capability

Internal
--------
- added support for dynamically turning on/off communication and memory tracing
- improved debug output for the gasnet communication layer
- reorganized abstract distribution, domain, array classes
- generalized creation of runtime types
- renamed SingleLocale* classes for domains/arrays to Default* classes
- removed need for buildEmptyDomain methods within domain classes
- removed redundant type/param fields from array wrapper records
- simplified the AList class
- revamped implementation of pragmas and unified with various boolean flags
- added a --runtime flag to compile Chapel code into the runtime and used it
- removed --nostdincs developer compiler flag
- improved the format of the --print-statistics flag and added summary info
- made the --baseline flag into an aggregate flag
- fixed a bug with the --gdb flag in which quit and run would fail after errors
- improved the cleanup of temporary files when using the --gdb flag for gdb >6.6
- added support for developers to print references in 0x0000abcd form
- added a rootModule that contains the program module but is not codegen'd
- decoupled the visible functions data structure from the symbol table
- removed the need for the symboltable after scope resolution
- changed module representation of CHPL_* variables from enums to strings
- added support for compiler CHPL_* variables of type const char*
- added an internal traceback capability to unravel inlined functions
- changed the mechanism for specifying reserved symbol names needing mangling
- refactored reference propagation to share code with scalar replacement
- added debugging functionality to the scalar replacement pass
- replaced compute_sym_uses() with buildDefUseMaps() and for_defs/uses macros
- simplified and optimized the normalize pass
- removed the def/use map in function resolution
- added a promotion wrappers cache to avoid creating duplicate wrappers
- general cleanup of coercion wrapper code
- refactored instantiation code
- changed handling of on, begin, cobegin, coforall to use blocks, not nested fns
- reimplemented heap allocated variables
- changed arithmetic array of primes into function returning primes
- made all exits from the compiler use our clean exit routine



version 0.7
===========

Fourth preliminary release of Chapel Compiler, March 31, 2008

High-Level Themes
-----------------
- multi-locale task parallelism
- improved task parallel correctness, features, thread management
- improved stability of core features
- target audience: HPCS mission partners, select HPC/academic/industry users

Changes to Chapel Language
--------------------------
- added "new" keyword to invoke class/record constructors  
  e.g., "class C { ... }  var myC = C(...);" => "... var myC = new C(...);"
- enumerated types now require the type to be named before a component symbol  
  e.g., "enum myEnum {A, B, C}; var x = B;" => "... var x = myEnum.B;"
- changed a file's mode from a string to an enumeration  
  e.g., file(..., "r") => file(..., FileAccessMode.read)
- added "sync" statement to join dynamic parallelism  
  e.g., sync { /* create parallelism */ }  // waits here for parallelism to end
- added "here" constant to refer to the locale on which a task is executing
- added support for readXX and isFull on single variables
- added support for functions with type varargs  
  e.g., def foo(type t ...?numTypes) { ... }
- added support for vararg read()/readln() functions that return a tuple value  
  e.g., "read(int, float, string);" returns an (int, float, string) value
- added a sorted() iterator to associative domains/arrays and opaque arrays  
  e.g., var table: domain(string); ...  for entry in table.sorted() do ...
- added support for a compilerWarning() call similar to compilerError()  
  e.g., compilerWarning("I didn't expect this function to be called");
- added string relational operators  
  e.g., ..."hi" >= "bye"...
- removed the "of" keyword
- removed the "ordered" keyword and concept

Newly Implemented Features
--------------------------
- execution using multiple locales (see doc/README.multilocale)
- use of on clauses taking locale/lvalue expressions to generate remote tasks  
  e.g., "on Locales(i) do ...",  "var x = ...;  ...  on x do ..."
- use of <expression>.locale to query the locale on which an lvalue lives  
  e.g., "var x = ...;  ... x.locale ..."
- task pool to support the creation of more tasks than executing threads
  (see doc/README.threads for more details)
- added support for calling methods within class constructors
- improved support for member initializer expressions within classes
- strengthened distinction between type specifiers and constructor calls
- temporarily removed support for real(128), imag(128), complex(256)
- enumerated and opaque arrays now support iteration
- added support for tuples of sync variables
- added support for declaring enumerations within classes

Portability of code base
------------------------
- removed a number of warnings specific to particular compilers/platforms

Semantic Changes
----------------
- in a type context, (int) is no longer a 1-tuple of type int; use 1*int instead
- Chapel now parses types in the same way that it parses general expressions

Syntactic/Naming Changes
------------------------
- renamed opaque domain's .new() method to .create()
- renamed the (undocumented) Locales domain from LocalesDomain to LocaleSpace

Documentation
-------------
- new README files in the doc/ directory
  - README.multilocale file explains how to execute using multiple locales
  - README.threads explains how tasks are implemented using threads
- language specification revisions
  - greatly improved the "Parallelism and Synchronization" chapter
  - greatly improved the "Locality and Distribution" chapter
  - made other updates to reflect other changes mentioned in this file
  - removed most of the language overview section, believing it needs updating
- updated the quick reference document to include locality concepts
- updated HPCC documents to reflect "new" keyword and enumerated type qualifiers
- generally refreshed the README, CHANGES, STATUS files

Example Codes
-------------
- added new example codes
  - multilocale.chpl to serve as a multi-locale execution tutorial
  - taskParallel.chpl to serve as an introduction to task-parallel concepts
  - varargs.chpl to demonstrate the user of variable argument functions
- updated existing examples to reflect language changes
  - added "new" keyword to tests that create class instances
  - for tests that use files, changed access mode from string to enum
  - added enumeration type qualifiers to uses of enumerated types
  - changed opaque.chpl test to rename the opaque domain .create() method
- changed blockLU's input data to improve stability across compilers
- made automated testing of opaque.chpl deterministic

Standard Modules
----------------
- added a skipToNth() method to the RandomStream class

Compiler Flags
--------------
- changed flags to have a --no-... variation (see chpl man page for details)
  --local => --[no-]local where the default is based on CHPL_COMM
  --serial => --[no-]serial where the default is based on CHPL_THREADS
- added new flags (see chpl man page for details)
  --[no-]ieee-float controls the strictness of IEEE floating point operations
  --fast flag turns on optimizations & disables runtime checks and IEEE floats
  --explain-instantiation describes the instantiations of functions/types

Generated Code Flags
--------------------
- added a config const "maxThreads" to limit the number of threads per locale
  (see doc/README.threads for more information)
- made --help flag list built-in config consts/vars (numLocales, maxThreads)
- added a --quiet/-q flag to suppress runtime warnings

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- fixed support for arrays of arrays and arrays of syncs within classes
- fixed several bugs in the implementation of associative/opaque domains/arrays
- improved composability of forall expressions and coforall statements
- improved checks preventing the use of types in value contexts and vice-versa
- added checks for illegal control flow within parallel/sync/on statements
- added warning if locale is applied to an expression known to be local
- added a runtime warning when using distributions on more than 1 locale
- removed incorrect copies that were inserted for certain default argument types
- fixed ability to specify C source files with paths
- fixed a bug in which standalone reads of sync vars did not consume full/empty  
  e.g., "myflag$;" is now equivalent to "myflag$.readFE();"
- fixed a bug in the implementation of .length for degenerate ranges
- ensured user cannot create new locales
- prevented user from being able to modify a locale's id
- removed instantiation limit error messages generated by tuples
- fixed a bug with the --cpp-line flag for long generated C lines

Error Message Improvements
--------------------------
- improved error messages for generic type specifiers

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
(no significant ones in this release)

Compiler Performance and Cleanup
--------------------------------
- reduced memory footprint of certain compiler IR classes

Generated Code
--------------
- changed implementation of subclasses
- added support for remote references and remote classes
- improved line number reporting for certain functions
- renamed some identifiers to avoid initial underscores -- more remain
- improved name mangling policy
- changed integer type aliases to use stdint.h types
- turned up C compilation warning levels for developers

Testing System
--------------
- added support for listing any number of tests and directories on command-line
- removed -onetest and -startdir flags due to above support
- allowed start_test to be run from any directory
- removed support for Makefile-driven testing
- removed start_clean script
- added "skipif" support for skipping a test or directory based on env vars

Internal
--------
- unified implementation of cobegin/coforall to use begins
- use endCounts to implement cobegins/coforalls rather than syncStacks
- improved runtime TAGS file and added TAGS file for generated code
- improved unification/normalization of AST classes and primitives
- removed unnecessary primitives, types, symbols
- changed places in code where pragmas can occur
- converted from CVS to SVN
- made --ccwarnings into --[no-]ccwarnings where the default is based on --devel



version 0.6
===========

Third preliminary release of Chapel Compiler, December 21, 2007

High-Level Themes
-----------------
- single-locale, multiple threads
- improved stability of core features
- support for additional serial features
- improved single-threaded performance and memory utilization of generated code
- improved multi-threaded correctness, features
- improved compiler performance and memory utilization
- improved portability of compiler/runtime code and generated code
- support for cross-compilation environments
- target audience: HPCS mission partners, select HPC users and centers

Changes to Chapel Language
--------------------------
- added support for defining type functions  
  e.g., def myint(param x: bool) type { return if x then int(32) else int(64);}
- changed routines supported on sync/single variables and made them methods  
  e.g., var x: sync int;  x.writeXF(2);  if (x.isFull) { ... }
- added support for expression-level for and forall loops using keyword syntax  
  e.g., var A: [D] int = for i in D do foo(i);
- added support for readln() function which skips to EOL after reading its args
- added support for a main() function per module, resolvable via --main-module
- added support for translate, interior, exterior, and expand methods on ranges
- added support for membership test on ranges  
  e.g., var r: range = ...;  if (r.member(3)) { ... }
- added support for range/scalar arithmetic using +, -, *, /  
  e.g., (1..10) + 1 == 2..11; (1..10) * 2 == 2..20 by 2
- removed support for operations between scalars and tuples  
  e.g., (1, 2) + 3 is no longer supported; (1, 2) + (3, 4) still is
- added support for bitwise operators on int/uint pairs of the same size  
  e.g., int(32) & uint(32) => uint(32)

Newly Implemented Features
--------------------------
- added support for arrays of arrays whose inner arrays are of uniform size
- added support for arrays of domains
- added support for instantiating types/functions using array types  
  e.g., class C { type t; ... }   type vect = [1..n] int;   var myC: C(vect);
- implemented a reshape function for arrays
- initial implementation of opaque domains and arrays
- added support for slicing using unbounded and degenerate ranges  
  e.g., for A: [1..n, 1..n] real, A[2.., ..] is equivalent to A[2..n, 1..n]
- added support for rank change slicing of domains and arrays  
  e.g., var V: [1..n] int;  V = A[n/2 + 1, 1..n];
- relaxed requirements that slicer and slicee objects use the same integer type
- added support for | and & reductions over boolean aggregates
- added support for a clear() method on associative domains
- preliminary support for "on" statements with restricted functionality
- improved support for user-defined class constructors
- added support for runtime checks against nil class references  
  e.g., class C { ... }  var myC: C;   C.foo();  generates a nice error
- improved support for nested modules
- improved symbol resolution for external modules
- implicit enum-to-string coercions and explicit string-to-enum conversions
- initial support for controlling type-to-string formatting (doc/README.format)
- initial support for prototyping and calling extern C functions from Chapel
  (see doc/README.extern for more details)
- added support for generic function arguments of sync types  
  e.g., def foo(x: sync) { ... }
- improved support for garbage collection in single-threaded codes (see STATUS)
- improved tuple type orthogonality; they can now be used in most type contexts
- added support for strided param for loops

Portability of code base
------------------------
- added support for compiling with Intel, PGI, Pathscale, and Cray compilers
- added initial support for compiling for Cray MTA/XMT, X1s, and XTs
- improved portability of source and generated codes across compilers/platforms
- refactored Makefiles to better separate compiler settings from platforms
- added support for cross-compilation environments -- see doc/README.chplenv
- added mechanisms for selecting threading/communication libraries -- see "
- added native support for task parallelism on Cray MTA/XMT platforms

Semantic Changes
----------------
- removed implicit coercions from integer types to real(32)
- made queries of an array's domain via A.domain or A:[?D] constant
- removed dynamic dispatch on method calls with no parentheses
- user-defined constructors now squelch the creation of a default constructor
- redefined range and domain slicing to use intersection semantics
- changed location of instantiated generics to be their definition point
- defined semantics of default functions as being "return a const"
- function resolution now favors non-promoted functions as a tie-breaker
- better defined casts between complex, imaginary, real, and integral types

Syntactic/Naming Changes
------------------------
- added support for $ in identifier names; used by convention to identify syncs
- allow floating point literals with an exponent to use an integral base  
  e.g., can now write 1e4 rather than 1.0e4
- changed locale array name from Locale to Locales (as described in spec)
- added ability to tag a function as returning a const value for documentation

Documentation
-------------
- updates to the language specification
- updated CHANGES and STATUS files
- refreshed READMEs
- updated compiler man page and --help message
- added AGREEMENT file listing user agreement
- refreshed and refactored CONTRIBUTORS file

Example Codes
-------------
- added tutorial example for using arithmetic arrays (arrays.chpl)
- added tutorial example for using opaque arrays (opaque.chpl)
- converted all HPCC example codes to use 64-bit indices for their domains
- fixed a bug in the HPCC FFT calculation of GFlop/s
- renamed sync vars to use $ naming convention

Standard Modules
----------------
- added support for 32-bit math routines

Compiler Flags
--------------
- added new flags:
  --help-env : prints environment variables for each compiler flag
  --help-settings : prints current setting of each compiler flag
  --no-nil-checks : disables runtime checks for nil class references
  --no-checks : disables all runtime checks (currently nil & bounds checks)
  --main-module : selects between multiple possible program entry points
  --ldflags : supplies flags for the C link step
  --serial : disables all parallelism in a program
  --local : optimizes compilation for single-locale execution
  --no-scalar-replacement : disables the scalar replacement optimization
  --short-names : generates the C code using short variable names (T<#>)
  --make : specifies the GNU-compatible make utility used by the back-end
- removed flags:
  --parallel : became the default and was redundant with --serial
- added ability to specify .c, .o, and .h files for interfacing to C routines
- improved error-reporting for incorrect compiler flags
- compiler now parses all flags before any significant ones are acted upon
- better error checking for parsing config param values

Generated Code Flags
--------------------
- added new flags:
  -nl #/--numLocales=# flags for specifying the number of locales to use
  -v/--verbose flags for increasing the verbosity of the generated code
- improved error-reporting for incorrect flags
- improved parsing of config const/var values

Bug Fixes/New Semantic Checks (for old semantics)
-------------------------------------------------
- whole-array assignment of arrays of sync variables now works correctly
- += and -= are now supported on sync variables
- fixed bugs in sync variable read/write functions
- added checks for blocking sync var reads/writes when $CHPL_THREADS == none
- fixed associative domain/array bugs caused by removing indices
- added bounds checking for associative domain/array operations
- improved bounds checking for array slicing
- bounds checking for string.substring() arguments
- improved legality checks for string-to-value conversions
- added legal-value checking for casts from integers to enumerated types
- improved robustness of tensor function promotion  
  e.g., exp[A, B] where A and B are arrays
- improved checks preventing against assignment to const variables
- added check that actual arguments to inout or out formals are valid lvalues
- added check against returning constants from var functions
- added checks against assigning to consts and params
- fixed use of inout and out intents with variable-length argument lists
- default argument values specified using a function call now work properly  
  e.g., def foo(x = bar()) ...
- improved handling of unifying multiple returns from a single function
- improved checking that a function returns a value along all control paths
- return statements are now supported in type select statements
- type checking of LHS and RHS on op= assignments
- added ability for user to overload operators for uint(64)/int combinations
- improved error checks for the use of values in a type context and vice-versa
- support for overriding this() method in subclasses
- improved error checks for legal expressions to iterate over
- added semantic check for degenerate rank-change slicing

Error Message Improvements
--------------------------
- added filename/line# information to many error messages
- improved notation for types in error messages from ": t" to "type t"
- added warning when C-style ++ or -- are used; these are duplicated unary ops
- improved clarity of function prototypes in function resolution errors
- improved clarity of error for creating a domain with mixed integral types

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- improved performance for codes using type "complex"
- removed extraneous threads created by uses of the begin statement
- improved the performance of the bitMatMultOr routine in the BitOps module
- added strength reduction for ** with an exponent of 0-6 or 8
- added strength reduction for certain comparisons between uints and 0

Compiler Performance and Cleanup
--------------------------------
- improved performance of scalar replacement, copy propagation passes
- improved performance of compiling codes using type "complex"
- reduced memory requirements of compiler

Generated Code
--------------
- added support for generating code using short variable names (--short-names)

Testing System
--------------
- added support for Makefile-driven testing within a subdirectory
- added support for testing on multiple locales
- added support for "compilation only" testing to avoid running executables
- added support for the ability to specify a launch command to begin execution
- added the ability to suppress tests that are expected to fail
- added support for communication-layer-specific .good files

Internal
--------
- support for array type descriptor at runtime
- many refactorings and improvements to the compiler and runtime sources



version 0.5
===========
Second preliminary release of Chapel Compiler, June 29, 2007

High-Level Themes
-----------------
- single-locale, multiple threads
- support for additional serial features
- improved single-threaded performance, memory utilization
- improved multi-threaded correctness, features
- target audience: HPLS evaluation team, HPCS mission partners,
  select HPC users and centers

Changes to Chapel Language
--------------------------
- eliminated Chapel's sequence type
  - in the future, a standard List library will provide similar functionality
  - removed # and #= operators, since they were designed for sequences
  - removed support for sequence literals; use tuple syntax instead  
    e.g., var A: [1..3] real = (0.1, 2.3, 4.5);
  - removed support for casting sequences to tuples and tuples to sequences
  - iterators in an expression context now result in a 1D, 1-based array  
    e.g., "iterator foo() {...}  var A = foo();" creates a 1D array over [1..]
- added "range" type to language to replace old "arithmetic sequence" concept  
  e.g., "lo..hi" or "lo..hi by str" are ranges
  - open interval syntax supported for ranges  
    e.g., "[lo..hi)" is equivalent to lo..hi-1
  - +, -, *, / operators supported for range/scalar combinations
- added coforall loop construct for expressing explicit task parallelism  
  e.g., "coforall 1..4 do ..." will create four explicit tasks
- removed "iterator" keyword -- iterators are now functions that contain yields
- added support for defining a default ("these") iterator for classes/records
- added support for creating array aliases  
  e.g., "var Amid => A[2..n-1, 2..n-1];" creates an alias, Amid, to the slice
- support for standard math, bitwise, and comparison operators for tuples  
  e.g., "(i,j) + (1,-1)" yields "(i+1, j-1)"
- added a swap operator: <=>  
  e.g., "a <=> b" is semantically equivalent to "const t = b; b = a; a = t;"
- better support for writing output
  - enabled support for writing to strings using a write() method  
    e.g., var s: string;  s.write("x is: ", x);
  - added a Writer class that enables user classes to be written to
  - added writeThis() method to specify how a type should be output to a Writer
- added minloc and maxloc reductions that return min/max value and index  
  e.g., var (minVal, minInd) = minloc reduce (A, A.domain);
- changed arithmetic domain range access from D(<dim#>) to D.dim(<dim#>)  
  e.g., var rows = D.dim(1);
- arithmetic domains and arrays support low and high methods that return bounds  
  e.g., var loInd = A.low;
- support for range, domain, and array slicing via bounded or unbounded ranges  
  e.g., "A[2.., ..n]" is equivalent to "A[2..A.dim(1).high, A.dim(2).low..n]"
- support for promoting casts across array elements  
  e.g., var x: [1..4] real, y: [1..4] int;  y = x:int;
- added support for param functions that support compile-time evaluation  
  e.g., "def square(param x) param { return x**2; }  param n2 = square(14);"
- support for default values for param members of classes  
  e.g., class C { param bitWidth = 32; ... }
- support for top-level 0-argument functions without parentheses  
  e.g., def f { writeln("In function f"); }
  - allow "main" function to be declared with or without parentheses  
    e.g., def main { writeln("Program will start here"); ... }
- allow "<index> in" to be elided in for/forall loops/expressions  
  e.g., "for 1..n { ... }", "var A = [1..n] 0.0;"
- support for multiple modules to be listed within a single "use" statement
- added support for reading a value of a specified type from a file  
  e.g., "var myint = infile.read(int);"

Newly Implemented Features
--------------------------
- support for sparse domains/arrays
  - assignment of aggregate index expressions to sparse domains
  - accumulation of indices into sparse domains using +=
  - re-assignment of a sparse array's "zero" value using the .IRV field
  - clear() method for emptying a sparse domain's index set
- arrays of sync variables are now supported
- added support for partially and fully unbounded ranges ("lo..", "..hi", "..")
- enumerated domains and arrays
- support for a numCores() function on the locale type to query # of cores
- subBlocks iterator on domains now generates a sub-block per processor core
- support for nested classes, records, and iterators
- serial statement
- added support for using "_" to ignore elements during tuple destructuring  
  e.g., var t: (int, real) = ...;   (t1, _) = t;
- added support for nested tuple destructuring in variable decls/formal args
- support for config params of primitive and enumerated types
- initial support for accessing a module's members via modname.membername
- implemented dynamic casts between class types
- added initial support for copy collection-based garbage collection
- subdomain keyword is now supported, though subset relationship is not checked
- initial support for specifying a distribution class; interface still in flux

Syntactic/Naming Changes
------------------------
- removed support for using "?" in identifier names
  - changed standard method member? to member
  - changed standard method true? to isTrue
- removed support for "--" as a single-line comment style;  use "//"
- an array's domain should now be accessed via A.domain rather than A.dom
- array element type identifier changed from elt_type to eltType
- made file open/close methods take parentheses
- renamed "indefinite domains/arrays" to "associative domains/arrays"

Semantic Changes
----------------
- changed relative precedence of casts and unary +/- (unary +/- is now tighter)  
  e.g., -2:uint(32) is equivalent to (-2):uint(32) rather than -(2:uint(32))
- for/forall loops over arrays now result in references to elements, not copies  
  e.g., "for e in A do e = 0;" could be used to zero out an array
- enumerated types now start counting at "1" rather than "0" by default
- conditional expressions are no longer valid l-values
- improved semantics of module use transitivity, nested modules
- removed support for structural iterator interface (getHeadCursor, etc.)
- nested classes can refer to their outer class using the identifier "outer"
- initial support for querying parameters/types in a formal class argument
  - similar support for variable-length argument lists of generics
- where clauses can now compare against formal generic types
- short-circuiting operators only require isTrue rather than true? & false?
- in x op=y, a cast to x.type is used in assigning back to x if it is primitive
- compilerError() can now take multiple arguments like a halt()
- replaced setter/getter functions with richer support for var functions

Documentation
-------------
- added man page for Chapel compiler (chpl)
- added CHANGES file
- added Quick Reference document
- added language overview chapter to the specification
- updated HPCC tutorial document and broke into two docs: overview and tutorial
- updated STATUS file
- cleaned up README files a bit

Example Codes
-------------
- added README.features file to map Chapel features to examples that use them
- several improvements to the HPCC benchmarks due to bug fixes, new features
- added several new examples:
  - iterators example to demonstrate use of iterators
  - linkedList example for nested, generic, iteratable, printable classes
  - parallelQuickSort example to demonstrate serial/cobegin statements
  - blockLU example to demonstrate domain slicing, array aliases, swap
  - sparse example to demonstrate sparse domains and arrays
  - slices example to demonstrate array slicing and reindexing
  - reductions example to demonstrate minloc/maxloc reductions
  - fileIO example to demonstrate simple use of file I/O
- rewrote the producer-consumer example to use a buffer of sync variables
- added a hello-module example to demonstrate simple Chapel program structure
- improved the comments for several tests
- removed stream-nopromote.chpl example, which had become redundant
- combined the two genericStack examples into a single file
- added performance testing support for stream.chpl and ra.chpl

Standard Modules
----------------
- Search: new standard module
- Sort: new standard module
- Types: numBits() and numBytes() are now param functions
- Random: fillRandom() routines now work for arrays of arbitrary rank

Compiler Flags
--------------
- improved the formatting of the --help message
- added -g flag for debugging generated code; turns on --cpp-lines by default
- added -O flag for optimizing generated code
- added -s/--set for setting config params
- added --explain-call flag that helps describe how a function call is resolved
- added --baseline flag to disable all compiler optimizations
- added --no-flow-analysis flag that disables all flow-based optimizations
- added --no-warnings flag to disable all compiler warnings
- added --no-single-loop-iterator-opt flag to disable 1-loop iterator rewrites
- added --no-expand-iterators-inline-opt flag to disable iterator inlining
- removed --unoptimized flag
- removed --cg-chpl-lineno flag; this capability is now always on
- removed --no-gc used for a stopgap reference counting scheme

Generated Code Flags
--------------------
-- added a --gdb flag to make it easier to debug generated code

Bug Fixes/New Semantic Checks (for old Semantics)
-------------------------------------------------
- test expressions in loops/conditionals restricted to bools, classes, integers
- runtime checks added to ensure that zippered iterations are of equal size
- fixed portability issues in flex lexer file, chapel.lex
- domains are now passed by reference by default
- implemented bytesPerLocale for Macintosh
- classes can now have iterator methods
- recursive iterators now work
- "true + true" now yields "2" rather than "true"
- casts from uints to complexes now supported
- casts from integral types to enumerated types now supported
- initial support for casts from strings to primitive types
- modules can now refer to param values and types from other modules correctly
- disabled parameter folding of floating point values
- parameter folding of relational operators on enum types
- parameter folding of short-circuiting &&, ||, and conditional expressions
- type aliases can now be created for array types
- fixed numerical bugs in array slicing and reindexing
- config variable initializers are no longer evaluated if set on command-line
- const values can no longer be passed to arguments with inout or out intent
- constructor keyword no longer supported -- use def <classname> instead
- fixed "bug" with log2 on integers and made it halt on zero or negatives
- improved thread safety of generated code
- made creation of too many threads result in halt() rather than lost work
  - eventually we'll need to queue up tasks; this is a stopgap
- passing unions to out/inout intents now works
- better semantic checking of legal l-values
- fixed an infinite loop bug in associative domains/arrays

Error Message Improvements
--------------------------
- added message to compiler warning that "atomic" is unimplemented when used
- caused compiler to complain about non-module scope configuration variables
- unified runtime and compiler error message formats
- runtime errors identify source file/line#
- improved quality of compilerError() error message output
- cleaned up syntax error messages
- improved error message for tuples of non-param size
- improved error reporting when attempting to assign to constants
- better error checking of legal vs. illegal casts
- generally improved quality of compiler error messages

Compiler Analysis and Optimizations/Performance of Generated Code
-----------------------------------------------------------------
- removed the insertion of all large sequence/array temporaries
- extensive optimizations of iterators and loop generation
- global/local copy propagation
- dead variable elimination
- dead code elimination
- live variable analysis
- reaching definitions analysis
- def-use and use-def chains

Compiler Performance and Cleanup
--------------------------------
- improvements to function resolution, vararg function instantiation
- made compiler build with debugging off/optimizations on for non-developers
- removed unused scalar replacement code
- renamed and refactored internal modules
- removed old reference counting code
- optimized several passes to improve compile time

Generated Code
--------------
- now generating structured loops rather than gotos and labels
- large reduction in lines of generated code  
  e.g., ~40% reduction in lines of code for jacobi example (13275 -> 7753)
- module functions generated in order, with comments to identify source line #
- _chpl_header.h file is generated in a cleaner manner
- changed munging of variable names to improve gdb support and readability
- using pragmas, generated code has been shown to vectorize on X1/thread on MTA
- initial support for cross-compiling to the XT

Testing System
--------------
- added support for doing performance-tracking experiments

Internal
--------
- new IR traversal mechanisms
- flow analysis optimization framework
- vararg functions handled within function resolution
- parameter folding folded into function resolution
- new compiler gdb commands: lv (list view)
- domain and array wrappers now implemented as records
- improved creation of init functions
- removed ability to cast primitives to strings by casting to "%<format>"
- new mechanism for indicating that a class is promotable
- added AND_EXPAND and PRIMITIVE_TUPLE_AND_EXPAND
- added reference types



version 0.4
===========
Preliminary release of Chapel Compiler, December 15, 2006

High-Level Themes
----------------
- single-locale, multiple threads
- support for base language features
- designed for correctness over performance
- target audience: HPLS language evaluation team and HPCS mission partners
