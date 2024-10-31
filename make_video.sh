#!/bin/bash

# Name of the output file
output="output_video.mp4"

# Create filelist.txt with each video file in the correct order
echo "Creating file list..."

# Clear the filelist.txt if it exists
> filelist.txt

# Add each video file to filelist.txt
for file in 00_compressed_enchanted_forest.mp4 01_compressed_winter_forest.mp4 02_compressed_gaussian_splat.mp4 03_compressed_airport.mp4 04_compressed_pixelart_romans.mp4 05_compressed_museum_giftstore.mp4; do
    echo "file '$file'" >> filelist.txt
done

# Concatenate videos with FFmpeg
echo "Concatenating videos..."
ffmpeg -f concat -safe 0 -i filelist.txt -c copy "$output"

# Cleanup filelist.txt after concatenation
rm filelist.txt

echo "Concatenation complete. Output file: $output"

