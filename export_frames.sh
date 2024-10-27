#!/bin/bash

# Check if input file is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_video> [fps=1] [output_dir=frames]"
    exit 1
fi

# Input video file
input_video="$1"

# Optional parameters with defaults
fps="${2:-1}"           # Default to 1 frame per second
output_dir="${3:-frames}"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Export frames using ffmpeg
ffmpeg -i "$input_video" \
    -vf "fps=$fps" \
    -frame_pts 1 \
    "$output_dir/frame_%d.jpg"

echo "Frames exported to $output_dir/"
echo "Frame rate: $fps fps"
