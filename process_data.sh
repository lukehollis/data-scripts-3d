#!/bin/bash

# video to images
mkdir -p images
for file in *
do
	fname=${file/.mp4}
	fname=${fname/.mov}
  ffmpeg -i $file -r 2 -pix_fmt bgr8 images/"$fname"_frame_%05d.jpg  
done

# downscale them
# python downscale_images.py

# extract features
# colmap feature_extractor --database_path colmap/database.db --image_path images --ImageReader.single_camera 1 --ImageReader.camera_model OPENCV 
colmap feature_extractor --database_path colmap/database.db --image_path images --ImageReader.single_camera 1 --ImageReader.camera_model OPENCV --SiftExtraction.use_gpu 0

# match images
colmap vocab_tree_matcher --database_path ./colmap/database.db --VocabTreeMatching.vocab_tree_path ../vocab_tree.fbow
colmap vocab_tree_matcher --database_path ./colmap/database.db --SiftMatching.use_gpu 0 --VocabTreeMatching.vocab_tree_path ../vocab_tree.fbow
# sequential for video
colmap sequential_matcher --database_path ./colmap/database.db --SiftMatching.use_gpu 0 
# colmap exhaustive_matcher --SiftMatching.guided_matching=true --database_path ./colmap/database.db 

# mapper 
colmap mapper --database_path ./colmap/database.db --image_path images --output_path ./colmap/sparse --Mapper.ba_global_function_tolerance 1e-6

# adjust bundle
colmap bundle_adjuster --input_path colmap/sparse/0 --output_path colmap/sparse/0 --BundleAdjustment.refine_principal_point 1

# make transform
python make_transforms.py

# ready to train
# ns-train nerfacto --viewer.websocket-port 7007 nerfstudio-data --data .
