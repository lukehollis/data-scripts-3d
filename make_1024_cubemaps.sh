#!/bin/bash

# Loop through all subdirectories of the current directory
find . -type d -mindepth 1 -maxdepth 1 | while read subdir; do
  # Check if 'cubemaps_final' directory exists within the subdirectory
  if [[ -d "$subdir/cubemaps_final" ]]; then
    target_dir="$subdir/cubemaps_final"
  elif [[ -d "$subdir/cubemaps" ]]; then
    # Fallback to 'cubemaps' if 'cubemaps_final' doesn't exist
    target_dir="$subdir/cubemaps"
  else
    # Skip the subdirectory if neither directory exists
    continue
  fi
  
  echo "Processing directory: $target_dir"
  # Loop through each .jpg file in the target directory
  find "$target_dir" -type f -name '*.jpg' | while read filename; do
    # Generate the new filename by appending _1024 to the original filename before the extension
    new_filename="${filename%.*}_1024.jpg"
    echo "Resizing $filename to $new_filename"
    # Use ImageMagick's convert command to resize the image
    convert "$filename" -resize 1024x1024 "$new_filename"
  done
done

echo "Processing completed."

