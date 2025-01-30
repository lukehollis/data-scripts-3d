#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first."
    exit 1
fi

# Help message function
show_help() {
    echo "Usage: $0 input_file [output_file] [quality]"
    echo ""
    echo "This script converts a landscape video to vertical format (1080x1920)"
    echo ""
    echo "Arguments:"
    echo "  input_file   - The input video file to convert"
    echo "  output_file  - (Optional) The output file name. If not provided,"
    echo "                 '_vertical' will be added to the input filename"
    echo "  quality      - (Optional) CRF value (0-51, lower is better quality,"
    echo "                 default is 23)"
    echo ""
    echo "Example:"
    echo "  $0 myvideo.mp4"
    echo "  $0 myvideo.mp4 output.mp4"
    echo "  $0 myvideo.mp4 output.mp4 18"
}

# Check if input file was provided
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Get input file
input_file="$1"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Get file extension
ext="${input_file##*.}"

# Set output file name
if [ -z "$2" ]; then
    # If no output file specified, add '_vertical' to input filename
    output_file="${input_file%.*}_vertical.$ext"
else
    output_file="$2"
fi

# Set quality (CRF value)
quality=${3:-23}  # Default to 23 if not specified

# Validate quality value
if ! [[ "$quality" =~ ^[0-9]+$ ]] || [ "$quality" -lt 0 ] || [ "$quality" -gt 51 ]; then
    echo "Error: Quality value must be between 0 and 51"
    exit 1
fi

echo "Converting $input_file to vertical format, saving as $output_file with quality CRF $quality..."

# Run ffmpeg command with crop and scale
ffmpeg -i "$input_file" \
    -vf "crop=ih/16*9:ih,scale=1080:1920" \
    -c:v libx264 \
    -crf "$quality" \
    -preset medium \
    -c:a copy \
    "$output_file"

# Check if conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion completed successfully!"
    echo "Output saved as: $output_file"
else
    echo "Error: Conversion failed!"
    exit 1
fi
