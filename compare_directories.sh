#!/bin/bash

# Check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory1> <directory2>"
    exit 1
fi

dir1=$1
dir2=$2

# Ensure both arguments are directories
if [ ! -d "$dir1" ]; then
    echo "Error: '$dir1' is not a valid directory."
    exit 1
fi

if [ ! -d "$dir2" ]; then
    echo "Error: '$dir2' is not a valid directory."
    exit 1
fi

# Find all files in both directories, strip the directory paths, sort them, and then compare
find "$dir1" -type f | sed "s|${dir1}/||" | sort > /tmp/dir1_files.txt
find "$dir2" -type f | sed "s|${dir2}/||" | sort > /tmp/dir2_files.txt

echo "Files missing in '$dir2':"
comm -23 /tmp/dir1_files.txt /tmp/dir2_files.txt

# Clean up temporary files
rm /tmp/dir1_files.txt /tmp/dir2_files.txt

