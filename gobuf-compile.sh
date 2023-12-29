#!/bin/bash

# Set the source directory containing .proto files
source_directory="src/protocol/protobuf"

# Set the target directory for compiled files
compiled_directory="addons/protocol/compiled"

# Create the compiled directory if it doesn't exist
mkdir -p "$compiled_directory"

# Find all .proto files recursively and process them
find "$source_directory" -type f -name "*.proto" | while read proto_file; do
    # Extract the relative path of the .proto file
    relative_path=$(dirname "${proto_file#$source_directory}")

    # Create the corresponding directory structure in the compiled directory
    mkdir -p "$compiled_directory$relative_path"

    # Compile for each .proto file and copy the output to the compiled directory
    proto_file="$source_directory$relative_path/$(basename "$proto_file")"
    gd_file="$compiled_directory$relative_path/$(basename "${proto_file%.proto}.gd")"

    godot --headless -q -s "addons/protobuf/protobuf_cmdln.gd" \
        --input="$proto_file" --output="$gd_file" 2>/dev/null
done

echo "Compilation completed. Compiled files are located in the '$compiled_directory' directory."
