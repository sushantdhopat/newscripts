#!/bin/bash

# Check if an input file is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Input file containing the list of URLs
input_file="$1"

# Output file to store the filtered URLs
output_file="filtered_urls.txt"

# List of file extensions to filter
extensions="\.js|\.css|\.png|\.jpg|\.jpeg|\.gif|\.svg|\.webp|\.ico|\.woff|\.woff2|\.ttf|\.otf|\.eot|\.mp4|\.mp3|\.wav|\.ogg|\.webm|\.pdf|\.doc|\.docx|\.xls|\.xlsx|\.ppt|\.pptx|\.html|\.json|\.xml"

# Function to extract the domain from a URL
extract_domain() {
    local url=$1
    echo "$url" | awk -F[/:] '{print $4}'
}

# Initialize an associative array to track seen domains
declare -A seen_domains

# Initialize an array to store filtered URLs
filtered_urls=()

# Read the input file line by line
while IFS= read -r url; do
    # Check if the URL matches one of the specified extensions
    if [[ "$url" =~ $extensions ]]; then
        domain=$(extract_domain "$url")
        if [[ -z "${seen_domains[$domain]}" ]]; then
            # If domain has not been seen, add it to the seen_domains array and filtered_urls array
            seen_domains["$domain"]=1
            filtered_urls+=("$url")
        fi
    fi
done < "$input_file"

# Write the filtered URLs to the output file
printf "%s\n" "${filtered_urls[@]}" > "$output_file"

# Optionally, print the filtered URLs to the console
printf "%s\n" "${filtered_urls[@]}"

echo "Filtered URLs have been written to $output_file"

