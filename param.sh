echo -e "${GREEN}Start Parameter Discovery:${ENDCOLOR} "
  for x in $(cat $1 )
  do
  python3 /Users/sushantdhopat/desktop/paramspider/paramspider.py --domain $x &>/dev/null
  done
  cat output/http:/*.txt >> newurls.txt
  cat output/https:/*.txt >> newurls.txt
  rm -rf output
