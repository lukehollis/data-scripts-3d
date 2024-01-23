#!/bin/bash

# Directory containing the .wav files
SOURCE_DIR="."

# Directory to save the .mp3 files
TARGET_DIR="."

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Loop through each .wav file in the source directory
for wav_file in "$SOURCE_DIR"/*.wav; do
    # Extract the filename without the extension
    filename=$(basename -- "$wav_file")
    base_name="${filename%.*}"

    # Convert to mp3 and save in target directory
    ffmpeg -i "$wav_file" -q:a 0 "$TARGET_DIR/$base_name.mp3"
done

echo "Conversion complete!"

