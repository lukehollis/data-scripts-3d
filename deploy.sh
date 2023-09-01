#!/bin/bash

# Upload files to the bucket
gcloud storage cp -r cubemaps_final/*.jpg gs://mused/spaceshare/

