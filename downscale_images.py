from nerfstudio.process_data import process_data_utils

image_dir = './images'
num_downscales = 3
verbose = 1
logs = process_data_utils.downscale_images(image_dir, num_downscales, verbose=verbose)

print("Downscale complete")
print(logs)
