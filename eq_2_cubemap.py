import numpy as np
from PIL import Image
import py360convert
from pathlib import Path

input_dir = "eqs_upres"
output_dir = "cubemaps_final"

# Get all equirectangular images in the input directory
files = list(Path(input_dir).glob("*.jpg"))
print("Converting", len(files), "files")

for file in files:
    # Load the equirectangular image
    eq_img = np.array(Image.open(str(file)))
    print(" -- ", str(file)) 
    
    # Convert the equirectangular image to cube (dice format)
    cube_dice = py360convert.e2c(eq_img, face_w=1024)  # width should be 4 times the individual face size

    # Convert the cube dice to horizontal format (this is an intermediate step)
    cube_h = py360convert.cube_dice2h(cube_dice)

    # Convert the cube horizontal to a list of individual faces
    cube_dict = py360convert.cube_h2dict(cube_h)

    # Map the face index to its name based on the three.js code you provided
    face_map = {0: 'U', 1: 'L', 2: 'F', 3: 'R', 4: 'B', 5: 'D'}

    # Save each face with its corresponding name
    file_name = file.stem
    for faceI, face_img in face_map.items():
        output_name = f"{output_dir}/{file_name}_face{faceI}.jpg"
        print(" -- -- ", output_name, )
        Image.fromarray(cube_dict[face_map[faceI]]).save(output_name)


print("Conversion completed!")


