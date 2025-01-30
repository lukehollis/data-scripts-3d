#!/usr/bin/env bash

# This script finds and removes all venv directories within
# the current directory and its subdirectories.

echo "Searching for venv directories..."
find . -type d -name "venv" -exec rm -rf {} +

echo "All 'venv' directories have been removed." 