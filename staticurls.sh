#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="staticurls.txt"

# Define static file extensions
static_extensions="(\.js|\.css|\.png|\.jpg|\.jpeg|\.gif|\.mp4|\.mp3|\.pdf|\.doc|\.docx|\.xls|\.xlsx|\.ppt|\.pptx)$"

# Use grep to filter and save the URLs with static file extensions
grep -E "$static_extensions" "$input_file" > "$output_file"

echo "Static URLs have been saved to $output_file"

