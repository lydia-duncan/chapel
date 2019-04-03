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
#include "passes.h"

// When compiling with `--library` in settings when Chapel code should be
// prepped for launching or running in a distributed fashion, we want to create
// and compile two separate versions of the program.
void distributedLibraries() {
  // need int argc, char* argv[]

  // TODO: extend to support `--no-local` and `CHPL_LAUNCHER` != "none"
  if (fLibraryCompile && !strcmp(CHPL_COMM, "none")) {
    // Want to have two source files.  One will be the original, but with a
    // different name and a new main routine.  The other will have the same
    // name as the original, but will only contain the exported functions and
    // will replace their body with different code.
    std::string duplicateFile = "cp ";
    //

  }
}
