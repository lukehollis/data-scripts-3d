#!/bin/bash

mkdir -p eqs

for file in 360videos/*
do
    # Get the base name of the file without its path
    basefile=$(basename "$file")

    # Remove the ".mp4" and ".mov" extensions
    fname="${basefile%.mp4}"
    fname="${fname%.mov}"

    ffmpeg -i "$file" -vf "fps=4" -pix_fmt bgr8 "eqs/${fname}_frame_%05d.jpg"
done

