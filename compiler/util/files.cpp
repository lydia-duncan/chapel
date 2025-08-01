/*
 * Copyright 2020-2025 Hewlett Packard Enterprise Development LP
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

// Get realpath on linux
#ifdef __linux__
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE 600
#endif
#ifndef _XOPEN_SOURCE_EXTENDED
#define _XOPEN_SOURCE_EXTENDED 1
#endif
#endif

#include "files.h"

#include "chpl/util/filesystem.h"
#include "chpl/util/subprocess.h"

#include "beautify.h"
#include "driver.h"
#include "llvmVer.h"
#include "library.h"
#include "misc.h"
#include "mli.h"
#include "mysystem.h"
#include "stlUtil.h"
#include "stringutil.h"

#include <pwd.h>
#include <unistd.h>

#include <cstring>
#include <fstream>
#include <sstream>
#include <iostream>
#include <cstdlib>
#include <cerrno>
#include <string>
#include <string_view>
#include <map>
#include <unordered_set>
#include <utility>

#include <sys/types.h>
#include <sys/stat.h>

#include "llvm/Support/Path.h"
#include "llvm/Support/FileSystem.h"


std::string executableFilename;
std::string libmodeHeadername;
std::string fortranModulename;
std::string pythonModulename;
std::string saveCDir;

const char* additionalFilenamesListFilename = "additionalSourceFiles.tmp";

std::string ccflags;
std::string ldflags;
bool ccwarnings = false;

std::vector<const char*>   incDirs;
std::vector<const char*>   libDirs;
std::vector<const char*>   libFiles;
static const char* incDirsFilename = "incDirs.tmp";
static const char* libDirsFilename = "libDirs.tmp";
static const char* libFilesFilename = "libFiles.tmp";

static void addPath(const char* pathVar, std::vector<const char*>* pathvec) {
  char* dirString = strdup(pathVar);

  char* colon;              // used to refer to ':'s in dirString

  do {
    colon = strchr(dirString, ':'); // are there colon separators?
    if (colon != NULL) {
      *colon = '\0';                      // if so, cut the string there
      colon++;                            // and advance to the next
    }

    // FIXME (Maybe?)
    // Following the precedent of $PATH on Unix, we should
    // treat empty strings between colons like  :: or trailing/leading
    // colons as meaning to add the current directory to the path.
    // If we don't include the current directory in the CHPL_LIB_PATH by
    // default, this behavior below is incorrect, and instead of ignoring
    // empty strings, it should figure out the current directory and add
    // that to the path.
    // Alternatively, we can alter the compiler to throw -L . when
    // CHPL_LIB_PATH has empty strings in between colons.
    // However, if we do include the current directory in CHPL_LIB_PATH
    // by default, then this doesn't need fixing, delete this FIXME.

    // ignore empty strings
    if (dirString && strlen(dirString) > 0) {
      pathvec->push_back(astr(dirString));
    }

    dirString = colon;                     // advance dirString
  } while (colon != NULL);
}

//
// Convert a libString of the form "foo:bar:baz" to entries in libDirs
//
void addLibPath(const char* libString, bool fromCmdLine) {
  addPath(libString, &libDirs);

  if (fDriverCompilationPhase && !fromCmdLine) {
    saveDriverTmp(libDirsFilename, libString);
  }
}

void addLibFile(const char* libFile, bool fromCmdLine) {
  // use astr() to get a copy of the string that this vector can own
  libFiles.push_back(astr(libFile));

  if (fDriverCompilationPhase && !fromCmdLine) {
    saveDriverTmp(libFilesFilename, libFile);
  }
}

void addIncInfo(const char* incDir, bool fromCmdLine) {
  addPath(incDir, &incDirs);

  if (fDriverCompilationPhase && !fromCmdLine) {
    saveDriverTmp(incDirsFilename, incDir);
  }
}

// Ensure the tmp dir is set up for use by the driver (i.e., isn't about to be
// replaced).
static void checkDriverTmp() {
  assert(!fDriverDoMonolithic && "meant for use in driver mode only");

  bool valid = false;
  if (driverTmpDir.empty()) {
    // We are in an initial invocation, all good.
    valid = true;
  }
  if (gContext->tmpDir() == driverTmpDir) {
    // In subinvocation and context's tmp dir has been set to driver
    // specification, all good.
    valid = true;
  }

  // Reassure some compilers that this variable is not unused.
  std::ignore = valid;
  assert(
      valid &&
      "attempted to save info to tmp dir before it is set up for driver use");
}

void saveDriverTmp(const char* tmpFilePath, std::string_view stringToSave,
                   bool appendNewline) {
  saveDriverTmpMultiple(tmpFilePath, {stringToSave}, !appendNewline);
}

void saveDriverTmpMultiple(const char* tmpFilePath,
                           std::vector<std::string_view> stringsToSave,
                           bool noNewlines) {
  checkDriverTmp();

  const char* pathAsAstr = astr(tmpFilePath);

  // Driver tmp files that have been written into so far in this run.
  // Used to make sure info remaining from previous runs (i.e., due to savec) is
  // discarded on first write.
  // Contents expected to be astrs so it's safe to use a set.
  static std::unordered_set<const char*> seen;

  // Overwrite on first use in driver compilation phase or init process, append
  // after.
  const char* fileOpenMode;
  if (seen.emplace(pathAsAstr).second && !fDriverMakeBinaryPhase) {
    fileOpenMode = "w";
  } else {
    // Already seen
    fileOpenMode = "a";
  }

  // Write into tmp file
  fileinfo* file = openTmpFile(pathAsAstr, fileOpenMode);
  for (auto stringToSave : stringsToSave) {
    fprintf(file->fptr, "%s%s", stringToSave.data(), (noNewlines ? "" : "\n"));
  }
  closefile(file);
}

void restoreDriverTmp(const char* tmpFilePath,
                      std::function<void(std::string_view)> restoreSavedString) {
  assert(!fDriverDoMonolithic && "meant for use in driver mode only");

  // Create file iff it did not already exist, for simpler reading logic in the
  // rest of the function.
  fileinfo* tmpFileDummy = openTmpFile(tmpFilePath, "a");
  const char* path = tmpFileDummy->pathname;
  closefile(tmpFileDummy);

  std::ifstream fileStream(path);
  std::string line;
  while (std::getline(fileStream, line)) {
    restoreSavedString(line);
  }
}

void restoreDriverTmpMultiline(
    const char* tmpFilePath,
    std::function<void(std::string_view)> restoreSavedString) {
  std::ostringstream os;

  // Just call line-by-line restore for simplicity, adding newlines back in.
  restoreDriverTmp(tmpFilePath,
                   [&os](std::string_view line) { os << line << "\n"; });

  restoreSavedString(os.str());
}

void restoreLibraryAndIncludeInfo() {
  INT_ASSERT(fDriverMakeBinaryPhase &&
             "should only be restoring library and include info in driver "
             "makeBinary phase");

  restoreDriverTmp(libDirsFilename, [](std::string_view filename) {
    addLibPath(filename.data(), /* fromCmdLine */ false);
  });
  restoreDriverTmp(libFilesFilename, [](std::string_view filename) {
    addLibFile(filename.data(), /* fromCmdLine */ false);
  });
  restoreDriverTmp(incDirsFilename, [](std::string_view filename) {
    addIncInfo(filename.data(), /* fromCmdLine */ false);
  });
}

