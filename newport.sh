#!/bin/bash

echo -e "\e[1;32m "
target=$1

# help command for the script run
if [ $# -gt 2 ]; then
    echo "./sub.sh <domain>"
    echo "./sub.sh google.com"
    exit 1
fi

# if the ports folder exist this exit this script
if [ ! -d ports ]; then
    mkdir ports
else
    echo "Sorry, we can't create the same file in the same directory. Please remove the first one (ports)!!! Thanks."
    exit 1
fi


# Process the target list to remove http:// and https:// prefixes
if [[ $target == http://* || $target == https://* ]]; then
    # Remove http:// or https:// from the target
    target=$(echo "$target" | sed 's|^http[s]*://||')
    echo "$target" > newtarget.txt
else
    echo "$target" > newtarget.txt
fi

echo -e "\e[1;34m [+] Performing port scan  \e[0m"

naabu -list newtarget.txt -p - -exclude-ports 80,443,8443,21,25,22 -o ports/port.txt

cat ports/port.txt | httpx -o ports/liveport.txt

cat ports/port.txt | grep -E ":81|:300|:591|:593|:832|:981|:1010|:1311|:1099|:2082|:2095|:2096|:2480|:3000|:3128|:3333|:4243|:4567|:4711|:4712|:4993|:5000|:5104|:5108|:5280|:5281|:5601|:5800|:6543|:7000|:7001|:7396|:7474|:8000|:8001|:8008|:8014|:8042|:8060|:8069|:8080|:8081|:8083|:8088|:8090|:8091|:8095|:8118|:8123|:8172|:8181|:8222|:8243|:8280|:8281|:8333|:8337|:8443|:8500|:8834|:8880|:8888|:8983|:9000|:9001|:9043|:9060|:9080|:9090|:9091|:9200|:9443|:9502|:9800|:9981|:10000|:10250|:11371|:12443|:15672|:16080|:17778|:18091|:18092|:20720|:32000|:55440|:55672" >> ports/intersed_port.txt

cat ports/liveport.txt | grep -E ":81|:300|:591|:593|:832|:981|:1010|:1311|:1099|:2082|:2095|:2096|:2480|:3000|:3128|:3333|:4243|:4567|:4711|:4712|:4993|:5000|:5104|:5108|:5280|:5281|:5601|:5800|:6543|:7000|:7001|:7396|:7474|:8000|:8001|:8008|:8014|:8042|:8060|:8069|:8080|:8081|:8083|:8088|:8090|:8091|:8095|:8118|:8123|:8172|:8181|:8222|:8243|:8280|:8281|:8333|:8337|:8443|:8500|:8834|:8880|:8888|:8983|:9000|:9001|:9043|:9060|:9080|:9090|:9091|:9200|:9443|:9502|:9800|:9981|:10000|:10250|:11371|:12443|:15672|:16080|:17778|:18091|:18092|:20720|:32000|:55440|:55672" >> ports/intersed_liveport.txt

# Cleanup temporary file
rm newtarget.txt
