#!/bin/bash

counter=1  # Initialize a counter for naming the output files

for x in $(cat "$1"); do
    output_file="vhost$counter.json"  # Generate the output file name
    ffuf -u "$x" -H "Host: FUZZ" -ac -w /root/dirbrut/vhost.txt -of json -o "$output_file"
    
    counter=$((counter + 1))  # Increment the counter for the next iteration
done
python3 /root/scripts/vhost.py *.json | tee vhost.txt
rm -rf *.json
