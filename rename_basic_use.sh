#!/bin/bash

# Directory containing the files. Replace '/path/to/directory' with the actual directory path.
DIR="./eqs_orig"

# Iterate over every file ending with (1).jpg in the specified directory
for file in "$DIR"/*\(1\).jpg; do
  # Check if the file exists to avoid errors in case of no matching files
  if [ -f "$file" ]; then
    # Generate new file name by removing (1)
    new_name="${file%(1).jpg}.jpg"
    
    # Rename the file
    mv "$file" "$new_name"
    
    echo "Renamed $file to $new_name"
  fi
done

