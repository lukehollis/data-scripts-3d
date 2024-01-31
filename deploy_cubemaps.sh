#!/bin/bash


# Construct the destination path
DEST_PATH="gs://mused/spaceshare"

# Copy files to the destination
npm run build
gcloud storage cp -r cubemaps_final/* "$DEST_PATH"
