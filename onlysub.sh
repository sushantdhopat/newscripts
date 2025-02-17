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

echo -e "\e[1;34m [+] Enumerating Subdomain from the assetfinder \e[0m"
echo $target | assetfinder -subs-only| tee new-$target/$target-assetfinder.txt

echo -e "\e[1;34m [+] Enumerating Subdomain from the subfinder \e[0m"
subfinder -d $target | tee new-$target/$target-subfinder.txt

echo -e "\e[1;34m [+] Enumerating Subdomain from the amass \e[0m"
#amass enum -active -d $target -brute -w $wordlist -config /root/config.ini | tee new-$target/$target-amass.txt
amass enum -passive -norecursive -noalts -d $target | tee  new-$target/$target-amass1.txt

export CENSYS_API_ID=302bdd0b-930c-491b-a0ac-0c3caeb9725e
export CENSYS_API_SECRET=ZZTUbdkPJf2y3ehntVCLvDeFlHaOUddF
echo -e "\e[1;34m [+] Enumerating Subdomain from the censys \e[0m"
python3 /Users/sushantdhopat/desktop/censys-subdomain-finder/censys-subdomain-finder.py $target -o new-$target/$target-censys.txt

#copy above all different files finded subdomain in one spefic file
cat new-$target/*.txt >> new-$target/allsub-$target.txt
rm new-$target/$target-assetfinder.txt new-$target/$target-subfinder.txt new-$target/$target-amass1.txt new-$target/$target-censys.txt
#sorting the uniq domains
 
cat new-$target/allsub-$target.txt | sed 's/\*\.//g' | sort -u | tee new-$target/allsortedsub-$target.txt
rm new-$target/allsub-$target.txt

echo -e "\e[1;34m [+] Running Httpx for live host \e[0m"
cat new-$target/allsortedsub-$target.txt | httpx -silent | tee new-$target/validsubdomain-$target.txt

echo -e "\e[1;34m [+] Running for getting intresting subdomain \e[0m"
cat new-$target/validsubdomain-$target.txt | grep -E "auth|corp|sign_in|sign_up|ldap|idp|dev|api|admin|login|signup|jira|gitlab|signin|ftp|ssh|git|jenkins|kibana|administration|administrator|administrative|grafana|vpn|jfroge" >> new-$target/intrested_live_sub.txt
cat new-$target/intrested_live_sub.txt