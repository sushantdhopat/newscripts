#!/bin/bash

echo -e "\e[1;32m "
target=$1

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d wayback ]; then
       mkdir wayback
 else
    echo "sorry we cant create the same file in same directory please remove first one wayback !!!Thanks"
    exit 1

fi

echo -e "\e[1;34m [+] performing wayback  \e[0m"

cat $target | gau | tee wayback/gau.txt
cat $target | waybackurls | tee wayback/wayback.txt
katana -list $target | tee wayback/katana.txt
gospider -S $target -o wayback/gospider.txt -c 10 -d 1 --other-source --include-subs --blacklist
cat $target | hakrawler | tee wayback/hakrawler.txt
sed -E 's/^https?:\/\///' $target | tee wayback/forotx.txt
bash /root/scripts/otx.sh wayback/forotx.txt
rm wayback/forotx.txt
cat wayback/gau.txt wayback/wayback.txt wayback/katana.txt wayback/gospider.txt wayback/hakrawler.txt wayback/otxurls.txt >> wayback/urls.txt
rm wayback/gau.txt wayback/wayback.txt wayback/katana.txt wayback/gospider.txt wayback/hakrawler.txt wayback/otxurls.txt
cat wayback/urls.txt | sort -u | tee wayback/allurl.txt
rm wayback/urls.txt
cat wayback/allurl.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
sleep 5

#echo -e "Start Finding sensetive pdf"
#mkdir wayback/senfile
#grep -Ea '\.pdf' wayback/allurl.txt | httpx -silent -mc 200 | while read -r url; do if curl -s "$url" | pdftotext -q - - | grep -Eaiq 'internal use only|confidential'; then echo "$url"; fi; done > wayback/senfile/urls.txt
#cat wayback/senfile/urls.txt
#sleep 5

echo -e "\e[1;34m [+] Collecting Intresting urls  \e[0m"
cat wayback/allurl.txt | grep -E "login|signin|signup|admin|dashboard|panel|auth|secure|api|v1|v2|dev|staging|qa|test|user|account|forgot|reset|update|profile|password|settings|wp-admin|phpmyadmin|adminer|ftp|ssh|git|jira|gitlab|jenkins|grafana|kibana|elastic|backup|restore|s3|cloud|webmail|email|outlook|exchange|smtp|pop3|imap|management|reports|metrics|monitor|debug|logs|log|api|jwt|token|secure|auth|services|upload|download|file|cdn|storage|files|public|private|files|access|webdav|cloudfront|api-docs|docs|webhooks|web-service|webhook|healthcheck|php|asp|aspx|jsp" >> wayback/inturls.txt 

echo -e "\e[1;34m [+] performing Js files scan  \e[0m"

mkdir wayback/jsfile
mkdir wayback/end
echo -e "Collect js,php,jsp,aspx File"

cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u | grep -aEi '\.js(\?|$)' | tee wayback/jsfile/jsfile.txt
cat wayback/jsfile/jsfile.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(php)" | tee wayback/end/php.txt
cat wayback/end/php.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(aspx|asp)" | tee wayback/end/aspx.txt
cat wayback/end/aspx.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/allurl.txt | grep -aEo 'https?://[^ ]+' | sed 's/]$//' | sort -u| grep -aEi "\.(jsp|jspx)" | tee wayback/end/jsp.txt
cat wayback/end/jsp.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
cat wayback/end/php.txt wayback/end/aspx.txt wayback/end/jsp.txt >> wayback/end/allendfile.txt
cat wayback/end/allendfile.txt | sort -u | tee wayback/end/allend.txt
rm wayback/end/allendfile.txt
sleep 5

#echo -e "Start Finding 200 status code for all urls"
#cat wayback/allurl.txt | httpx -status-code -mc 200 | awk '{print $1}' | tee wayback/allurlvalid.txt
#sleep 5

#api endpoint
echo -e "Starting Collect Api-Endpoint"
cat wayback/allurlvalid.txt | grep -i "/api/" | sort -u | tee wayback/apiend.txt
cat wayback/apiend.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
sleep 5

mkdir wayback/zipfiles
echo -e "Start Finding zip files"
grep '\.zip$' wayback/allurlvalid.txt | tee wayback/zipfiles/zips.txt
sleep 5

#echo -e "Start Finding 200 status code for all end"
#cat wayback/end/allend.txt | httpx -status-code -mc 200 | awk '{print $1}' | tee wayback/end/allendvalid.txt
#sleep 5

#echo -e "Start Finding 403 status code for all urls"
#cat wayback/allurl.txt | httpx -status-code -mc 403 | awk '{print $1}' | tee wayback/allurl403.txt
#sleep 5

#echo -e "Start Finding 403 status code for all end"
#cat wayback/end/allend.txt | httpx -status-code -mc 403 | awk '{print $1}' | tee wayback/end/allend403.txt
#sleep 5

echo -e "Start Filter Js file"

cat wayback/jsfile/jsfile.txt | sort -u | httpx -content-type | grep 'application/javascript' | cut -d' ' -f1 > wayback/jsfile/jsfile200.txt
cat wayback/jsfile/jsfile200.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
httpx -l wayback/jsfile/jsfile200.txt -match-string "js.map" -o wayback/jsfile/Jsmap.txt
sleep 5

echo -e "Starting Js Scan"

cat wayback/jsfile/jsfile200.txt | nuclei -t /root/nuclei-templates/http/exposures -o wayback/jsfile/nucleijs.txt
cat wayback/jsfile/nucleijs.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l
