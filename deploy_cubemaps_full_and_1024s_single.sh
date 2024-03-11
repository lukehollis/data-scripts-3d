#!/bin/bash

# Function to upload .jpg files from a given directory
upload_files_from_dir() {
  local dir_name="$1"  # Directory to process
  echo "Processing directory: $dir_name"
  # Find and upload each .jpg file in the directory

  # Use gcloud storage cp command to upload the file
  gcloud storage cp "$dir_name/*.jpg" gs://mused/spaceshare/
}

# Upload files from cubemaps if it exists
if [[ -d "cubemaps" ]]; then
  upload_files_from_dir "cubemaps"
fi

# Upload files from cubemaps_1024 if it exists
if [[ -d "cubemaps_1024" ]]; then
  upload_files_from_dir "cubemaps_1024"
fi

# Upload files from cubemaps_final if it exists
if [[ -d "cubemaps_final" ]]; then
  upload_files_from_dir "cubemaps_final"
fi

echo "Upload completed."

