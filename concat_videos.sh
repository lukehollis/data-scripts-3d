#!/bin/bash

# Check if at least two input files are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 file1.mp4 file2.mp4 [file3.mp4 ...]"
    exit 1
fi

# Create a temporary file for the concat list
CONCAT_LIST=$(mktemp)

# Loop through all input files and add their absolute paths to the concat list
for file in "$@"; do
    # Get the absolute path of the file
    fullpath="$(cd "$(dirname "$file")"; pwd)/$(basename "$file")"
    echo "file '$fullpath'" >> "$CONCAT_LIST"
done

# Concatenate all files listed in the concat list
ffmpeg -f concat -safe 0 -i "$CONCAT_LIST" -c copy final_output.mp4

# Clean up temporary concat list
rm "$CONCAT_LIST"

echo "Concatenation completed. Output saved as final_output.mp4"
