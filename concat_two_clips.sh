#!/bin/bash

# Check if exactly 3 arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_clip1> <input_clip2> <output_clip>"
    exit 1
fi

# Input and output file names
input_clip1=$1
input_clip2=$2
output_clip=$3

# Temporary file names
temp_clip1="temp1_1280x720.mp4"
temp_clip2="temp2_1280x720.mp4"

# Resize the input clips to 1280x720
ffmpeg -i "$input_clip1" -vf "scale=1280:720" -c:a copy "$temp_clip1"
ffmpeg -i "$input_clip2" -vf "scale=1280:720" -c:a copy "$temp_clip2"

# Create a text file for concatenation
echo "file '$temp_clip1'" > input.txt
echo "file '$temp_clip2'" >> input.txt

# Concatenate the clips
ffmpeg -f concat -safe 0 -i input.txt -c copy "$output_clip"

# Clean up temporary files
rm "$temp_clip1" "$temp_clip2" input.txt

echo "The clips have been successfully joined into $output_clip"

