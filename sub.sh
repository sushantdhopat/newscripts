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
python3 /root/censys-subdomain-finder/censys-subdomain-finder.py $target -o new-$target/$target-censys.txt

echo -e "\e[1;34m [+] Enumerating Subdomain from the shodan \e[0m"
shosubgo -d $target -s FgtigGqgk6SFQIvs48IY3lmVafmHR8ej | tee new-$target/shodansub.txt

echo -e "\e[1;34m [+] Enumerating Subdomain from the github \e[0m"

export GITHUB_TOKEN="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,\
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,\
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,\
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"

github-subdomains -d $target -o new-$target/githubsub.txt

#copy above all different files finded subdomain in one spefic file
cat new-$target/*.txt >> new-$target/allsub-$target.txt
rm new-$target/$target-assetfinder.txt new-$target/$target-subfinder.txt new-$target/$target-amass1.txt new-$target/$target-censys.txt new-$target/shodansub.txt new-$target/githubsub.txt
#sorting the uniq domains
 
cat new-$target/allsub-$target.txt | sed 's/\*\.//g' | sort -u | tee new-$target/allsortedsub-$target.txt
rm new-$target/allsub-$target.txt

echo -e "\e[1;34m [+] Running Httpx for live host \e[0m"
cat new-$target/allsortedsub-$target.txt | httpx -silent | tee new-$target/validsubdomain-$target.txt

echo -e "\e[1;34m [+] finding Intresting domains \e[0m"
cat new-$target/validsubdomain-$target.txt | grep -E "auth|corp|sign_in|sign_up|ldap|idp|dev|admin|login|signup|jira|gitlab|signin|ftp|ssh|git|jenkins|kibana|administration|administrator|administrative|grafana|jfrog|database|staging|test|qa|preprod|prod|portal|dashboard|monitor|elastic|splunk|support|helpdesk|ticket|secure|webmail|outlook|exchange|mail|postfix|smtp|pop3|imap|webadmin|root|backup|storage|cloud|vps|docker|kubernetes|registry|analytics|log|debug" >> new-$target/intrested_live_sub.txt
cat new-$target/intrested_live_sub.txt

echo -e "\e[1;34m [+] finding possible subdomain takeover \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/scripts/subtake | tee  new-$target/subtake.txt

echo -e "\e[1;34m [+] finding exposed panels \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/nuclei-templates/http/exposed-panels | tee new-$target/panels.txt

echo -e "\e[1;34m [+] finding default logins \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/nuclei-templates/http/default-logins | tee new-$target/defaultlogin.txt

echo -e "\e[1;34m [+] finding vulnerable from cves \e[0m"
cat new-$target/validsubdomain-$target.txt | nuclei -t /root/nuclei-templates/http/cves | tee new-$target/cves.txt

#echo -e "\e[1;34m [+] finding 403 status code subdomains \e[0m"
#cat new-$target/validsubdomain-$target.txt | httpx -status-code -mc 403 | awk '{print $1}' | tee new-$target/403sub.txt

cd new-$target
bash /root/scripts/onlytech.sh validsubdomain-$target.txt