void restoreAdditionalSourceFiles() {
  INT_ASSERT(fDriverMakeBinaryPhase &&
             "should only be restoring filenames in driver makeBinary phase");

  std::vector<const char*> additionalFilenames;
  restoreDriverTmp(additionalFilenamesListFilename,
                   [&additionalFilenames](std::string_view filename) {
                     additionalFilenames.push_back(astr(filename));
                   });
  addSourceFiles(additionalFilenames.size(), &additionalFilenames[0]);
}

void ensureDirExists(const char* dirname, const char* explanation,
                     bool checkWriteable) {
  // forward to chpl::ensureDirExists(), check for errors, and report them
  std::string dirName = std::string(dirname);
  if (auto err = chpl::ensureDirExists(dirName)) {
    USR_FATAL("creating directory %s failed: %s\n", dirname,
                   err.message().c_str());
  }

  // check writeability if we need it
  if (checkWriteable && !chpl::isPathWriteable(dirName)) {
    USR_FATAL("write permission denied for directory %s", dirname);
  }
}

void deleteDir(const char* dirname) {
  auto err = chpl::deleteDir(std::string(dirname));
  if (err) {
    USR_FATAL("removing directory %s failed: %s\n",
              dirname,
              err.message().c_str());
  }
}

const char* genIntermediateFilename(const char* filename) {
  const char* slash = "/";

  return astr(gContext->tmpDir().c_str(), slash, filename);
}

const char* getDirectory(const char* filename) {
  const char* filenamebase = strrchr(filename, '/');
  if (filenamebase == NULL) {
    return astr(".");
  } else {
    const int pos = filenamebase - filename;
    std::string dir(filename, pos);
    return astr(dir);
  }
}

const char* stripdirectories(const char* filename) {
  const char* filenamebase = strrchr(filename, '/');

  if (filenamebase == NULL) {
    filenamebase = filename;
  } else {
    filenamebase++;
  }
  const char* strippedname = astr(filenamebase);

  return strippedname;
}

const char* objectFileForCFile(const char* inputFilename) {
  const char* pathlessFilename = stripdirectories(inputFilename);
  const char* objFilename = genIntermediateFilename(astr(pathlessFilename, ".o"));
  return objFilename;
}

FILE* openfile(const char* filename,
               const char* mode,
               bool        fatal) {
  FILE* newfile = fopen(filename, mode);

  if (newfile == NULL) {
    if (fatal == true) {
      USR_FATAL("opening %s: %s", filename, strerror(errno));
    }
  }

  return newfile;
}


void closefile(FILE* thefile) {
  if (thefile == nullptr) return;

  int rc = fclose(thefile);
  if (rc != 0) {
    USR_FATAL("closing file: %s", strerror(errno));
  }
}


void openfile(fileinfo* thefile, const char* mode) {
  thefile->fptr = openfile(thefile->pathname, mode);
}


