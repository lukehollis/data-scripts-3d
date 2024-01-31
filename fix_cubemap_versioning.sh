#!/bin/bash

# Check if exactly one argument is given (the directory path)
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Assign the argument to a variable for better readability
directory_path="$1"

# Iterate over all files in the specified directory that end with v1_v1.jpg
for file in "$directory_path"/*v1_v1.jpg; do
    # Skip if no files match the pattern
    [[ -e $file ]] || continue

    # Remove the redundant version string (_v1_v1) from the filename
    # And generate the new filename by removing _v1_v1
    new_filename=$(echo "$file" | sed 's/v1_v1.jpg/.jpg/')

    # Rename the file
    mv "$file" "$new_filename"
    echo "Renamed $file to $new_filename"
done

