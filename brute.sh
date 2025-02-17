#!/bin/bash


target=$1
target2=$2
#fisrt sub wordlist then domain test.txt test.com
#pass domain name also with the wordlist
wordlist=/root/best-dns-wordlist.txt
resolver=/root/resolvers.txt

if [ $# -gt 2 ]; then
       echo "./sub.sh <domain>"
       echo "./sub.sh google.com"
       exit 1
fi

if [ ! -d subrute ]; then
       mkdir subrute
 else
    echo "sorry we cant create the same file in same directory please remove first one subrute !!!Thanks"
    exit 1

fi


echo -e "\e[1;34m [+] Bruteforce subdomain using PureDNS \e[0m"
puredns bruteforce -r $resolver $wordlist $target2 | tee subrute/bruteforce-puredns.txt

echo -e "\e[1;34m [+] Bruteforce subdomain using DNSx \e[0m"
dnsx -silent -r $resolver -d $target2 -w $wordlist | tee subrute/bruteforce-dnsx.txt

echo -e "\e[1;34m [+] Validating subdomains using MassDNS \e[0m"
cat subrute/*.txt | sort -u > subrute/all_subdomains.txt
massdns -r $resolver -t A -o S subrute/all_subdomains.txt | tee subrute/massdns-validated.txt

#rm subrute/bruteforce-puredns.txt subrute/bruteforce-dnsx.txt

echo -e "\e[1;34m [+] Final subdomains list \e[0m"
cat subrute/massdns-validated.txt | sort -u > subrute/final-subdomains.txt
