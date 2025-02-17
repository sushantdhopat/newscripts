#!/bin/bash
# this script is add ' at every param in urls
# Check if the correct number of command-line arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="sqliparamforburp.txt"

# Add single quote after each parameter value and save to output file
sed "s/=\([^&]*\)/=\1'/g" "$input_file" > "$output_file"

echo "Modified URLs have been saved to '$output_file'."
