ffuf -u W2/W1 -w /root/dirbrut/fuzz.txt:W1,$1:W2 -ac -of json -o ffuf-$1.json -p 0.1 -t 10 
cat ffuf-$1.json | jq -r '.results[] | "\(.length)"+ " " +"\(.url)" + " " + "\(.status)"' | sort -unt " " -k "1,1" | tee result-$1
rm ffuf-$1.json
