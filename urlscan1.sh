#!/bin/bash

# Check if the number of arguments provided is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Set your API key
api_key="ded83911-b70a-4582-be07-584561493f29"

for x in $(cat $1 )
do
search_results=$(curl -s -X GET "https://urlscan.io/api/v1/search/?q=domain:$x" -H "API-Key: $api_key")
done

# Extract the URLs from the search results
urls=$(echo "$search_results" | jq -r '.results[].task.url')

# Print the URLs
echo "URLs associated with domain $x:"
echo "$urls"
