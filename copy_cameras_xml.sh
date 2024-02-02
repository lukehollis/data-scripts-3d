#!/bin/bash

# Loop through all directories in the current directory
for DIR in */ ; do
    # Remove the trailing slash to get the directory name
    DIR_NAME=${DIR%/}

    # Check if the cameras.xml file exists in the source directory
    if [ -f "$DIR_NAME/cameras.xml" ]; then
        # Copy the cameras.xml file to the destination directory, creating the directory if it does not exist
        mkdir -p ~/Projects/spaceshare/spaces/"$DIR_NAME"
        cp "$DIR_NAME/cameras.xml" ~/Projects/spaceshare/spaces/"$DIR_NAME/"
        echo "Copied $DIR_NAME/cameras.xml to ~/Projects/spaceshare/spaces/$DIR_NAME/"
    else
        echo "No cameras.xml found in $DIR_NAME"
    fi
done

