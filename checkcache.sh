#!/bin/bash

# Check if the input file exists
if [ ! -f "staticurls.txt" ]; then
    echo "File staticurls.txt not found!"
    exit 1
fi

output_file="cachedurls.txt"
> "$output_file"  # Clear the output file if it exists

# Define the cache headers to look for
cache_headers=("Cache-Control" "Expires" "ETag" "Last-Modified" "Vary" "Age" "Pragma" "Warning")

while IFS= read -r url; do
    # Fetch the headers for the URL
    headers=$(curl -sI "$url")

    # Initialize a flag to indicate if a cache header is found
    found_cache_header=false

    # Check if any of the cache headers are present
    for header in "${cache_headers[@]}"; do
        if echo "$headers" | grep -qi "$header"; then
            found_cache_header=true
            break
        fi
    done

    # If any cache header is found, save the URL to the output file
    if $found_cache_header; then
        echo "$url" >> "$output_file"
    fi
done < "staticurls.txt"

echo "URLs with cache headers have been saved to $output_file"

