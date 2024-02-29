#!/bin/bash

# Function to upload _1024.jpg files from a given directory
upload_files_from_dir() {
  local dir_name="$1"  # Directory to process
  echo "Processing directory: $dir_name"
  # Find and upload each _1024.jpg file in the directory
  find "$dir_name" -type f -name '*_1024.jpg' | while read filename; do
    echo "Uploading $filename to gs://mused/spaceshare"
    # Use gcloud storage cp command to upload the file
    gcloud storage cp "$filename" "gs://mused/spaceshare/$(basename "$filename")"
  done
}

# Check if 'cubemaps_final' exists and upload, otherwise check 'cubemaps'
if [[ -d "cubemaps_final" ]]; then
  upload_files_from_dir "cubemaps_final"
elif [[ -d "cubemaps" ]]; then
  upload_files_from_dir "cubemaps"
else
  echo "Neither 'cubemaps_final' nor 'cubemaps' directory found."
fi

echo "Upload completed."

