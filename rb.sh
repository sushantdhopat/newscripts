echo -e "\e[1;32m "

echo -e "\e[1;34m [+] finding robots.txt file from subdomain \e[0m"
httpx -l $1 -path /robots.txt -silent -o robots-url.txt

echo -e "\e[1;34m [+] finding disallow paths from the robots.txt \e[0m"
for url in $(cat robots-url.txt);do http -b $url | grep 'Disallow' | awk -F ' ' '{print $2}' | cut -c 2- | anew robot-words.txt;done

echo -e "\e[1;34m [+] Finished all recon \e[0m"
