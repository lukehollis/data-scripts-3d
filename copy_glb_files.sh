#!/bin/bash

# Define the source base directory
SOURCE_DIR="/Volumes/Projects/Spaces"

# Define the target base directory, assumed to be the current working directory plus "/spaces"
TARGET_DIR="./spaces"

# Iterate over each subdirectory in the target base directory
for subdir in "$TARGET_DIR"/*; do
  # Check if the iteration variable is indeed a directory
  if [ -d "$subdir" ]; then
    # Extract the name of the subdirectory without the path
    subdir_name=$(basename "$subdir")
    
    # Construct the source path of the .glb file
    source_file="$SOURCE_DIR/$subdir_name/space.glb"
    
    # Check if the source file exists before attempting to copy
    if [ -f "$source_file" ]; then
      # Copy the .glb file to the subdirectory under the current working directory
      cp "$source_file" "$subdir/"
      echo "Copied $source_file to $subdir/"
    else
      echo "Source file $source_file not found."
    fi
  fi
done

