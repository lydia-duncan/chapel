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

#include "AstToText.h"
#include "codegen.h"
#include "driver.h"
#include "files.h"
#include "mysystem.h"
#include "passes.h"
#include "stlUtil.h"
#include "stmt.h"
#include "stringutil.h"
#include "symbol.h"

#include <fstream>
#include <set>

void stampOutClientProcs(FnSymbol* fn, std::ofstream* clientFile) {
  *clientFile << "export proc ";

  AstToText info;
  info.appendNameAndFormals(fn);

  *clientFile << info.text();

  switch (fn->retTag) {
  case RET_REF:
    *clientFile << " ref";
    break;

  case RET_CONST_REF:
    *clientFile << " const ref";
    break;

  case RET_PARAM:
    *clientFile << " param";
    break;

  case RET_TYPE:
    *clientFile << " type";
    break;

  default:
    break;
  }

  // Print return type.
  if (fn->retExprType != NULL) {
    AstToText info;

    info.appendExpr(fn->retExprType->body.tail, true);
    *clientFile << ": ";
    *clientFile << info.text();
  }

  // Print throws
  if (fn->throwsError()) {
    *clientFile << " throws";
  }

  *clientFile << " { " << std::endl;

  // TODO: contents of exported function based on template instead of hard-coded
  *clientFile << "\tchpl_fnCallSocket.send(1);" << std::endl;
  *clientFile << "\tchpl_fnCallSocket.recv(int);" << std::endl;

  *clientFile << "}" << std::endl << std::endl;
}

// Create commands to compile the server and client subprograms.
void compileSubprograms(const char* serverFile, const char* clientFile) {
  std::string compileClient = "chpl --library-client";
  std::string compileServer = "chpl --library-server";

  if (strcmp(savedArgv[0], "chpl") != 0) {
    // Don't expect this to trigger but just in case ...
    INT_FATAL("unexpected first command argument");
  }

  bool handledNaming = false;
  bool handledComm = false;
  bool handledLauncher = false;
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
      // distinguish between the two programs we are going to create
      std::string serverExecName = astr("chpl_", savedArgv[i+1], "_server");
      compileClient += astr(" ", savedArgv[i], " ", savedArgv[i+1]);
      compileServer += astr(" ", savedArgv[i], " ", serverExecName.c_str());

      std::string replaceProgName = "sed -e 's/chpl_distLibServerMain/";
      replaceProgName += serverExecName;
      replaceProgName += astr("/g' ", clientFile);
      replaceProgName += astr(" > ", clientFile, ".tmp");
      runCommand(replaceProgName);
      std::string putItBack = astr("mv ", clientFile, ".tmp ", clientFile);
      runCommand(putItBack);

      handledNaming = true;
      // Skip the next arg, we already handled it
      i++;
    } else if (strcmp(savedArgv[i], "--comm") == 0) {
      // Handle explicit overrides of --comm by replacing them with --comm=none
      // for the client compilation.
      compileClient += astr(" ", savedArgv[i], "=none");
      compileServer += astr(" ", savedArgv[i], " ", savedArgv[i+1]);
      // Skip the next arg, we already handled it
      handledComm = true;
      i++;
    } else if (strcmp(savedArgv[i], "--launcher") == 0) {
      // Handle explicit overrides of --launcher by replacing them with
      // --launcher=none for the client compilation.
      compileClient += astr(" ", savedArgv[i], "=none");
      compileServer += astr(" ", savedArgv[i], " ", savedArgv[i+1]);
      // Skip the next arg, we already handled it
      handledLauncher = true;
      i++;
    } else {
      compileClient += astr(" ", savedArgv[i]);
      compileServer += astr(" ", savedArgv[i]);
    }
  }

  // If we didn't already modify a -o/--output flag, add one here
  if (!handledNaming) {
    std::string serverExecName = astr("chpl_", executableFilename, "_server");
    compileClient += astr(" -o ", executableFilename);
    compileServer += astr(" -o ", serverExecName.c_str());

    std::string replaceProgName = "sed -e 's/chpl_distLibServerMain/";
    replaceProgName += astr(serverExecName.c_str(), "/g' ", clientFile);
    replaceProgName += astr(" > ", clientFile, ".tmp");
    if (printSystemCommands) {
      printf("%s\n", replaceProgName.c_str());
    }
    runCommand(replaceProgName);
    std::string putItBack = astr("mv ", clientFile, ".tmp ", clientFile);
    if (printSystemCommands) {
      printf("%s\n", putItBack.c_str());
    }
    runCommand(putItBack);
  }

  if (!handledComm) {
    compileClient += " --comm=none";
  }
  if (!handledLauncher) {
    compileClient += " --launcher=none";
  }

  // Append the generated files to the appropriate command.
  compileClient += astr(" ", clientFile);
  compileServer += astr(" ", serverFile);

  // Is this right?  Might need to do something more complicated to aggregate
  // pass timing, get lldb/gdb to respect it, etc.  Also, run in parallel?
  if (printSystemCommands) {
    printf("%s\n", compileServer.c_str());
  }
  runCommand(compileServer);
  if (printSystemCommands) {
    printf("%s\n", compileClient.c_str());
  }
  runCommand(compileClient);

  // TODO: clean up our generated files we create from the templates so they
  // don't clutter the user's space.
}

