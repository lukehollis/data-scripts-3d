#!/bin/bash

# Check if an input directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Navigate to the input directory
cd "$1" || exit

# Counter to keep track of the files
count=0

# Find and sort all PNG files, then iterate over them
find . -maxdepth 1 -type f -iname '*.png' | sort | while read -r file; do
    # Increment the counter
    let count+=1
    
    # Check if the file is not a multiple of 10
    if [ $((count % 10)) -ne 0 ]; then
        # Delete the file
        echo "Deleting $file"
        rm "$file"
    else
        echo "Keeping $file"
    fi
done

