#!/bin/bash
#Author=sushantdhopat
rm -rf tech
mkdir tech
file=$1

cat $file | nuclei -t /root/nuclei-templates/http/technologies -exclude-templates /root/nuclei-templates/http/technologies/tech-detect.yaml -exclude-tags akamai,cdn,aws,amazon,cloudfront,secui,waf | tee tech/onlytech.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/apache | tee tech/apache-domains.txt
cat tech/apache-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/apache.txt
[ -s  tech/apache.txt ] && cat  tech/apache.txt || rm  tech/apache.txt
rm -rf tech/apache-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/aem-detect.yaml | tee tech/aem-domains.txt
cat tech/aem-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/aem.txt
[ -s  tech/aem.txt ] && cat  tech/aem.txt || rm  tech/aem.txt
rm -rf tech/aem-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/oracle | tee tech/oracle-domains.txt
cat tech/oracle-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/oracle.txt
[ -s  tech/oracle.txt ] && cat  tech/oracle.txt || rm  tech/oracle.txt
rm -rf tech/oracle-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/microsoft | tee tech/microsoft-domains.txt
cat tech/microsoft-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/microsoft.txt
[ -s  tech/microsoft.txt ] && cat  tech/microsoft.txt || rm  tech/microsoft.txt
rm -rf tech/microsoft-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/php-detect.yaml | tee tech/php-domains.txt
cat tech/php-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/php.txt
[ -s  tech/php.txt ] && cat  tech/php.txt || rm  tech/php.txt
rm -rf tech/php-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/nginx | tee tech/nginx-domains.txt
cat tech/nginx-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/nginx.txt
[ -s  tech/nginx.txt ] && cat  tech/nginx.txt || rm  tech/nginx.txt
rm -rf tech/nginx-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/adobe | tee tech/adobe-domains.txt
cat tech/adobe-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/adobe.txt
[ -s  tech/adobe.txt ] && cat  tech/adobe.txt || rm  tech/adobe.txt
rm -rf tech/adobe-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/default-fastcgi-page.yaml | tee tech/cgi-domains.txt
cat tech/cgi-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/cgi.txt
[ -s  tech/cgi.txt ] && cat  tech/cgi.txt || rm  tech/cgi.txt
rm -rf tech/cgi-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/jspxcms-detect.yaml | tee tech/jsp-domains.txt
cat tech/jsp-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/jsp.txt
[ -s  tech/jsp.txt ] && cat  tech/jsp.txt || rm  tech/jsp.txt
rm -rf tech/jsp-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/kubernetes | tee tech/kubernetes-domains.txt
cat tech/kubernetes-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/kubernet.txt
[ -s  tech/kubernet.txt ] && cat  tech/kubernet.txt || rm  tech/kubernet.txt
rm -rf tech/kubernetes-domains.txt

cat $file | nuclei -t /root/nuclei-templates/http/technologies/wordpress-detect.yaml | tee tech/wordpress-domains.txt
cat tech/wordpress-domains.txt | grep -Eo 'https?://[^/[:space:]]+\.[a-zA-Z]+' | sort -u | tee tech/wordpress.txt
[ -s  tech/wordpress.txt ] && cat  tech/wordpress.txt || rm  tech/wordpress.txt
rm -rf tech/wordpress-domains.txt
