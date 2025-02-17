mkdir amass
file=$1
for x in $(cat $file)
do
amass enum -passive -norecursive -noalts -d $x >> amass/amass.txt
done
subfinder -dL $file | tee amass/sub.txt
cat amass/*.txt >> amass/all.txt
rm amass/amass.txt rm amass/sub.txt
cat amass/all.txt | sort -u | tee amass/sub.txt
rm amass/all.txt
