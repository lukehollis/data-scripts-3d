#!/bin/bash

mkdir -p eqs_orig

for file in 360videos/*
do
    # Get the base name of the file without its path
    basefile=$(basename "$file")

    # Remove the ".mp4" and ".mov" extensions
    fname="${basefile%.mp4}"
    fname="${fname%.mov}"

    ffmpeg -i "$file" -vf "fps=1" -pix_fmt bgr8 "eqs_orig/${fname}_frame_%05d.jpg"
done

