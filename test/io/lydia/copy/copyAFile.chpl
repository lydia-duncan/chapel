use FileSystem;

// This test exercises copying a file to another file or into another directory

config var originalFile = "original.txt";
config var dest: string;

writeln(cwd() + "/" + dest); // Could do with joinPath() here
//copy(originalFile, dest);
