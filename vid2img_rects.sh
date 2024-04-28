#!/bin/bash

# Create the "rects" directory if it doesn't exist
mkdir -p rects

# Loop through all .mov files in the "videos" directory
for video in videos/*.mov; do
  # Extract the filename without the extension
  filename=$(basename "$video" .mov)
  
  # Create a directory for the current video frames if it doesn't exist
  mkdir -p "rects/$filename"
  
  # Use ffmpeg to export frames as JPG images
  ffmpeg -i "$video" -vf fps=1 "rects/$filename%04d.jpg"
done
