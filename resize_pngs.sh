#!/bin/bash

# Create output directory
mkdir -p resized

# Process all PNG files
for file in *.png; do
    ffmpeg -i "$file" -vf "scale=500:-1" "resized/${file%.png}_500w.png"
done

echo "Resizing complete! Check the 'resized' directory"