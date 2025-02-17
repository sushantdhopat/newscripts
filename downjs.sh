echo -e "${GREEN}Start download js file ${ENDCOLOR}"
mkdir jsfile
  for x in $(cat $1 )
  do
  wget -P jsfile $x
  done
