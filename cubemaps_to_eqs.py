import os
import re
from PIL import Image
import numpy as np
import py360convert

CUBEMAP_DIR = './cubemaps'
EQ_DIR = './eqs_unedited'

# Create the eqs directory if it does not exist
if not os.path.exists(EQ_DIR):
    os.mkdir(EQ_DIR)

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


def convert_cubemap_to_eq(cube_images, output_name):
    # Assuming all cube images have the same size
    w, h = cube_images[0].size  # Adjusted this line

    cube_list = [np.array(img) for img in cube_images]
    
    # Given that each face of the cube is h x w, the equirectangular image will be h x 2w.
    # Normalize to [0, 1]
    equirectangular = py360convert.c2e(cube_list, h, 2 * w, cube_format='list')
    equirectangular = (equirectangular - equirectangular.min()) / (equirectangular.max() - equirectangular.min())

    # Convert the floating point image in the range [0, 1] to an unsigned byte image ([0, 255]).
    equirectangular_uint8 = (equirectangular * 255).astype(np.uint8)
    Image.fromarray(equirectangular_uint8).save(output_name)
    print(" -- converted", output_name)


def get_cube_images_for_id(image_id):
    """Returns a sorted list of cube face images for a specific ID."""
    return sorted([os.path.join(CUBEMAP_DIR, f"{image_id}_face{i}.jpg") for i in range(6)])

def main():
    # Get unique image IDs
    image_ids = set()
    for filename in os.listdir(CUBEMAP_DIR):
        match = re.match(r"(\w+)_face\d.jpg", filename)
        if match:
            image_ids.add(match.group(1))

    # Convert each set of cube face images to equirectangular
    for image_id in image_ids:
        cube_image_paths = get_cube_images_for_id(image_id)
        cube_images = [Image.open(img_path) for img_path in cube_image_paths]

        # transpose
        cube_images[2] = flip_horizontal(cube_images[2])  # for face2
        cube_images[3] = flip_horizontal(cube_images[3])  # for face3
        cube_images[0] = flip_horizontal(cube_images[0])  # for face0
        cube_images[0] = rotate_image(cube_images[0], 180)

        
        # Original order: ['Top', 'Front', 'Left', 'Back', 'Right', 'Bottom']
        correct_order = [1, 2, 3, 4, 0, 5]

        # Rotate the bottom face image
        cube_images_reordered = [cube_images[i] for i in correct_order]

        eq_output_name = os.path.join(EQ_DIR, f"{image_id}.jpg")
        convert_cubemap_to_eq(cube_images_reordered, eq_output_name)

if __name__ == "__main__":
    main()
