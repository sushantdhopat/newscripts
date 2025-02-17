#!/bin/bash
target=$1
mkdir wayback
echo -e "Starting Collect Api-Endpoint"
cat $target | grep -i "/api/" | sort -u | tee wayback/apiend.txt
cat wayback/apiend.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
sleep 5

echo -e "\e[1;34m [+] performing Js files scan  \e[0m"

mkdir wayback/jsfile
mkdir wayback/end
echo -e "Collect js,php,jsp,aspx File"

cat $target | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(js)" | tee wayback/jsfile/jsfile.txt
cat wayback/jsfile/jsfile.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat $target | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(php)" | tee wayback/end/php.txt
cat wayback/end/php.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat $target | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(aspx|asp)" | tee wayback/end/aspx.txt
cat wayback/end/aspx.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat $target | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(jsp|jspx)" | tee wayback/end/jsp.txt
cat wayback/end/jsp.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/end/php.txt wayback/end/aspx.txt wayback/end/jsp.txt >> wayback/end/allendfile.txt
cat wayback/end/allendfile.txt | sort -u | tee wayback/end/allend.txt
rm wayback/end/allendfile.txt

echo -e "Start Filter Js file"

cat wayback/jsfile/jsfile.txt | sort -u | httpx -content-type | grep 'application/javascript' | cut -d' ' -f1 > wayback/jsfile/jsfile200.txt
cat wayback/jsfile/jsfile200.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
httpx -l wayback/jsfile/jsfile200.txt -match-string "js.map" -o wayback/jsfile/Jsmap.txt

echo -e "Starting Js Scan"

cat wayback/jsfile/jsfile200.txt | nuclei -t /Users/sushantdhopat/desktop/nuclei-templates/http/exposures -o wayback/jsfile/nucleijs.txt
cat wayback/jsfile/nucleijs.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
