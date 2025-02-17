#!/bin/bash

GREEN="\033[0;32m"
ENDCOLOR="\033[0m"
output_dir="linkfinder"

echo -e "${GREEN}Javascript endpoints Discovery:${ENDCOLOR}"

# Create directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate over each URL in the input file
while IFS= read -r url; do
  # Generate a unique filename based on the URL
  output_file="$output_dir/$(echo "$url" | md5sum | cut -d ' ' -f1).txt"
  
  # Run the command and capture the output
  python3 /Users/sushantdhopat/desktop/linkfinder/linkfinder.py -i "$url" -o cli | tee "$output_file"
  
  # Check if the output file is empty, if so, remove it
  if [ ! -s "$output_file" ]; then
    rm "$output_file"
    echo "No output generated for $url. File $output_file deleted."
  fi
done < "$1"

