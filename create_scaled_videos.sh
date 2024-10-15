#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

input_file="$1"
output_file_prefix="${input_file%.*}_scaled"

# Scale height to 1920 and crop width to 1080 at the center
ffmpeg -i "$input_file" -vf "scale=-1:1920,crop=1080:1920" -c:a copy "${output_file_prefix}_1080x1920.mp4"

# Scale to 1280x720
ffmpeg -i "$input_file" -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" -c:a copy "${output_file_prefix}_1280x720.mp4"

# Scale to 1920x1080
ffmpeg -i "$input_file" -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" -c:a copy "${output_file_prefix}_1920x1080.mp4"

echo "Scaling and cropping completed."

