/*
 * Copyright 2004-2019 Cray Inc.
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "driver.h"
#include "files.h"
#include "passes.h"
#include "stringutil.h"
#include "symbol.h"

#include <set>

// Create commands to compile the server and client subprograms.
void compileSubprograms() {
  std::string compileClient = "chpl --library-client";
  std::string compileServer = "chpl --library-server";

  if (strcmp(savedArgv[0], "chpl") != 0) {
    // Don't expect this to trigger but just in case ...
    INT_FATAL("unexpected first command argument");
  }

  bool handledNaming = false;
  for (int i = 1; i < savedArgc; i++) {
    // TODO: .chpl may be in the middle of the string, in which case we don't
    // care
    if (strstr(savedArgv[i], ".chpl") != NULL) {
      compileServer += astr(" ", savedArgv[i]);
    } else if (strcmp(savedArgv[i], "-o") == 0 ||
               strcmp(savedArgv[i], "--output") == 0) {
      if (i+1 == savedArgc) {
        INT_FATAL("somehow didn't check flags were correct");
      }
      compileClient += astr(" ", savedArgv[i], " ", savedArgv[i+1]);
      compileServer += astr(" ", savedArgv[i], " ", savedArgv[i+1]);
      // distinguish between the two programs we are going to create
      compileServer += "_server";
      // Skip the next arg, we already handled it
      handledNaming = true;
      i++;
    } else {
      compileClient += astr(" ", savedArgv[i]);
      compileServer += astr(" ", savedArgv[i]);
    }
  }

  if (!handledNaming) {
    compileServer += astr("-o ", executableFilename, "_server");
  }
  // Is this right?  Might need to do something more complicated to aggregate
  // pass timing, get lldb/gdb to respect it, etc.  Also, run in parallel?
  runCommand(compileClient);
  runCommand(compileServer);
}

// When compiling with `--library` in settings when Chapel code should be
// prepped for launching or running in a distributed fashion, we want to create
// and compile two separate versions of the program.
void distributedLibraries() {
  // need int argc, char* argv[]

  // TODO: extend to support `--no-local` and `CHPL_LAUNCHER` != "none"
  if (fLibraryCompile && strcmp(CHPL_COMM, "none") != 0) {
    // Want to have two source files.  One will be the original, but with a
    // different name and a new main routine.  The other will have the same
    // name as the original, but will only contain the exported functions and
    // will replace their body with different code.
    std::string duplicateFile = "cp ";
    // TODO: finish making the two programs

    // Get all the exported functions in the program
    std::vector<FnSymbol*> exported;
    // Determine parent modules (we need to `use` these to call the exported
    // functions from the inserted main() routine)
    std::set<ModuleSymbol*> parentMods;

    forv_Vec(FnSymbol, fn, gFnSymbols) {
      if (fn->hasFlag(FLAG_EXPORT)) {
        ModuleSymbol* parentMod = fn->getModule();
        if (parentMod->modTag != MOD_INTERNAL) {
          exported.push_back(fn);
          parentMods.insert(parentMod);
        }
      }
    }
    // TODO: compute known "function name"->"id" translation now and determine
    // way to communicate that to the two programs.
    // e.g. maybe an array in a .h file that gets put in a known location or
    // something.

    compileSubprograms();

    // TODO: clean exit, nothing left to do after the two compilation
    // commands have run (likely)
  }
}