void closefile(fileinfo* thefile) {
  closefile(thefile->fptr);
  thefile->fptr = nullptr;
}


void openCFile(fileinfo* fi, const char* name, const char* ext) {
  if (ext)
    fi->filename = astr(name, ".", ext);
  else
    fi->filename = astr(name);

  fi->pathname = genIntermediateFilename(fi->filename);
  openfile(fi, "w");
}

void closeCFile(fileinfo* fi, bool beautifyIt) {
  closefile(fi);
  //
  // We should beautify if (1) we were asked to and (2) either (a) we
  // were asked to save the C code or (b) we were asked to codegen cpp
  // #line information (note that this can affect the output in the
  // event of a failed C compilation whether or not the --savec option
  // is used because a C codegen error will report the Chapel line #,
  // which can be helpful.
  //
  // TODO: With some refactoring, we could simply do the #line part of
  // beautify without also improving indentation and such which could
  // save some time.
  //
  if (beautifyIt && (!saveCDir.empty() || printCppLineno))
    beautify(fi);
}

fileinfo* openTmpFile(const char* tmpfilename, const char* mode) {
  fileinfo* newfile = (fileinfo*)malloc(sizeof(fileinfo));

  newfile->filename = astr(tmpfilename);
  newfile->pathname = genIntermediateFilename(tmpfilename);
  openfile(newfile, mode);

  return newfile;
}


FILE* openInputFile(const char* filename) {
  return openfile(filename, "r");
}


void closeInputFile(FILE* infile) {
  closefile(infile);
}


static const char** inputFilenames = NULL;

std::vector<std::string> getChplFilenames() {
  std::vector<std::string> ret;
  int i = 0;
  while (auto fname = nthFilename(i++)) {
    if (isChplSource(fname)) {
      ret.push_back(std::string(fname));
    }
  }
  return ret;
}


static bool checkSuffix(const char* filename, const char* suffix) {
  const char* dot = strrchr(filename, '.');

  return (dot && strcmp(dot+1, suffix) == 0);
}


bool isCSource(const char* filename) {
  return checkSuffix(filename, "c");
}

bool isCHeader(const char* filename) {
  return checkSuffix(filename, "h");
}

bool isObjFile(const char* filename) {
  return checkSuffix(filename, "o");
}

bool isStaticLibrary(const char* filename) {
  return checkSuffix(filename, "a");
}
bool isSharedLibrary(const char* filename) {
  return checkSuffix(filename, "so") || checkSuffix(filename, "dylib");
}

static bool foundChplSource = false;

bool isChplSource(const char* filename) {
  bool retval = checkSuffix(filename, "chpl");
  if (retval) foundChplSource = true;
  return retval;
}

bool isDynoLib(const char* filename) {
  bool retval = checkSuffix(filename, "dyno");
  if (retval) foundChplSource = true;
  return retval;
}

static bool isRecognizedSource(const char* filename) {
  return (isCSource(filename) ||
          isCHeader(filename) ||
          isObjFile(filename) ||
          isChplSource(filename) ||
          isDynoLib(filename)) ||
          isStaticLibrary(filename) ||
          isSharedLibrary(filename);
}


void addSourceFiles(int numNewFilenames, const char* filename[]) {
  static int numInputFiles = 0;
  int cursor = numInputFiles;
  char achar;
  numInputFiles += numNewFilenames;
  inputFilenames = (const char**)realloc(inputFilenames,
                                         (numInputFiles+1)*sizeof(char*));

  int firstAddedIdx = -1;
  for (int i = 0; i < numNewFilenames; i++) {
    if (!isRecognizedSource(filename[i])) {
      USR_FATAL("file '%s' does not have a recognized suffix", filename[i]);
    }
    // WE SHOULDN'T TRY TO OPEN .h files, just .c and .chpl and .o
    if (!isCHeader(filename[i])) {
      FILE* testfile = openInputFile(filename[i]);
      if (testfile) {
        if (fscanf(testfile, "%c", &achar) != 1)
          USR_FATAL("source file '%s' is either empty or a directory",
                    filename[i]);
        closeInputFile(testfile);
      }
    }

    if (isDynoLib(filename[i])) {
      // Note that we are using a .dyno file if one is present on the
      // command line.
      fDynoLibGenOrUse = true;
    }

    //
    // Don't add the same file twice -- it's unnecessary and can mess
    // up things like unprotected headers
    //
    bool duplicate = false;
    const char* newFilename = astr(filename[i]);
    for (int j = 0; j < cursor; j++) {
      if (inputFilenames[j] == newFilename) {  // legal due to astr()
        duplicate = true;
        break;
      }
    }
    if (duplicate) {
      numInputFiles--;
    } else {
      // add file
      if (firstAddedIdx < 0) firstAddedIdx = cursor;
      inputFilenames[cursor++] = newFilename;
    }
  }
  inputFilenames[cursor] = NULL;

  // If in driver mode, and filenames were added, also save added filenames for
  // makeBinary phase.
  // Note: Need to check both driver mode and phase here. The two could conflict
  // since files can be added before driver flags are validated.
  if (!fDriverDoMonolithic && fDriverCompilationPhase && firstAddedIdx >= 0) {
    saveDriverTmpMultiple(
        additionalFilenamesListFilename,
        std::vector<std::string_view>(inputFilenames + firstAddedIdx,
                                 inputFilenames + cursor));
  }


  // turn on ID-based munging if any .dyno files are present
  int i = 0;
  while (auto fname = nthFilename(i++)) {
    if (isDynoLib(fname)) {
      fIdBasedMunging = true;
    }
  }
}

