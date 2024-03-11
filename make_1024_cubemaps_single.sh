#!/bin/bash

# Loop through all subdirectories of the current directory
source_dir="."

# Define the new directory to store resized images
new_dir="$source_dir/cubemaps_1024"
# Create the new directory if it doesn't exist
mkdir -p "$new_dir"

echo "Processing directory: $source_dir"
# Loop through each .jpg file in the source directory
find "$source_dir/cubemaps/" -type f -name '*.jpg' | while read filename; do
	# Extract the base filename without path
	base_filename=$(basename "$filename")
	# Generate the new filename by appending _1024 to the original filename before the extension
	# and specifying the new directory path
	new_filename="$new_dir/${base_filename%.*}_1024.jpg"
	echo "Resizing $filename to $new_filename"
	# Use ImageMagick's convert command to resize the image
	convert "$filename" -resize 1024x1024 "$new_filename"
done

echo "Processing completed."

