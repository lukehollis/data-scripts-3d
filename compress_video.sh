#!/bin/bash

# Script to compress any input video using FFmpeg

# Check if an input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_video>"
    exit 1
fi

input_video=$1
output_video="compressed_${input_video%.*}.mp4"

# FFmpeg command to compress the video
ffmpeg -i "$input_video" \
    -vcodec libx264 \
    -crf 28 \
    -preset fast \
    -acodec aac \
    -b:a 128k \
    -movflags +faststart \
    "$output_video"

# Output message
echo "Compression complete: $output_video"

