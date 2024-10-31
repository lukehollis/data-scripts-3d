#!/bin/bash

# Name of the output file
output="output_video.mp4"

# Create filelist.txt with each video file in the correct order
echo "Creating file list..."

# Clear the filelist.txt if it exists
> filelist.txt

# Find all MP4 files, sort them, and add to filelist.txt
for file in $(ls -1 *.mp4 | sort); do
    echo "file '$file'" >> filelist.txt
done

# Concatenate videos with FFmpeg
echo "Concatenating videos..."
ffmpeg -f concat -safe 0 -i filelist.txt -c copy "$output"

# Cleanup filelist.txt after concatenation
rm filelist.txt

echo "Concatenation complete. Output file: $output"

