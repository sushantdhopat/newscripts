#!/bin/bash

output_dir="./wayback"

# Check if the wayback directory exists in the current directory
if [ ! -d "$output_dir" ]; then
    # If the wayback directory doesn't exist, store output in the current directory
    output_dir="."
fi

echo -e "${GREEN}Getting urls from alienvaults:${ENDCOLOR}"
for x in $(cat "$1")
do
  curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$x/url_list?limit=100&page=1" | grep -o 'https\?://[^"]\+'
done | tee "$output_dir/otxurls.txt"

