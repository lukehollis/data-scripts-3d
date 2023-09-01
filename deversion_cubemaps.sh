#!/bin/bash

# Directory containing the .jpg files
dir="./cubemaps_final"

# Loop over all .jpg files in the specified directory
for file in "$dir"/*v2.jpg; do
  # Extract the filename without the extension
  filename=$(basename -- "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"

  # Remove the last 2 characters from the filename (i.e., "v2")
  new_filename="${filename%v2}.${extension}"

  # Full path for the new filename
  new_filepath="$dir/$new_filename"

  # Rename the file
  mv "$file" "$new_filepath"
done

