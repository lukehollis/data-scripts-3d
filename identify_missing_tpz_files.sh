#!/bin/bash

# Path to the main directory
mainDir="./Spaces/"

# Iterate through each subdirectory in the main directory
for subDir in "$mainDir"*/; do
    echo "Processing directory: $subDir"
    
    # Define the source, destination, and target directories
    origDir="${subDir}eqs_orig/"
    tpzDir="${subDir}eqs_tpz/"
    targetDir="${subDir}eqs_to_tpz/"

    # Check if the eqs_orig directory exists
    if [ ! -d "$origDir" ]; then
        echo "Directory $origDir does not exist, skipping..."
        continue
    fi

    # Create the eqs_to_tpz directory if it does not exist
    if [ ! -d "$targetDir" ]; then
        echo "Creating directory $targetDir"
        mkdir "$targetDir"
    fi

    # Iterate through files in eqs_orig
    for origFile in "$origDir"*; do
        # Extract the filename from the path
        filename=$(basename "$origFile")
        baseName="${filename%.*}"
        extension="${filename##*.}"
        extensionLower=$(echo "$extension" | tr '[:upper:]' '[:lower:]') # Convert extension to lowercase

        # Check if the file does not exist in eqs_tpz
        if [ ! -f "${tpzDir}${filename}" ]; then
            # Check if the file is a PNG (case-insensitive)
            if [ "$extensionLower" = "png" ]; then
                # Convert PNG to JPG
                echo "Converting $filename to JPG and copying to $targetDir"
                convert "$origFile" "${targetDir}${baseName}.jpg"
            else
                # Copy the file to eqs_to_tpz
                echo "Copying $filename to $targetDir"
                cp "$origFile" "$targetDir"
            fi
        fi
    done
done

echo "Process completed."

