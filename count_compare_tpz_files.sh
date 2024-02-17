#!/bin/bash

# Path to the main directory
mainDir="./Spaces/"

# Iterate through each subdirectory in the main directory
for subDir in "$mainDir"*/; do
    echo "Processing directory: $subDir"

    # Initialize counts to 0
    count_orig=0
    count_tpz=0
    count_to_tpz=0

    # Count the number of files in eqs_orig, excluding files starting with ._
    if [ -d "${subDir}eqs_orig/" ]; then
        count_orig=$(find "${subDir}eqs_orig/" -type f ! -name '._*' | wc -l)
    fi

    # Count the number of files in eqs_tpz, excluding files starting with ._
    if [ -d "${subDir}eqs_tpz/" ]; then
        count_tpz=$(find "${subDir}eqs_tpz/" -type f ! -name '._*' | wc -l)
    fi

    # Count the number of files in eqs_to_tpz, excluding files starting with ._
    if [ -d "${subDir}eqs_to_tpz/" ]; then
        count_to_tpz=$(find "${subDir}eqs_to_tpz/" -type f ! -name '._*' | wc -l)
    fi

    # Print the counts
    echo "Total files in eqs_orig: $count_orig"
    echo "Total files in eqs_tpz: $count_tpz"
    echo "Total files in eqs_to_tpz: $count_to_tpz"

    # Calculate the sum of files in eqs_tpz and eqs_to_tpz
    sum_tpz_to_tpz=$((count_tpz + count_to_tpz))

    # Check if the sum matches the count of eqs_orig
    if [ "$sum_tpz_to_tpz" -eq "$count_orig" ]; then
        echo "The sum of files in eqs_tpz and eqs_to_tpz matches the number of files in eqs_orig."
    else
        echo "Mismatch: The sum of files in eqs_tpz and eqs_to_tpz does not match the number of files in eqs_orig."
    fi

    echo "" # Print a newline for better readability between directories
done

echo "Verification completed."

