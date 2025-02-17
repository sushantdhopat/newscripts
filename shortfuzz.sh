#!/bin/bash

# Check if a subdomain is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <subdomain>"
  exit 1
fi

SUBDOMAIN=$1
#WORDLIST="/root/fuzz/bigfuzz.txt"
WORDLIST="/root/fuzz/shortfuzz.txt"
OUTPUT_JSON="ffuf-$SUBDOMAIN.json"
RESULT_TXT="result-$SUBDOMAIN"

# Run ffuf
ffuf -u W2/W1 \
     -w "$WORDLIST:W1,$SUBDOMAIN:W2" \
     -ac -of json -o "$OUTPUT_JSON" -p 0.1 -t 10

# Process ffuf results
if [ -f "$OUTPUT_JSON" ]; then
  cat "$OUTPUT_JSON" | jq -r '.results[] | "\(.length)"+ " " +"\(.url)" + " " + "\(.status)"' \
    | sort -unt " " -k "1,1" \
    | tee "$RESULT_TXT"
  rm "$OUTPUT_JSON"
else
  echo "Error: Output file $OUTPUT_JSON not created."
  exit 1
fi
