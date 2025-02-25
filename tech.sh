#!/bin/bash
#Author=sushantdhopat
rm -rf ffuftest
mkdir ffuftest
file=$1

cat $file | nuclei -t /root/nuclei-templates/http/technologies -exclude-templates /root/nuclei-templates/http/technologies/tech-detect.yaml -exclude-tags akamai,cdn,aws,amazon,cloudfront,secui,waf | tee ffuftest/onlytech.txt

grep -i "apache" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/apache.txt
grep -i "adobe" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/adobe.txt
grep -i "microsoft" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/microsoft.txt
grep -i "oracle" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/oracle.txt
grep -i "aem" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/aem.txt
grep -i "php" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/php.txt
grep -i "nginx" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/nginx.txt
grep -i "cgi" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/cgi.txt
grep -i "jsp" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/jsp.txt
grep -i "kubernetes" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/kubernetes.txt
grep -i "wordpress" ffuftest/onlytech.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/wordpress.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/apache | tee ffuftest/apache-domains.txt
cat ffuftest/apache-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/apache.txt
rm -rf ffuftest/apache-domains.txt

if [ ! -e "ffuftest/apache.txt" ] || [ ! -s "ffuftest/apache.txt" ]; then
  echo "no any apache domains found"
else
  ffuf -u W2/W1 -w /root/tech/apache.txt:W1,ffuftest/apache.txt:W2 -ac -of json -o ffuftest/apache.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/aem-detect.yaml | tee ffuftest/aem-domains.txt
cat ffuftest/aem-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/aem.txt
rm -rf ffuftest/aem-domains.txt

if [ ! -e "ffuftest/aem.txt" ] || [ ! -s "ffuftest/aem.txt" ]; then
  echo "no any aem domains found"
else
  ffuf -u W2/W1 -w /root/tech/aem.txt:W1,ffuftest/aem.txt:W2 -ac -of json -o ffuftest/aem.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/oracle | tee ffuftest/oracle-domains.txt
cat ffuftest/oracle-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/oracle.txt
rm -rf ffuftest/oracle-domains.txt


if [ ! -e "ffuftest/oracle.txt" ] || [ ! -s "ffuftest/oracle.txt" ]; then
  echo "no any oracle domains found"
else
  ffuf -u W2/W1 -w /root/tech/oracle.txt:W1,ffuftest/oracle.txt:W2 -ac -of json -o ffuftest/valid-oracle-files.json
fi


cat $file | nuclei -t /root/nuclei-templates/http/technologies/microsoft | tee ffuftest/microsoft-domains.txt
cat ffuftest/microsoft-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/microsoft.txt
rm -rf ffuftest/microsoft-domains.txt

if [ ! -e "ffuftest/microsoft.txt" ] || [ ! -s "ffuftest/microsoft.txt" ]; then
  echo "no any microsoft domains found"
else
  ffuf -u W2/W1 -w /root/tech/aspx.txt:W1,ffuftest/microsoft.txt:W2 -ac -of json -o ffuftest/microsoft.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/php-detect.yaml | tee ffuftest/php-domains.txt
cat ffuftest/php-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/php.txt
rm -rf ffuftest/php-domains.txt

if [ ! -e "ffuftest/php.txt" ] || [ ! -s "ffuftest/php.txt" ]; then
  echo "no any php domains found"
else
  ffuf -u W2/W1 -w /root/tech/php.txt:W1,ffuftest/php.txt:W2 -ac -of json -o ffuftest/php.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/nginx | tee ffuftest/nginx-domains.txt
cat ffuftest/nginx-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/nginx.txt
rm -rf ffuftest/nginx-domains.txt

if [ ! -e "ffuftest/nginx.txt" ] || [ ! -s "ffuftest/nginx.txt" ]; then
  echo "no any nginx domains found"
else
  ffuf -u W2/W1 -w /root/tech/nginx.txt:W1,ffuftest/nginx.txt:W2 -ac -of json -o ffuftest/nginx.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/adobe | tee ffuftest/adobe-domains.txt
cat ffuftest/adobe-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/adobe.txt
rm -rf ffuftest/adobe-domains.txt

if [ ! -e "ffuftest/adobe.txt" ] || [ ! -s "ffuftest/adobe.txt" ]; then
  echo "no any adobe domains found"
else
  ffuf -u W2/W1 -w /root/tech/adobe.txt:W1,ffuftest/adobe.txt:W2 -ac -of json -o ffuftest/adobe.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/default-fastcgi-page.yaml | tee ffuftest/cgi-domains.txt
cat ffuftest/cgi-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/cgi.txt
rm -rf ffuftest/cgi-domains.txt

if [ ! -e "ffuftest/cgi.txt" ] || [ ! -s "ffuftest/cgi.txt" ]; then
  echo "no any cgi domains found"
else
  ffuf -u W2/W1 -w /root/tech/cgi.txt:W1,ffuftest/cgi.txt:W2 -ac -of json -o ffuftest/cgi.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/jspxcms-detect.yaml | tee ffuftest/jsp-domains.txt
cat ffuftest/jsp-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/jsp.txt
rm -rf ffuftest/jsp-domains.txt

if [ ! -e "ffuftest/jsp.txt" ] || [ ! -s "ffuftest/jsp.txt" ]; then
  echo "no any jsp domains found"
else
  ffuf -u W2/W1 -w /root/tech/jsp.txt:W1,ffuftest/jsp.txt:W2 -ac -of json -o ffuftest/jsp.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/kubernetes | tee ffuftest/kubernetes-domains.txt
cat ffuftest/kubernetes-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/kubernet.txt
rm -rf ffuftest/kubernetes-domains.txt

if [ ! -e "ffuftest/kubernet.txt" ] || [ ! -s "ffuftest/kubernet.txt" ]; then
  echo "no any kubernete domains found"
else
  ffuf -u W2/W1 -w /root/tech/kubernet.txt:W1,ffuftest/kubernet.txt:W2 -ac -of json -o ffuftest/kubernet.json
fi

cat $file | nuclei -t /root/nuclei-templates/http/technologies/wordpress-detect.yaml | tee ffuftest/wordpress-domains.txt
cat ffuftest/wordpress-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-z]{2,}' | tee -a ffuftest/wordpress.txt
rm -rf ffuftest/wordpress-domains.txt

if [ ! -e "ffuftest/wordpress.txt" ] || [ ! -s "ffuftest/wordpress.txt" ]; then
  echo "no any wordpress domains found"
else
  ffuf -u W2/W1 -w /root/tech/wordpress.txt:W1,ffuftest/wordpress.txt:W2 -ac -of json -o ffuftest/wordpress.json
fi

cat ffuftest/*.json | jq -r '.results[] | "\(.length)"+ " " +"\(.url)" + " " + "\(.status)"' | sort -unt " " -k "1,1" | tee ffuftest/result.txt
