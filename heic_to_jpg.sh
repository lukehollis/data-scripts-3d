#!/bin/bash

# Check if the ImageMagick package is installed
if ! command -v magick &> /dev/null
then
    echo "ImageMagick is not installed. Installing it now..."
    brew install imagemagick
fi

# Loop through all files in the current directory
for file in *
do
    # Convert the filename to lowercase
    lowercase_file=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    
    # Check if the file has a .heic or .heif extension (case-insensitive)
    if [[ "$lowercase_file" == *.heic ]] || [[ "$lowercase_file" == *.heif ]]; then
        # Extract the filename without the extension
        filename=$(basename "$lowercase_file" .heic)
        filename=$(basename "$filename" .heif)
        
        # Convert the file to .jpg using ImageMagick
        magick "$file" "${filename}.jpg"
        
        echo "Converted $file to ${filename}.jpg"
    fi
done
