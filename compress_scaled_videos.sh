#!/bin/bash

# Check if input file or directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 input_file_or_directory [compression_level]"
    echo "       compression_level: 0-51 (0=lossless, 23=default, 51=worst quality)"
    exit 1
fi

input="$1"
compression_level="${2:-28}"  # Default to 28 for higher compression than default

# Function to compress a single video file
compress_video() {
    local input_file="$1"
    local compression_level="$2"
    
    # Skip if not a video file
    if [[ ! "$input_file" =~ \.(mp4|mov|mkv)$ ]]; then
        echo "Skipping non-video file: $input_file"
        return
    fi
    
    # Create output filename with _compressed suffix
    local output_file="${input_file%.*}_compressed.mp4"
    
    echo "Compressing: $input_file"
    echo "Output: $output_file"
    
    # Use ffmpeg with libx264 codec and specified CRF (Constant Rate Factor)
    ffmpeg -i "$input_file" -c:v libx264 -crf "$compression_level" -preset slower -c:a aac -b:a 128k "$output_file"
    
    # Get file sizes for comparison
    original_size=$(du -h "$input_file" | cut -f1)
    compressed_size=$(du -h "$output_file" | cut -f1)
    
    echo "Original size: $original_size"
    echo "Compressed size: $compressed_size"
    echo "------------------------"
}

# Process input (file or directory)
if [ -d "$input" ]; then
    # It's a directory, process all video files
    echo "Processing directory: $input"
    find "$input" -type f \( -name "*.mp4" -o -name "*.mov" -o -name "*.mkv" \) | while read -r file; do
        compress_video "$file" "$compression_level"
    done
else
    # It's a single file
    compress_video "$input" "$compression_level"
fi

echo "Compression completed."
