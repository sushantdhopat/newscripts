#!/bin/bash

# Check if the input file is provided and exists
if [ -z "$1" ]; then
    echo "Usage: $0 inputfile"
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo "File $input_file not found!"
    exit 1
fi

output_file="cachedurls.txt"
> "$output_file"  # Clear the output file if it exists

# Define the cache headers to look for
cache_headers=("Cache-Control" "Expires" "Vary" "Age" "Pragma" "Warning")

while IFS= read -r url; do
    echo "Processing URL: $url"  # Debug output

    # Fetch the headers for the URL
    headers=$(curl -sI "$url")
    if [ $? -ne 0 ]; then
        echo "Error fetching headers for $url"  # Debug output for curl error
        continue
    fi

    # Initialize a flag to indicate if a cache header is found
    found_cache_header=false

    # Check if any of the cache headers are present
    for header in "${cache_headers[@]}"; do
        if echo "$headers" | grep -qi "$header"; then
            found_cache_header=true
            echo "Found cache header $header for $url"  # Debug output
            break
        fi
    done

    # If any cache header is found, save the URL to the output file
    if $found_cache_header; then
        echo "$url" >> "$output_file"
    fi
done < "$input_file"

echo "URLs with cache headers have been saved to $output_file"

