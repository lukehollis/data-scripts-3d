#!/bin/bash

# Loop through all directories in the current directory
for DIR in */ ; do
    # Remove the trailing slash to get the directory name
    DIR_NAME=${DIR%/}

    # Check if the cameras.xml file exists and the space.json file does not exist in the directory
    if [ -f "$DIR_NAME/cameras.xml" ] && [ ! -f "$DIR_NAME/space.json" ]; then
        # Copy the template_space.json file into the directory as space.json
        cp ./template_space.json "./$DIR_NAME/space.json"
        echo "Copied template_space.json to $DIR_NAME/space.json"

        python ../converter/metashape_colmap_converter/cameras_to_spacefile.py "./$DIR_NAME/cameras.xml" "./$DIR_NAME/space.json"
        echo "Ran cameras_to_spacefile.py for $DIR_NAME"
    else
        echo "No cameras.xml found or space.json already exists in $DIR_NAME"
    fi
done

