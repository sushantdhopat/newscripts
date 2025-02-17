#!/bin/bash

target=$1
mkdir 4xx
cat $target | httpx -status-code -mc 403,404 | tee 4xx/4xx.txt
cat 4xx/4xx.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u >> 4xx/4xxnew.txt
rm 4xx/4xx.txt
#cd 4xx
#bash /root/scripts/cdn.sh 4xx/4xxcdn.txt