void assertSourceFilesFound() {
  if (!foundChplSource)
    USR_FATAL("Command line contains no .chpl source files");
}

static const char* addCurrentDirToSourceFile(const char* filename,
                                             const char* modFilename) {
  // Do nothing if modFilename is NULL
  if (modFilename == NULL) {
    return filename;
  }

  // Do nothing if the filename is already absolute
  if (filename[0] == '/') {
    return filename;
  }

  // Do nothing if the current module's directory is "./"
  const char* modDir = getDirectory(modFilename);
  if (strcmp(modDir, ".") == 0) {
    return filename;
  }

  // If the file is a .c or .o...
  if (isCSource(filename) || isObjFile(filename)) {
    // ...and it isn't already an absolute path, add the module directory
    return astr(modDir, "/", filename);
  }

  // If the file is a .h, add the module's directory to the -I path
  if (isCHeader(filename)) {
    for_vector(const char, dir, incDirs) {
      if (dir == modDir) {
        // we've already added this -I directory, so don't do it again
        return filename;
      }
    }
    addIncInfo(modDir);
    return filename;
  }

  // otherwise, leave it as-is
  return filename;
}

void addSourceFile(const char* filename, const char* modFilename) {
  const char* filenamearr[1] = { addCurrentDirToSourceFile(filename,
                                                           modFilename)};
  addSourceFiles(1, filenamearr);
}


const char* nthFilename(int i) {
  return inputFilenames[i];
}


const char* createDebuggerFile(const char* debugger, int argc, char* argv[]) {
  const char* dbgfilename = genIntermediateFilename(astr(debugger, ".commands"));
  FILE* dbgfile = openfile(dbgfilename);
  int i;

  if (strcmp(debugger, "gdb") == 0) {
    fprintf(dbgfile, "set args");
  } else if (strcmp(debugger, "lldb") == 0) {
    fprintf(dbgfile, "settings set -- target.run-args");
  } else {
      INT_FATAL("createDebuggerFile doesn't know how to handle the given "
                "debugger: '%s'", debugger);
  }
  for (i=1; i<argc; i++) {
    if (strcmp(argv[i], astr("--", debugger)) != 0) {
      fprintf(dbgfile, " %s", argv[i]);
    }
  }

  fprintf(dbgfile, "\n");
  closefile(dbgfile);
  myshell(astr("cat ", CHPL_HOME.c_str(), "/compiler/etc/", debugger, ".commands >> ",
                dbgfilename),
           astr("appending ", debugger, " commands"),
           false);

  return dbgfilename;
}

std::string getChplDepsApp() {
  // Runs `util/chplenv/chpl_home_utils.py --chpldeps` and removes the newline

  std::string command = "CHPLENV_SUPPRESS_WARNINGS=true CHPL_HOME=" + std::string(CHPL_HOME) + " python3 ";
  command += std::string(CHPL_HOME) + "/util/chplenv/chpl_home_utils.py --chpldeps";

  std::string venvDir = runCommand(command, "Get dependencies");
  venvDir.erase(venvDir.find_last_not_of("\n\r")+1);

  return venvDir;
}

bool compilingWithPrgEnv() {
  return 0 != strcmp(CHPL_TARGET_COMPILER_PRGENV, "none");
}

std::string runCommand(const std::string& command,
                       const std::string& description) {
  if (printSystemCommands) {
    printf("\n# %s\n", description.c_str());
    printf("%s\n", command.c_str());
  }

  auto commandOutput = chpl::getCommandOutput(command);
  if (auto err = commandOutput.getError()) {
    USR_FATAL("failed to run '%s', error: %s",
              command.c_str(),
              err.message().c_str());
  }
  return commandOutput.get();
}

const char* getIntermediateDirName() {
  return gContext->tmpDir().c_str();
}

static void genCFiles(FILE* makefile) {
  int filenum = 0;
  int first = 1;
  while (const char* inputFilename = nthFilename(filenum++)) {
    if (isCSource(inputFilename)) {
      if (first) {
        fprintf(makefile, "CHPL_CL_C_SRCS = \\\n");
        first = 0;
      }
      fprintf(makefile, "\t%s \\\n", inputFilename);
    }
  }
  if (!first)
    fprintf(makefile, "\n");
}

static void genCFileBuildRules(FILE* makefile) {
  int filenum = 0;
  while (const char* inputFilename = nthFilename(filenum++)) {
    if (isCSource(inputFilename)) {
      const char* objFilename = objectFileForCFile(inputFilename);
      fprintf(makefile, "%s: %s FORCE\n", objFilename, inputFilename);
      fprintf(makefile,
              "\t$(CC) -c -o $@ $(GEN_CFLAGS) $(COMP_GEN_CFLAGS) $(CHPL_RT_INC_DIR) $<\n");
      fprintf(makefile, "\n");
    }
  }
  fprintf(makefile, "\n");
}


