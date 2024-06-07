import json
import sys
import os

def remove_thumbnail_data(input_file):
    # Read the JSON data from the file
    with open(input_file, 'r') as file:
        data = json.load(file)

    # Process each item in the JSON data
    for item in data:
        if "thumbnail" in item:
            item["thumbnail"] = ""

    # Create output file name
    base_name, ext = os.path.splitext(input_file)
    output_file = f"{base_name}_modified{ext}"

    # Write the modified JSON data to a new file
    with open(output_file, 'w') as file:
        json.dump(data, file, indent=4)

    print(f"Modified JSON data has been saved to {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python remove_thumbnail_data.py <path_to_json_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    remove_thumbnail_data(input_file)

