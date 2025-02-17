#!/bin/bash

echo -e "\e[1;32m "
target=$1

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d new-$target ]; then
       mkdir new-$target
 else
    echo "sorry we cant create the same file in same directory please remove first one new-$target !!!Thanks"
    exit 1

fi


echo -e "\e[1;34m [+] Running Httpx for live host \e[0m"
cat $target | httpx -silent | tee new-$target/validsubdomain-$target.txt

cat new-$target/validsubdomain-$target.txt | grep -E "auth|corp|sign_in|sign_up|ldap|idp|dev|api|admin|login|signup|jira|gitlab|signin|ftp|ssh|git|jenkins|kibana|administration|administrator|administrative|grafana|vpn|jfroge" >> new-$target/intrested_live_sub.txt
cat new-$target/intrested_live_sub.txt

echo -e "\e[1;34m [+] finding possible subdomain takeover \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/scripts/subtake | tee  new-$target/subtake.txt

echo -e "\e[1;34m [+] finding exposed panels \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/nuclei-templates/http/exposed-panels | tee new-$target/panels.txt

echo -e "\e[1;34m [+] finding default logins \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/nuclei-templates/http/default-logins | tee new-$target/defaultlogin.txt

echo -e "\e[1;34m [+] finding vulnerable from cves \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/nuclei-templates/http/cves | tee new-$target/cves.txt

echo -e "\e[1;34m [+] finding 403 status code subdomains \e[0m"
cat new-$target/validsubdomain-$target.txt | httpx -status-code -mc 403 | awk '{print $1}' | tee new-$target/403sub.txt

echo -e "\e[1;34m [+] finding 404 status code subdomains \e[0m"
cat new-$target/validsubdomain-$target.txt | httpx -status-code -mc 404 | awk '{print $1}' | tee new-$target/404sub.txt

cd new-$target
bash /root/scripts/onlytech.sh validsubdomain-$target.txt