static void genObjFiles(FILE* makefile) {
  int filenum = 0;
  int first = 1;
  while (const char* inputFilename = nthFilename(filenum++)) {
    bool objfile = isObjFile(inputFilename) ||
                   isSharedLibrary(inputFilename) ||
                   isStaticLibrary(inputFilename);
    bool cfile = isCSource(inputFilename);
    if (objfile || cfile) {
      if (first) {
        fprintf(makefile, "CHPL_CL_OBJS = \\\n");
        first = 0;
      }
      if (objfile) {
        fprintf(makefile, "\t%s \\\n", inputFilename);
      } else {
        const char* pathlessFilename = stripdirectories(inputFilename);
        const char* objFilename = genIntermediateFilename(astr(pathlessFilename, ".o"));
        fprintf(makefile, "\t%s \\\n", objFilename);
      }
    }
  }
  if (!first)
    fprintf(makefile, "\n");
}


void genIncludeCommandLineHeaders(FILE* outfile) {
  int filenum = 0;
  while (const char* inputFilename = nthFilename(filenum++)) {
    if (isCHeader(inputFilename)) {
      fprintf(outfile, "#include \"%s\"\n", inputFilename);
    }
  }
}

static std::string genMakefileEnvCache() {
  std::string result;
  std::map<std::string, const char*>::iterator env;

  for (env = envMap.begin(); env != envMap.end(); ++env) {
    const std::string& key = env->first;
    const char* oldPrefix = "CHPL_";
    const char* newPrefix = "CHPL_MAKE_";
    INT_ASSERT(key.substr(0, strlen(oldPrefix)) == oldPrefix);
    std::string keySuffix = key.substr(strlen(oldPrefix), std::string::npos);
    std::string chpl_make_key = newPrefix + keySuffix;
    result += chpl_make_key + "=" + std::string(env->second) + "|";
  }

  return result;
}

