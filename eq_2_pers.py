import os
import subprocess
from pathlib import Path

# Define the input and output directories
input_dir = "eqs"
output_dir = "raw_images"

# Create the output directory if it doesn't exist
if not os.path.exists(output_dir):
    os.mkdir(output_dir)

# Get a list of all files in the input directory
files = list(Path(input_dir).glob("*.jpg"))

print("Converting", len(files), "files") 

# Loop through all the files
for i, file in enumerate(files):
    # Get the file name without the extension
    file_name = file.stem
    print(' -- ', i, len(files), file_name)

    # Loop through all the perspectives
    for yaw in range(0, 360, 90):
        for pitch in range(-40, 100, 50):
            print(" -- -- ", yaw, pitch)
            # Perform the perspective transformation
            subprocess.run(["convert360", "--convert", "e2p", "--i", f"{input_dir}/{file_name}.jpg", "--o", f"{output_dir}/{file_name}_perspective_{yaw}_{pitch}.jpg", "--w", "1024", "--h", "1024", "--u_deg", str(yaw), "--v_deg", str(pitch)])

