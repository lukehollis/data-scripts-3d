#!/bin/bash

# Loop through all subdirectories of the current directory
find . -type d -mindepth 1 -maxdepth 1 | while read subdir; do
  # Check if 'cubemaps_final' directory exists within the subdirectory
  if [[ -d "$subdir/cubemaps_final" ]]; then
    source_dir="$subdir/cubemaps_final"
  elif [[ -d "$subdir/cubemaps" ]]; then
    # Fallback to 'cubemaps' if 'cubemaps_final' doesn't exist
    source_dir="$subdir/cubemaps"
  else
    # Skip the subdirectory if neither directory exists
    continue
  fi

  # Define the new directory to store resized images
  new_dir="$subdir/cubemaps_1024"
  # Create the new directory if it doesn't exist
  mkdir -p "$new_dir"

  echo "Processing directory: $source_dir"
  # Loop through each .jpg file in the source directory
  find "$source_dir" -type f -name '*.jpg' | while read filename; do
    # Extract the base filename without path
    base_filename=$(basename "$filename")
    # Generate the new filename by appending _1024 to the original filename before the extension
    # and specifying the new directory path
    new_filename="$new_dir/${base_filename%.*}_1024.jpg"
    echo "Resizing $filename to $new_filename"
    # Use ImageMagick's convert command to resize the image
    convert "$filename" -resize 1024x1024 "$new_filename"
  done
done

echo "Processing completed."