void codegen_makefile(fileinfo* mainfile, const char** tmpbinname,
                      const char** tmpservername,
                      bool skip_compile_link,
                      const std::vector<const char*>& splitFiles) {
  const char* tmpDirName = gContext->tmpDir().c_str();
  const char* strippedExeFilename = stripdirectories(executableFilename.c_str());
  const char* exeExt = getLibraryExtension();
  const char* server = "";
  const char* tmpserver = "";
  const char* tmpbin = "";
  bool startsWithLib = !strncmp(executableFilename.c_str(), "lib", 3);
  bool dyn = (fLinkStyle == LS_DYNAMIC);
  std::string makeallvars;
  fileinfo makefile;

  openCFile(&makefile, "Makefile");

  // Capture different compiler directories.
  fprintf(makefile.fptr, "CHPL_MAKE_HOME = %s\n\n", CHPL_HOME.c_str());
  fprintf(makefile.fptr, "CHPL_MAKE_RUNTIME_LIB = %s\n\n", CHPL_RUNTIME_LIB.c_str());
  fprintf(makefile.fptr, "CHPL_MAKE_RUNTIME_INCL = %s\n\n", CHPL_RUNTIME_INCL.c_str());
  fprintf(makefile.fptr, "CHPL_MAKE_THIRD_PARTY = %s\n\n", CHPL_THIRD_PARTY.c_str());
  fprintf(makefile.fptr, "TMPDIRNAME = %s\n\n", tmpDirName);

  // Store chapel environment variables in a cache.
  makeallvars = genMakefileEnvCache();
  fprintf(makefile.fptr, "export CHPL_MAKE_CHPLENV_CACHE := %s\n\n",
          makeallvars.c_str());

  //
  // LLVM builds just use the makefile for the launcher and so want to skip
  // the actual program generation.
  //
  if (skip_compile_link) {
    fprintf(makefile.fptr, "SKIP_COMPILE_LINK = skip\n");
  }

  //
  // In --library compilation, put the generated library in the library
  // directory.
  //
  if (fLibraryCompile) {

    ensureLibDirExists();
    fprintf(makefile.fptr, "BINNAME = %s/", libDir.c_str());
    if (!startsWithLib) { fprintf(makefile.fptr, "lib"); }
    fprintf(makefile.fptr, "%s%s\n\n", executableFilename.c_str(), exeExt);

    //
    // Now that the client and launcher are merged, the server name becomes
    // the name of the library without any extension. We munge the server
    // name with a trailing underscore just to guarantee that it's different
    // from the file name.
    //
    if (fMultiLocaleInterop) {
      server = astr(executableFilename.c_str(), "_server");
      fprintf(makefile.fptr, "SERVERNAME = %s\n\n", server);
    }

  } else {
    fprintf(makefile.fptr, "BINNAME = %s%s\n\n", executableFilename.c_str(), exeExt);
  }

  //
  // BLC: This munging is done so that cp won't complain if the source
  // and destination are the same file (e.g., myprogram and ./myprogram).
  //
  if (fLibraryCompile) {
    const char* pfx = startsWithLib ? "/" : "/lib";
    tmpbin = astr(tmpDirName, pfx, strippedExeFilename, ".tmp", exeExt);

    if (fMultiLocaleInterop) {
      tmpserver = astr(tmpDirName, "/", strippedExeFilename, "_server");
    }
  } else {
    tmpbin = astr(tmpDirName, "/", strippedExeFilename, ".tmp", exeExt);
  }

  // Write out the temporary filename to the caller if necessary.
  if (tmpbinname) { *tmpbinname = tmpbin; }

  // Ditto for the server.
  if (tmpservername) { *tmpservername = tmpserver; }

  //
  // BLC: We generate a TMPBINNAME which is the name that will be used
  // by the C compiler in creating the executable, and is in the
  // --savec directory (a /tmp directory by default).  We then copy it
  // over to BINNAME -- the name given by the user/default module's filename
  // -- after linking is done.  As it turns out, this saves a
  // factor of 5 or so in time in running the test system, as opposed
  // to specifying BINNAME on the C compiler command line.
  //
  fprintf(makefile.fptr, "TMPBINNAME = %s\n", tmpbin);

  if (fMultiLocaleInterop) {
    fprintf(makefile.fptr, "TMPSERVERNAME = %s\n\n", tmpserver);
  }

  // Bunch of C compiler flags.
  fprintf(makefile.fptr, "COMP_GEN_WARN = %i\n", ccwarnings);
  fprintf(makefile.fptr, "COMP_GEN_DEBUG = %i\n", debugCCode);
  fprintf(makefile.fptr, "COMP_GEN_OPT = %i\n", optimizeCCode);
  fprintf(makefile.fptr, "COMP_GEN_SPECIALIZE = %i\n", specializeCCode);
  fprintf(makefile.fptr, "COMP_GEN_FLOAT_OPT = %i\n", ffloatOpt);

  if (fMultiLocaleInterop) {
    const char* loc = "$(CHPL_MAKE_HOME)/runtime/etc/src";
    fprintf(makefile.fptr, "COMP_GEN_MLI_EXTRA_INCLUDES = -I%s\n", loc);
  }

  // Build a string out of include directories, for convenience.
  std::string includedirs;
  for_vector(const char, dirName, incDirs) {
    includedirs += " -I";
    includedirs += dirName;
  }

  // Compiler flags for each deliverable.
  fprintf(makefile.fptr, "COMP_GEN_USER_CFLAGS = ");
  if (fLibraryCompile && !fMultiLocaleInterop && dyn) {
    fprintf(makefile.fptr, "$(SHARED_LIB_CFLAGS) ");
  }
  fprintf(makefile.fptr, "%s %s%s\n",
          includedirs.c_str(),
          ccflags.c_str(),
          // We only need to compute and store dependencies if --savec is used
          (!saveCDir.empty() ? " $(DEPEND_CFLAGS)" : ""));

  // Linker flags for each deliverable.
  const char* lmode = "";
  if (!fLibraryCompile) {
    //
    // Important that _no_ RHS is produced when the link style is default!
    // Tests will _fail_ that rely on this assumption if we do otherwise.
    //
    switch (fLinkStyle) {
    case LS_DYNAMIC:
      lmode = "$(GEN_DYNAMIC_FLAG)"; break;
    case LS_STATIC:
      lmode = "$(GEN_STATIC_FLAG)"; break;
    }
  } else if (fLibraryCompile && !fMultiLocaleInterop) {
    lmode = dyn ? "$(LIB_DYNAMIC_FLAG)" : "$(LIB_STATIC_FLAG)";
  }

  fprintf(makefile.fptr, "COMP_GEN_LFLAGS = %s\n",
          lmode);
  fprintf(makefile.fptr, "COMP_GEN_USER_LDFLAGS = %s\n",
          ldflags.c_str());

  // Block of code for generating TAGS command, developer convenience.
  fprintf(makefile.fptr, "TAGS_COMMAND = ");
  if (developer && !saveCDir.empty() && !printCppLineno) {
    fprintf(makefile.fptr,
            "-@which $(CHPL_TAGS_UTIL) > /dev/null 2>&1 && "
            "test -f $(CHPL_MAKE_HOME)/runtime/$(CHPL_TAGS_FILE) && "
            "cd %s && "
            "cp $(CHPL_MAKE_HOME)/runtime/$(CHPL_TAGS_FILE) . && "
            "$(CHPL_TAGS_UTIL) $(CHPL_TAGS_FLAGS) "
              "$(CHPL_TAGS_APPEND_FLAG) *.c *.h",
            saveCDir.c_str());
  }

  fprintf(makefile.fptr, "\n\n");

  // List source files needed to compile this deliverable.
  if (fMultiLocaleInterop) {

    const char* client = genIntermediateFilename(gMultiLocaleLibClientFile);
    const char* server = genIntermediateFilename(gMultiLocaleLibServerFile);

    // Only one source file for client (for now).
    fprintf(makefile.fptr, "CHPLSRC = \\\n");
    fprintf(makefile.fptr, "\t%s \n", client);

    // The server bundle includes "_main.c", bypassing the need to include it.
    fprintf(makefile.fptr, "CHPLSERVERSRC = \\\n");
    fprintf(makefile.fptr, "\t%s \n", server);

  } else {
    fprintf(makefile.fptr, "CHPLSRC = \\\n");
    fprintf(makefile.fptr, "\t%s \\\n\n", mainfile->pathname);
  }

  // List object files needed to compile this deliverable.
  fprintf(makefile.fptr, "CHPLUSEROBJ = \\\n");
  if (!fLibraryCompile) {
    // If we're not doing a --library-* compile, we want to add the
    // file corresponding to CHPLSRC/'mainfile' to CHPLUSEROBJ (the
    // list of user object files (which currently have no extension).
    // For an LLVM compile, this file has a .o extension, whereas for
    // a C back-end compile, it has a .c extension.  The following
    // accomplishes this by generating either
    //   CHPLUSEROBJ = $(CHPLSRC:%.o=%)
    // or
    //   CHPLUSEROBJ = $(CHPLSRC:%.c=%)'
    // based on the extension.  Note that with more refactoring in the
    // Makefiles used to build libraries, this similar change could be
    // applied there.

    const char* dot = &(mainfile->pathname[strlen(mainfile->pathname)-2]);
    const char* ext = &(mainfile->pathname[strlen(mainfile->pathname)-1]);
    if (*dot != '.' || (*ext != 'c' && *ext != 'o' )) {
      INT_FATAL("Unexpected extension in 'mainfile' for non-library compile");
    }
    fprintf(makefile.fptr, "\t$(CHPLSRC:%%.%s=%%) \\\n", ext);
  }
  for (size_t i = 0; i < splitFiles.size(); i++) {
    fprintf(makefile.fptr, "\t%s \\\n", splitFiles[i]);
  }
  fprintf(makefile.fptr, "\n");

  genCFiles(makefile.fptr);
  genObjFiles(makefile.fptr);

  // List libraries/locations needed to compile this deliverable.
  fprintf(makefile.fptr, "\nLIBS =");
  for_vector(const char, dirName, libDirs) {
    fprintf(makefile.fptr, " -L%s", dirName);
  }

  for_vector(const char, libName, libFiles) {
    fprintf(makefile.fptr, " -l%s", libName);
  }

  if (fLinkStyle==LS_STATIC) { fprintf(makefile.fptr, " $(LIBMVEC)"); }
  fprintf(makefile.fptr, "\n\n\n");

  // Figure out the appropriate base Makefile to include.
  std::string incpath = "include $(CHPL_MAKE_HOME)/runtime/etc/";
  if (fMultiLocaleInterop) {
    incpath += dyn ? "Makefile.mli-shared" : "Makefile.mli-static";
  } else if (fLibraryCompile) {
    incpath += dyn ? "Makefile.shared" : "Makefile.static";
  } else {
    incpath += "Makefile.exe";
  }

  fprintf(makefile.fptr, "%s\n\n", incpath.c_str());

  // We only need to compute and store dependencies if --savec is used
  if (!saveCDir.empty()) {
    fprintf(makefile.fptr, "DEPENDS = output/*.d\n\n");
    fprintf(makefile.fptr, "-include $(DEPENDS)\n");
  }

  genCFileBuildRules(makefile.fptr);
  closeCFile(&makefile, false);
}

