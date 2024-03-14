#!/bin/bash

# Check that the correct number of arguments was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: download-file VM_NAME ZONE FILENAME"
    exit 1
fi

# Set the variables from the arguments
vm_name=nerf
zone=us-central1-c
filename=$1

# Download the file using the gcloud command
gcloud compute scp "${vm_name}:${filename}" "${filename}" --zone "${zone}"

echo "File downloaded successfully"

