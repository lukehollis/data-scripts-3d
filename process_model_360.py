import Metashape
import os
import sys


def add_bottom_mask(camera, percentage=20):
    """
    Adds a mask to the bottom 'percentage' of the image associated with a given camera.

    Parameters:
    - camera: the Metashape camera object
    - percentage: percentage of the image from the bottom to mask
    """
    # Load the image
    image = camera.image()
    width = image.width
    height = image.height

    # Calculate the height of the masked area
    mask_height = int(image.height * (percentage / 100))

    # Create a blank mask with same size as image
    mask_image = Metashape.Image(width=image.width, height=image.height, channels=1, dtype='U8')
    mask_data = bytearray([255] * width * height)

    # Set bottom part of the mask to 0 (black)
    for i in range(height - mask_height, height):
        for j in range(width):
            mask_data[i * width + j] = 0

    # Convert bytearray back to an Image object
    mask_image = Metashape.Image.fromstring(bytes(mask_data), width, height, channels="Y", datatype='U8')
    mask = Metashape.Mask()
    mask.setImage(mask_image)

    # Apply mask to camera
    camera.mask = mask


# Ensure there's an input argument
if len(sys.argv) < 2:
    print("Usage: script_name.py <path_to_space_directory>")
    sys.exit(1)

# Initialize the Metashape application
app = Metashape.app

# Set paths based on the input argument
space_dir = sys.argv[1]
input_dir = os.path.join(space_dir, "eqs_orig")
output_obj = os.path.join(space_dir, "output.obj")
output_cameras = os.path.join(space_dir, "cameras.xml")

# Create a new project
doc = Metashape.Document()
chunk = doc.addChunk()

# Load images into the project
# image_files = [os.path.join(input_dir, f) for f in os.listdir(input_dir) if f.endswith(".JPG")]
# image_files = [os.path.join(input_dir, f) for f in os.listdir(input_dir) if f.endswith(".png")]
# image_files = [os.path.join(input_dir, f) for f in os.listdir(input_dir) if f.endswith(".jpg")]
image_files = [os.path.join(input_dir, f) for f in os.listdir(input_dir) if f.lower().endswith((".jpg", ".png"))]
chunk.addPhotos(image_files)

# Set the sensor type to Spherical for all cameras in the chunk:
for camera in chunk.cameras:
    camera.sensor.type = Metashape.Sensor.Type.Spherical
    add_bottom_mask(camera, percentage=20)

# Perform alignment
chunk.matchPhotos(downscale=1, generic_preselection=True, reference_preselection=False)
chunk.alignCameras()

# Build geometry
chunk.buildDepthMaps(downscale=1, filter_mode=Metashape.AggressiveFiltering)
chunk.buildPointCloud()
chunk.buildModel(source_data=Metashape.DepthMapsData, surface_type=Metashape.Arbitrary, interpolation=Metashape.EnabledInterpolation)
chunk.buildUV(mapping_mode=Metashape.GenericMapping)


# Build texture
chunk.buildTexture(blending_mode=Metashape.MosaicBlending, texture_size=8192)
doc.save(os.path.join(space_dir, "space.psx"))

# Export the result as OBJ with texture (PNG) and MTL
chunk.exportModel(output_obj)
chunk.exportCameras(output_cameras)

print("Finished processing!")