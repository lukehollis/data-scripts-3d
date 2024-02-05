#!/bin/bash

# Iterate through all directories in the current directory
for dir in */; do
    echo "./$dir"
    # Iterate through all subdirectories of the current directory
    for subdir in "$dir"*/; do
        # Count the number of files in the subdirectory
        count=$(find "$subdir" -type f | wc -l)
        # Print the subdirectory path and file count
        echo " -- $subdir: $count files"
    done
done

