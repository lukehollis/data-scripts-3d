#!/bin/bash


# Construct the destination path
DEST_PATH="gs://mused/spaceshare"

# Copy files to the destination
gcloud storage cp -r cubemaps/* "$DEST_PATH"