void insertSelectClauses(const char* serverFilename, const char* templateLoc,
                         FnSymbol* fn) {
  std::string fullTemplateFilename = templateLoc;
  // TODO: ensure this is right for returning functions at this point in
  // compilation
  if (fn->retExprType != NULL) {
    fullTemplateFilename += "serverLoopBody-ret.chpl";
  } else {
    fullTemplateFilename += "serverLoopBody-noret.chpl";
  }

  std::string insertionStr = "\\/\\/ end of cases";
  std::string replaceCmd = astr("sed -e \"s/", insertionStr.c_str(), "/");
  replaceCmd += astr("$(sed 's:/:\\\\/:g' ", fullTemplateFilename.c_str());
  replaceCmd += astr(")", insertionStr.c_str(), "/\" ", serverFilename);
  replaceCmd += astr(" > ", serverFilename, ".tmp");

  runCommand(replaceCmd);
  std::string putItBack = astr("mv ", serverFilename, ".tmp ", serverFilename);
  runCommand(putItBack);
}

// When compiling with `--library` in settings when Chapel code should be
// prepped for launching or running in a distributed fashion, we want to create
// and compile two separate versions of the program.
void distributedLibraries() {
  // fLibraryClient indicates that we have already performed this action for
  // the source files.
  // TODO: extend to support `--no-local` and `CHPL_LAUNCHER` != "none"
  if (fLibraryCompile && !fLibraryClient
      && strcmp(CHPL_COMM, "none") != 0) {
    // in case -o/--output wasn't used, we need to determine the intended
    // executable filename (since the addition of the templates might change the
    // behavior, we need to assert what it would have been otherwise to preserve
    // the user's experience).
    setupDefaultFilenames();

    // Location of the template files
    // TODO: make this configurable?
    const char* templateLoc = astr(CHPL_HOME, "/compiler/templates/");
    // TODO: check generated file location when chpl called from different
    // directory than the original sources.  Ensure we clean it up appropriately
    const char* serverFilename = astr("chpl_", executableFilename,
                                      "_server.chpl");
    const char* clientFilename = astr("chpl_", executableFilename,
                                      "_client.chpl");

    // Want to have two source files.  One will be the original, but with a
    // different name and a new main routine.  The other will only contain the
    // exported functions and will replace their body with different code.
    std::string makeServerFile = astr("cp ", templateLoc);
    makeServerFile += "distLibServerMain.chpl ";
    makeServerFile += serverFilename;

    std::string makeClientFile = astr("cp ", templateLoc);
    makeClientFile += "distLibClient.chpl ";
    makeClientFile += clientFilename;

    runCommand(makeServerFile);
    runCommand(makeClientFile);
    // TODO: replace "distLibServerMain" in client file with the server's
    // executable name

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

    std::ofstream clientFile;
    clientFile.open(clientFilename, std::ofstream::out | std::ofstream::app);
    // Insert exported function headers into the client file
    for_vector(FnSymbol, fn, exported) {
      stampOutClientProcs(fn, &clientFile);
    }
    clientFile.close();

    // Insert code for calling the exported functions into the server file.
    for_vector(FnSymbol, fn, exported) {
      insertSelectClauses(serverFilename, templateLoc, fn);
    }

    std::ofstream serverFile;
    serverFile.open(serverFilename, std::ofstream::out | std::ofstream::app);
    // Insert uses of the modules containing exported functions into the server
    // file, so that it can call the exported functions.
    serverFile << "use ";
    bool firstMod = true;
    for_set(ModuleSymbol, mod, parentMods) {
      if (!firstMod) {
        serverFile << ", ";
      }
      serverFile << mod->name;
    }
    serverFile << ";" << std::endl;
    serverFile.close();

    compileSubprograms(serverFilename, clientFilename);

    // Everything else to do with the program itself is handling by the
    // subprogram compilations.  No need to perform further actions.
    USR_STOP();
    clean_exit(0);
  }
}
