#!/bin/bash

# Directory containing PNG files
PNG_DIR="eqs_pngs"

# Directory to save JPG files
JPG_DIR="eqs_orig"

# Create JPG directory if it doesn't exist
mkdir -p "$JPG_DIR"

# Loop through all PNG files in the PNG directory
for png_file in "$PNG_DIR"/*.png
do
    # Extract filename without extension
    base_name=$(basename "$png_file" .png)

    # Define the new JPG filename
    jpg_file="$JPG_DIR/$base_name.jpg"

    # Convert PNG to JPG
    convert "$png_file" "$jpg_file"
done

echo "Conversion complete!"