const char* filenameToModulename(const char* filename) {
  const char* moduleName = astr(filename);
  const char* firstSlash = strrchr(moduleName, '/');

  if (firstSlash) {
    moduleName = firstSlash + 1;
  }

  return asubstr(moduleName, strrchr(moduleName, '.'));
}

void readArgsFromCommand(std::string cmd, std::vector<std::string>& args) {
  // Gather information from compileline into clangArgs.
  if(FILE* fd = popen(cmd.c_str(),"r")) {
    int ch;
    // Read arguments.
    while( (ch = getc(fd)) != EOF ) {
      // Read the next argument.
      // skip leading spaces
      while( ch != EOF && isspace(ch) ) ch = getc(fd);
      std::string arg;
      arg.push_back(ch);
      // read until space. TODO - handle quoting/spaces
      ch = getc(fd);
      while( ch != EOF && !isspace(ch) ) {
        arg += ch;
        ch = getc(fd);
      }
      // First argument is the clang install directory...
      args.push_back(arg);
    }
    pclose(fd);
  }
}

bool readArgsFromFile(std::string path, std::vector<std::string>& args,
                      bool errFatal) {

  FILE* fd = fopen(path.c_str(), "r");
  if (!fd) {
    if (errFatal)
      USR_FATAL("Could not open file %s", path.c_str());

    return false;
  }

  int ch;
  // Read arguments.
  while( (ch = getc(fd)) != EOF ) {
    // Read the next argument.
    // skip leading spaces
    while( ch != EOF && isspace(ch) ) ch = getc(fd);
    std::string arg;
    arg.push_back(ch);
    // read until space. TODO - handle quoting/spaces
    ch = getc(fd);
    while( ch != EOF && !isspace(ch) ) {
      arg += ch;
      ch = getc(fd);
    }
    args.push_back(arg);
  }

  fclose(fd);

  return true;
}

