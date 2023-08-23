from nerfstudio.process_data import  colmap_utils
from nerfstudio.process_data.process_data_utils import CAMERA_MODELS


num_matched_frames = colmap_utils.colmap_to_json(
        cameras_path="./colmap/sparse/0/cameras.bin",
        images_path="./colmap/sparse/0/images.bin",
        output_dir="./",
        camera_model=CAMERA_MODELS["perspective"]
        )
print("matched images", num_matched_frames)
