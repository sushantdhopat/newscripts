#!/bin/bash

# Target domain and wordlist
target=$1
wordlist=/root/permutation.txt

# Check for correct number of arguments
if [ $# -gt 2 ]; then
       echo "./perm.sh <domain>"
       echo "./perm.sh google.com"
       exit 1
fi

# Create 'perm' directory if it doesn't exist
if [ ! -d perm ]; then
       mkdir perm
else
    echo "Sorry, we can't create the same directory in the same location. Please remove the existing 'perm' folder first. Thanks!"
    exit 1
fi

# Step 1: Run DNSGen for permutations
echo -e "\e[1;34m [+] Running dnsgen for permutations \e[0m"
cat $target | dnsgen -w $wordlist - | tee perm/dnsgen.txt

# Step 2: Split the target list into chunks of 100 lines for Gotator
echo -e "\e[1;34m [+] Splitting target list for Gotator \e[0m"
split -l 100 $target target_split_

# Step 3: Run Gotator in parallel for each split file
echo -e "\e[1;34m [+] Running Gotator in parallel \e[0m"
for t in target_split_*; do
    timeout 3h gotator -sub $t -perm $wordlist -depth 3 -numbers 5 -md | uniq >> perm/gotator.txt &
done

# Wait for all Gotator processes to finish
wait

# Step 4: Clean up temporary split files
echo -e "\e[1;34m [+] Cleaning up temporary split files \e[0m"
rm -f target_split_*

# Step 5: Combine and sort the outputs from both DNSGen and Gotator
echo -e "\e[1;34m [+] Combining and sorting outputs \e[0m"
cat perm/dnsgen.txt perm/gotator.txt | sort -u | tee perm/final_output.txt

# Final message
echo -e "\e[1;32m [+] Permutation process completed! Final sorted output saved in 'perm/final_output.txt'. \e[0m"