// Expands variables like $CHPL_HOME in the string
void expandInstallationPaths(std::string& s) {
  const char* tofix[] = {"$CHPL_RUNTIME_LIB", CHPL_RUNTIME_LIB.c_str(),
                         "$CHPL_RUNTIME_INCL", CHPL_RUNTIME_INCL.c_str(),
                         "$CHPL_THIRD_PARTY", CHPL_THIRD_PARTY.c_str(),
                         "$CHPL_HOME", CHPL_HOME.c_str(),
                         NULL};

  // For each of the patterns in tofix, find/replace all occurrences.
  for (int j = 0; tofix[j] != NULL; j += 2) {

    const char* key = tofix[j];
    const char* val = tofix[j+1];
    size_t key_len = strlen(key);
    size_t val_len = strlen(val);

    size_t off = 0;
    while (true) {
      off = s.find(key, off);
      if (off == std::string::npos)
        break; // no more occurrences to replace
      s.replace(off, key_len, val);
      off += val_len;
    }
  }
}

void expandInstallationPaths(std::vector<std::string>& args) {

  for (size_t i = 0; i < args.size(); i++) {
    std::string s = args[i];
    expandInstallationPaths(s);
    args[i] = s;
  }
}

bool isDirectory(std::string_view path) {
  return llvm::sys::fs::is_directory(path);
}

bool pathExists(std::string_view path) {
  return llvm::sys::fs::exists(path);
}

// would just use realpath, but it is not supported on all platforms.
char* chplRealPath(const char* path)
{
  // We would really rather use
  // char* got = realpath(path, NULL);
  // but that doesn't work on some Mac OS X versions.
  char* buf = (char*) malloc(PATH_MAX);
  char* got = realpath(path, buf);
  char* ret = NULL;
  if( got ) ret = strdup(got);
  free(buf);
  return ret;
}


// Returns a "real path" to the file in the directory,
// or NULL if the file did not exist.
// The return value must be freed by the caller.
// We try to use realpath but might give up.
char* dirHasFile(const char *dir, const char *file)
{
  struct stat stats;
  int len = strlen(dir) + strlen(file) + 2;
  char* tmp = (char*) malloc(len);
  char* real;

  if( ! tmp ) INT_FATAL("no memory");

  snprintf(tmp, len, "%s/%s", dir, file);
  real = chplRealPath(tmp);
  if( real == NULL ) {
    // realpath not working on this system,
    // just use tmp.
    real = tmp;
  } else {
    free(tmp);
  }

  if( stat(real, &stats) != 0) {
    free(real);
    real = NULL;
  }

  return real;
}


/*
 * Returns the current working directory. Does not report failures. Use
 * chpl::currentWorkingDir if you need error reports.
 */
const char* getCwd() {
  std::string cwd;
  if (auto err = chpl::currentWorkingDir(cwd)) {
    return "";
  } else {
    return astr(cwd);
  }
}


// Find the path to the running program
// (or return NULL if we couldn't figure it out).
// The return value must be freed by the caller.
char* findProgramPath(const char *argv0)
{
  char* real = NULL;
  char* path;

  /* Note - there are lots of friendly
   * but platform-specific ways to do this:
    #ifdef __linux__
      int ret;
      ret = readlink("/proc/self/exe", dst, max_dst - 1);
      // return an error if there was an error.
      if( ret < 0 ) return -1;
      // append the NULL byte
      if( ret < max_dst ) dst[ret] = '\0';
      return 0;
    #else
    #ifdef __APPLE__
      uint32_t sz = max_dst - 1;
      return _NSGetExecutablePath(dst, &sz);
    #else
      // getexe path not available.
      return -1;
    #endif
  */


  // Is argv0 an absolute path?
  if( argv0[0] == '/' ) {
    real = dirHasFile("/", argv0);
    return real;
  }

  // Is argv0 a relative path?
  if( strchr(argv0, '/') != NULL ) {
    std::string cwd;
    if(auto err = chpl::currentWorkingDir(cwd)) {
      real = NULL;
    } else {
      real = dirHasFile(astr(cwd), argv0);
    }
    return real;
  }

  // Is argv0 just in $PATH?
  path = getenv("PATH");
  if( path == NULL ) return NULL;

  path = strdup(path);
  if( path == NULL ) return NULL;

  // Go through PATH changing ':' into '\0'
  char* start;
  char* end;
  char* path_end = path + strlen(path);

  start = path;
  while( start != NULL && start < path_end ) {
    end = strchr(start, ':');
    if( end == NULL ) end = path_end;
    else end[0] = '\0'; // replace ':' with '\0'

    real = dirHasFile(start, argv0);
    if( real ) break;

    start = end + 1;
  }

  free(path);
  return real;
}

// Return true if both files exist and
// they point to the same inode.
// (if a filesystem does not return reasonable
//  inodes, this function might return true when
//  the paths are different - so it should be interpreted
//  as "NO" or "MAYBE").
bool isSameFile(const char* pathA, const char* pathB)
{
  struct stat statsA;
  struct stat statsB;
  int rc;

  rc = stat(pathA, &statsA);
  if( rc != 0 ) return false;
  rc = stat(pathB, &statsB);
  if( rc != 0 ) return false;

  // is the inode the same?
  if( statsA.st_dev == statsB.st_dev &&
      statsA.st_ino == statsB.st_ino ) {
    return true;
  }

  return false;
}
