from PIL import Image
import numpy as np
import py360convert
from pathlib import Path

# Set the maximum number of pixels allowed
Image.MAX_IMAGE_PIXELS = None  # This removes the limit completely

def flip_horizontal(image):
    return image.transpose(Image.FLIP_LEFT_RIGHT)

def rotate_image(image, angle):
    """
    Rotates an image by the specified angle.
    Can handle both PIL Image object and numpy ndarray.
    :param image: PIL Image object or numpy ndarray
    :param angle: Angle in degrees for rotation
    :return: Rotated object (same type as input)
    """
    if isinstance(image, Image.Image):
        return image.rotate(angle)
    elif isinstance(image, np.ndarray):
        return np.array(Image.fromarray(image).rotate(angle))
    else:
        raise TypeError(f"Cannot handle image type {type(image)}")

input_dir = "eqs_tpz"
output_dir = "cubemaps"

# Get all equirectangular images in the input directory

# Function to get all equirectangular images in the input directory
def get_files(directory, extensions):
    all_files = []
    for ext in extensions:
        all_files.extend(Path(directory).glob(f"*.{ext}"))
        all_files.extend(Path(directory).glob(f"*.{ext.upper()}"))
    return all_files

# Supported extensions
extensions = ['jpg', 'png']

# Get all equirectangular images in the input directory
files = get_files(input_dir, extensions)
print("Converting", len(files), "files")

for file in files:

    file_name = file.stem
    output_name_check = f"{output_dir}/{file_name}_face0.jpg"
    
    # Check if the first face already exists, skip the whole file if it does
    if Path(output_name_check).exists():
        print(f"Skipping {file_name}, faces already generated.")
        continue
    

    # Load the equirectangular image
    eq_img = np.array(Image.open(str(file)))
    print(" -- ", str(file)) 
    
    # Convert the equirectangular image to cube (dice format)
    cube_dice = py360convert.e2c(eq_img, face_w=4096)
    # cube_dice = py360convert.e2c(eq_img, face_w=1024)

    # Convert the cube dice to horizontal format (this is an intermediate step)
    cube_h = py360convert.cube_dice2h(cube_dice)

    # Convert the cube horizontal to a list of individual faces
    cube_dict = py360convert.cube_h2dict(cube_h)

    # Map the face index to its name
    face_map = {0: 'U', 1: 'F', 2: 'R', 3: 'B', 4: 'L', 5: 'D'}

    # Perform operations on each face and save it
    file_name = file.stem
    for faceI, face_name in face_map.items():
        if face_name == 'B':
            cube_dict[face_name] = np.array(flip_horizontal(Image.fromarray(cube_dict[face_name])))
        elif face_name == 'R':
            cube_dict[face_name] = np.array(flip_horizontal(Image.fromarray(cube_dict[face_name])))
        elif face_name == 'U':
            cube_dict[face_name] = np.array(flip_horizontal(Image.fromarray(cube_dict[face_name])))
            cube_dict[face_name] = np.array(rotate_image(Image.fromarray(cube_dict[face_name]), 180))

        output_name = f"{output_dir}/{file_name}_face{faceI}.jpg"
        print(" -- -- ", output_name)
        Image.fromarray(cube_dict[face_name]).save(output_name)

print("Conversion completed!")
