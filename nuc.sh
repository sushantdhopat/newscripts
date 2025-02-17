#!/bin/bash

echo -e "\e[1;32m "
target=$1

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d nuclei ]; then
       mkdir nuclei
 else
    echo "sorry we cant create the same file in same directory please remove first one nuclei !!!Thanks"
    exit 1

fi

echo -e "\e[1;34m [+] performing nuclei scan on valid subdomains \e[0m"

cat $target | nuclei -severity critical -t /root/nuclei-templates -o nuclei/critical
cat nuclei/critical | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat $target | nuclei -severity high -t /root/nuclei-templates -o nuclei/high
cat nuclei/high | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat $target | nuclei -severity medium -t /root/nuclei-templates -o nuclei/medium
cat nuclei/medium | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat $target | nuclei -severity low -t /root/nuclei-templates -o nuclei/low
cat nuclei/low | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
