#!/bin/bash

# Directory containing the .jpg files
dir="./cubemaps_final"

# Loop over all .jpg files in the specified directory that have "_face" in their names
for file in "$dir"/*_face*.jpg; do
  # Extract the filename without the extension
  filename=$(basename -- "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"

  # Extract prefix and suffix based on "_face"
  prefix="${filename%%_face*}"
  suffix="${filename#*_face}"

  # New filename with "v2" added before "_face"
  new_filename="${prefix}v2_face${suffix}.${extension}"
  
  # Full path for the new filename
  new_filepath="$dir/$new_filename"

  # Rename the file
  mv "$file" "$new_filepath"
done

