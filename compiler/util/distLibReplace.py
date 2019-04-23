#!/usr/bin/env python3
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('source', help='source file to modify')
parser.add_argument('toReplace', help='text to replace in source')
parser.add_argument('replacement', help='file with replacement text')
args = parser.parse_args()

# Read in the file
with open(args.source, 'r') as file :
  filedata = file.read()

with open(args.replacement, 'r') as file:
    replacementText = file.read()

# Replace the target string
filedata = filedata.replace(args.toReplace, replacementText + "\n" + args.toReplace)

# Write the file out again
with open(args.source, 'w') as file:
  file.write(filedata)
