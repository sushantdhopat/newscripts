#!/bin/bash

echo -e "\e[1;32m "
target=$1

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d newsub ]; then
       mkdir newsub
 else
    echo "sorry we cant create the same file in same directory please remove first one newsub !!!Thanks"
    exit 1

fi

echo -e "\e[1;34m [+] Enumerating Subdomain from the assetfinder \e[0m"
echo $target | assetfinder -subs-only| tee newsub/$target-assetfinder.txt

echo -e "\e[1;34m [+] Enumerating Subdomain from the subfinder \e[0m"
subfinder -d $target | tee newsub/$target-subfinder.txt

echo -e "\e[1;34m [+] Enumerating Subdomain from the amass \e[0m"
#amass enum -active -d $target -brute -w $wordlist -config /root/config.ini | tee newsub/$target-amass.txt
amass enum -passive -norecursive -noalts -d $target | tee  newsub/$target-amass1.txt

export CENSYS_API_ID=302bdd0b-930c-491b-a0ac-0c3caeb9725e
export CENSYS_API_SECRET=ZZTUbdkPJf2y3ehntVCLvDeFlHaOUddF
echo -e "\e[1;34m [+] Enumerating Subdomain from the censys \e[0m"
python3 /Users/sushantdhopat/desktop/censys-subdomain-finder/censys-subdomain-finder.py $target -o newsub/$target-censys.txt

#copy above all different files finded subdomain in one spefic file
cat newsub/*.txt >> newsub/allsub-$target.txt
rm newsub/$target-assetfinder.txt newsub/$target-subfinder.txt newsub/$target-amass1.txt newsub/$target-censys.txt
#sorting the uniq domains
 
cat newsub/allsub-$target.txt | sed 's/\*\.//g' | sort -u | tee newsub/allsortedsub-$target.txt
rm newsub/allsub-$target.txt

echo -e "\e[1;34m [+] Running Httpx for live host \e[0m"
cat newsub/allsortedsub-$target.txt | httpx -silent | tee newsub/validsubdomain-$target.txt

echo -e "\e[1;34m [+] finding possible subdomain takeover \e[0m"
cat newsub/validsubdomain-$target.txt | nuclei -t /Users/sushantdhopat/desktop/subtake | tee  newsub/subtake.txt
