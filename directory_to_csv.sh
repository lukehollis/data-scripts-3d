#!/bin/bash

# Check if a directory was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory=$1
output_file="directory_contents.csv"

# Check if the specified directory exists
if [ ! -d "$directory" ]; then
    echo "Directory does not exist: $directory"
    exit 1
fi

# Create the CSV file
> "$output_file"

# Iterate over each file in the directory
find "$directory" -maxdepth 1 -type f | while read -r file; do
    # Extract filename from path
    filename=$(basename "$file")
    # Skip files that start with ._
    if [[ $filename == ._** ]]; then
        continue
    fi
    # Quote the entire filename and append to CSV file
    echo "\"$filename\"" >> "$output_file"
done

echo "Directory contents saved to $output_file"

