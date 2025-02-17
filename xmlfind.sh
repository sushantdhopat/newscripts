#!/bin/bash

# Check if filename containing URLs is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <urls_file>"
    exit 1
fi

urls_file=$1
error_file="xml_processing_errors.txt"
success_file="xml_success_endpoints.txt"

# Clear or create the output files
> "$error_file"
> "$success_file"

# Function to check if a URL processes XML or returns errors
check_url_for_xml() {
    url=$1
    echo "Checking URL: $url"

    # Sending a custom XML payload with XML declaration and distinct data
    payload='<?xml version="1.0" encoding="UTF-8"?><user><id>123</id><action>create</action></user>'
    response=$(curl -s -X POST -H "Content-Type: application/xml" -d "$payload" "$url")

    # Check for XML-specific error messages in the response (parser, malformed, etc.)
    if echo "$response" | grep -Ei "XML parser|org.xml.sax.SAXParseException|could not be parsed|malformed|Invalid XML|Error processing" > /dev/null; then
        echo "$url returned an XML processing error" >> "$error_file"
    elif echo "$response" | grep -i "<user>" > /dev/null; then
        # If the XML was processed and we see the XML payload reflected in the response
        echo "$url successfully processed the XML payload" >> "$success_file"
    fi
}

# Loop through each URL in the file and check for XML success or errors
while IFS= read -r url; do
    check_url_for_xml "$url"
done < "$urls_file"

echo "Processing complete. Errors saved to $error_file and successes saved to $success_file"
