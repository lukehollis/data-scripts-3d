#!/bin/bash

# Check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_path> <version_string>"
    exit 1
fi

# Assign arguments to variables for better readability
directory_path="$1"
version_string="$2"

# Iterate over all .jpg files in the specified directory
for file in "$directory_path"/*.jpg; do
    # Extract the file name without the extension
    filename=$(basename "$file" .jpg)
    
    # If the file doesn't already have a version, rename it
    if [[ "$filename" != *v* ]]; then
        new_filename="${filename}_${version_string}.jpg"
        mv "$file" "$directory_path/$new_filename"
        echo "Renamed $file to $new_filename"
    fi
done

