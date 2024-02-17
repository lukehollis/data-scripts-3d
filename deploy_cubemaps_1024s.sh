#!/bin/bash

# Loop through all subdirectories of the current directory
find . -type d -mindepth 1 -maxdepth 1 | while read subdir; do
  # Determine the target directory based on the existence of 'cubemaps_final' or 'cubemaps'
  if [[ -d "$subdir/cubemaps_final" ]]; then
    target_dir="$subdir/cubemaps_final"
  elif [[ -d "$subdir/cubemaps" ]]; then
    target_dir="$subdir/cubemaps"
  else
    continue
  fi
  
  echo "Processing directory: $target_dir"
  # Loop through each _1024.jpg file in the target directory
  find "$target_dir" -type f -name '*_1024.jpg' | while read filename; do
    echo "Uploading $filename to gs://mused/spaceshare"
    # Use gcloud storage cp command to upload the file
    gcloud storage cp "$filename" "gs://mused/spaceshare/$(basename "$filename")"
  done
done

echo "Upload completed."

