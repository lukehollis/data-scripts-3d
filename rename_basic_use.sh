#!/bin/bash

# Directory containing the files. Replace './' with the actual directory path if needed.
DIR="./"

# Iterate over every file ending with -enhance-4.9x.jpg in the specified directory
for file in "$DIR"/*-enhance-4.9x*.jpg; do
  # Check if the file exists to avoid errors in case of no matching files
  if [ -f "$file" ]; then
    # Generate new file name by removing "-enhance-4.9x" part
    new_name="${file/-enhance-4.9x/}"

    # Rename the file
    mv "$file" "$new_name"

    echo "Renamed $file to $new_name"
  fi
done

